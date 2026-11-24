using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.UI;

namespace SpatialProductViewer
{
    public sealed class SpatialTextKeyboard : MonoBehaviour
    {
        [SerializeField]
        RectTransform panel;
        [SerializeField]
        Text title;
        [SerializeField]
        Text preview;
        [SerializeField]
        Text shiftLabel;
        [SerializeField]
        Text[] letterLabels;
        [SerializeField]
        Button[] textOnlyButtons;
        [SerializeField, Min(0.001f)]
        float panelGap = 0.12f;

        readonly Vector3[] corners = new Vector3[4];
        Keyboard physicalKeyboard;
        string originalText;
        bool shift;
        bool replaceSelection;

        public SpatialKeyboardField Target { get; private set; }
        public bool IsOpen => Target && panel && panel.gameObject.activeSelf;

        void Start()
        {
            if (!Target && panel)
            {
                panel.gameObject.SetActive(false);
            }
        }

        void OnDisable()
        {
            Done();
            Unsubscribe();
        }

        void Update()
        {
            if (Keyboard.current != physicalKeyboard)
            {
                Unsubscribe();
                physicalKeyboard = Keyboard.current;
                if (physicalKeyboard != null)
                {
                    physicalKeyboard.onTextInput += OnTextInput;
                }
            }

            if (!IsOpen || physicalKeyboard == null)
            {
                return;
            }

#if UNITY_ANDROID && !UNITY_EDITOR
            if (!Application.isFocused)
            {
                return;
            }

#endif
            if (physicalKeyboard.backspaceKey.wasPressedThisFrame)
            {
                Backspace();
            }
            else if (physicalKeyboard.deleteKey.wasPressedThisFrame)
            {
                Clear();
            }
            else if (physicalKeyboard.enterKey.wasPressedThisFrame || physicalKeyboard.numpadEnterKey.wasPressedThisFrame)
            {
                Done();
            }
            else if (physicalKeyboard.escapeKey.wasPressedThisFrame)
            {
                Cancel();
            }
            else if (physicalKeyboard.ctrlKey.isPressed && physicalKeyboard.aKey.wasPressedThisFrame)
            {
                replaceSelection = true;
            }
        }

        void Unsubscribe()
        {
            if (physicalKeyboard != null)
            {
                physicalKeyboard.onTextInput -= OnTextInput;
            }

            physicalKeyboard = null;
        }

        void OnTextInput(char value)
        {
#if UNITY_ANDROID && !UNITY_EDITOR
            if (!Application.isFocused)
            {
                return;
            }

#endif
            if (IsOpen
                && !char.IsControl(value)
                && physicalKeyboard != null
                && !physicalKeyboard.ctrlKey.isPressed
                && !physicalKeyboard.altKey.isPressed)
            {
                Type(value.ToString());
            }
        }

        public void Show(SpatialKeyboardField field)
        {
            if (!field || !field.CanEdit || !panel)
            {
                return;
            }

            if (Target == field && IsOpen)
            {
                return;
            }

            Done();
            Target = field;
            originalText = field.Input.text;
            shift = false;
            replaceSelection = false;
            panel.gameObject.SetActive(true);
            Refresh();
            Position();
        }

        public void Type(string value)
        {
            if (!IsOpen || !Target.CanEdit)
            {
                return;
            }

            if (shift)
            {
                value = value.ToUpperInvariant();
            }

            Target.Input.text = (replaceSelection ? "" : Target.Input.text) + value;
            replaceSelection = false;
            Refresh();
        }

        public void Backspace()
        {
            if (!IsOpen || !Target.CanEdit)
            {
                return;
            }

            string currentText = Target.Input.text;
            int textLength = currentText.Length;
            int charactersToRemove = textLength >= 2
                && char.IsLowSurrogate(currentText[textLength - 1])
                && char.IsHighSurrogate(currentText[textLength - 2])
                ? 2
                : 1;
            Target.Input.text = replaceSelection || textLength == 0
                ? ""
                : currentText.Substring(0, textLength - charactersToRemove);
            replaceSelection = false;
            Refresh();
        }

        public void Clear()
        {
            if (IsOpen && Target.CanEdit)
            {
                Target.Input.text = "";
                replaceSelection = false;
                Refresh();
            }
        }

        public void Shift()
        {
            shift = !shift;
            Refresh();
        }

        public void Done()
        {
            Close(false);
        }

        public void Cancel()
        {
            Close(true);
        }

        void Close(bool cancel)
        {
            var field = Target;
            Target = null;
            if (panel)
            {
                panel.gameObject.SetActive(false);
            }

            if (!field || !field.Input)
            {
                return;
            }

            if (cancel)
            {
                field.Input.text = originalText;
            }
            else
            {
                field.Input.onSubmit.Invoke(field.Input.text);
            }

            field.Input.onEndEdit.Invoke(field.Input.text);
        }

        void Refresh()
        {
            if (!Target)
            {
                return;
            }

            title.text = Target.Caption;
            preview.text = Target.Input.text + " |";
            if (shiftLabel)
            {
                shiftLabel.text = shift ? "SHIFT ON" : "Shift";
            }

            foreach (var label in letterLabels)
            {
                if (label)
                {
                    label.text = shift ? label.text.ToUpperInvariant() : label.text.ToLowerInvariant();
                }
            }

            var validation = Target.Input.characterValidation;
            bool numeric = validation == InputField.CharacterValidation.Decimal
                || validation == InputField.CharacterValidation.Integer;
            foreach (var button in textOnlyButtons)
            {
                if (button)
                {
                    button.interactable = !numeric;
                }
            }
        }

        void LateUpdate()
        {
            if (!Target)
            {
                return;
            }

            if (!Target.CanEdit)
            {
                Done();
                return;
            }

            Position();
        }

        void Position()
        {
            var panelAnchor = Target.KeyboardAnchor;
            if (!panelAnchor)
            {
                return;
            }

            panelAnchor.GetWorldCorners(corners);
            float keyboardScale = Mathf.Min(0.001f, Vector3.Distance(corners[0], corners[3]) / panel.rect.width);
            var parentWorldScale = panel.parent ? panel.parent.lossyScale : Vector3.one;
            panel.localScale = new Vector3(
                keyboardScale / Mathf.Abs(parentWorldScale.x),
                keyboardScale / Mathf.Abs(parentWorldScale.y),
                keyboardScale / Mathf.Abs(parentWorldScale.z)
            );

            panel.rotation = panelAnchor.rotation;
            panel.position = (corners[0] + corners[3]) * 0.5f
                - panelAnchor.up * (panelGap + panel.rect.height * keyboardScale * 0.5f)
                - panelAnchor.forward * 0.02f;
        }
    }
}
