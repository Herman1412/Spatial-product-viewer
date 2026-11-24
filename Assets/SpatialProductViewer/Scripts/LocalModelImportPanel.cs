using UnityEngine;
using UnityEngine.UI;

namespace SpatialProductViewer
{
    public sealed class LocalModelImportPanel : MonoBehaviour
    {
        [SerializeField]
        LocalModelLibrary library;
        [SerializeField]
        GameObject panel;
        [SerializeField]
        GameObject catalogPanel;
        [SerializeField]
        InputField productName;
        [SerializeField]
        InputField widthCm;
        [SerializeField]
        InputField heightCm;
        [SerializeField]
        InputField depthCm;
        [SerializeField]
        Text measuredSize;
        [SerializeField]
        Text message;
        [SerializeField]
        Button addButton;
        [SerializeField]
        Button chooseButton;
        [SerializeField]
        Button fitButton;
        [SerializeField]
        Button unitsButton;
        [SerializeField]
        Button closeButton;

        string lastPending;
        Vector3 sourceDimensions;

        void OnEnable()
        {
            if (!library)
            {
                library = FindAnyObjectByType<LocalModelLibrary>();
            }

#if UNITY_ANDROID && !UNITY_EDITOR
            foreach (var input in new[] { widthCm, heightCm, depthCm })
            {
                input.keyboardType = TouchScreenKeyboardType.Default;
                input.characterValidation = InputField.CharacterValidation.Decimal;
            }

#endif
            if (library)
            {
                library.Changed += Refresh;
            }

            Refresh();
        }

        void OnDisable()
        {
            if (library)
            {
                library.Changed -= Refresh;
            }
        }

        public void Open()
        {
            if (catalogPanel)
            {
                catalogPanel.SetActive(false);
            }

            panel.SetActive(true);
            Refresh();
        }

        public void Close()
        {
            if (library.Busy)
            {
                return;
            }

            library.CancelPending();
            lastPending = null;
            panel.SetActive(false);
            if (catalogPanel)
            {
                catalogPanel.SetActive(true);
            }
        }

        public void Choose()
        {
            library.ChooseFile();
        }

        public void FitTo50Cm()
        {
            if (!library.HasPending)
            {
                return;
            }

            sourceDimensions = LocalModelFiles.FitToHalfMetre(library.NativeDimensions);
            ClearDimensions();
            Refresh();
        }

        public void UseFileUnits()
        {
            if (!library.HasPending)
            {
                return;
            }

            sourceDimensions = library.NativeDimensions;
            ClearDimensions();
            Refresh();
        }

        void ClearDimensions()
        {
            widthCm.text = "";
            heightCm.text = "";
            depthCm.text = "";
        }

        public void DimensionsChanged(string _)
        {
            if (!library || !library.HasPending || library.Busy)
            {
                return;
            }

            bool valid = LocalModelFiles.TryDimensions(sourceDimensions, widthCm.text, heightCm.text, depthCm.text, out var size, out var error);
            addButton.interactable = valid;
            measuredSize.text = valid
                ? $"Product size: {size.x * 100f:0.#} × {size.y * 100f:0.#} × {size.z * 100f:0.#} cm"
                : "Check the dimensions below";
            message.text = valid ? library.Message : error;
        }

        public void Add()
        {
            if (!LocalModelFiles.TryDimensions(sourceDimensions, widthCm.text, heightCm.text, depthCm.text, out var size, out var error))
            {
                message.text = error;
                return;
            }

            if (library.Commit(productName.text, size))
            {
                lastPending = null;
                panel.SetActive(false);
                if (catalogPanel)
                {
                    catalogPanel.SetActive(true);
                }
            }
        }

        void Refresh()
        {
            if (!library)
            {
                return;
            }

            bool ready = library.HasPending && !library.Busy;
            if (ready && lastPending != library.PendingName)
            {
                lastPending = library.PendingName;
                productName.text = library.PendingName;
                sourceDimensions = library.SuggestedDimensions;
                ClearDimensions();
            }

            if (!library.HasPending)
            {
                lastPending = null;
            }

            measuredSize.text = ready
                ? $"Current size: {sourceDimensions.x * 100f:0.#} × {sourceDimensions.y * 100f:0.#} × {sourceDimensions.z * 100f:0.#} cm"
                : "Model size appears after choosing a file";
            message.text = library.Message;
            addButton.interactable = fitButton.interactable = unitsButton.interactable = ready;
            chooseButton.interactable = closeButton.interactable = !library.Busy;
            productName.interactable = widthCm.interactable = heightCm.interactable = depthCm.interactable = ready;
            if (ready)
            {
                DimensionsChanged("");
            }
        }
    }
}
