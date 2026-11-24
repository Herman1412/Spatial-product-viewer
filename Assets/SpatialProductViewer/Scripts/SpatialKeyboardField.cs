using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

namespace SpatialProductViewer
{
    [DisallowMultipleComponent, RequireComponent(typeof(InputField))]
    public sealed class SpatialKeyboardField : MonoBehaviour,
        IPointerClickHandler,
        IPointerDownHandler,
        ISelectHandler,
        IPointerEnterHandler,
        IPointerExitHandler
    {
        [SerializeField]
        InputField input;
        [SerializeField]
        SpatialTextKeyboard keyboard;
        [SerializeField]
        RectTransform keyboardAnchor;
        [SerializeField]
        string caption = "Text";

        SelectionMenuGraphic graphic;
        Color originalBorder;
        bool originalEnabled;
        bool hovered;
        bool numericValidatorInstalled;

        public InputField Input => input;
        public RectTransform KeyboardAnchor => keyboardAnchor;
        public string Caption => caption;
        public bool CanEdit => isActiveAndEnabled
            && originalEnabled
            && input
            && input.interactable
            && !input.readOnly
            && gameObject.activeInHierarchy;

        void OnEnable()
        {
            if (!input)
            {
                input = GetComponent<InputField>();
            }

            if (!Application.IsPlaying(gameObject))
            {
                return;
            }

            originalEnabled = input.enabled;
            input.enabled = false;
            if (input.onValidateInput == null
                && (input.characterValidation == InputField.CharacterValidation.Decimal
                || input.characterValidation == InputField.CharacterValidation.Integer))
            {
                input.onValidateInput = ValidateNumber;
                numericValidatorInstalled = true;
            }

            graphic = input.targetGraphic as SelectionMenuGraphic;
            if (graphic)
            {
                originalBorder = graphic.BorderColor;
            }
        }

        void OnDisable()
        {
            if (!Application.IsPlaying(gameObject))
            {
                return;
            }

            if (keyboard && keyboard.Target == this)
            {
                keyboard.Done();
            }

            if (input && numericValidatorInstalled && input.onValidateInput == ValidateNumber)
            {
                input.onValidateInput = null;
            }

            numericValidatorInstalled = false;
            if (input)
            {
                input.enabled = originalEnabled;
            }

            if (graphic)
            {
                graphic.BorderColor = originalBorder;
            }
        }

        public void Edit()
        {
            if (!Application.IsPlaying(gameObject) || !CanEdit)
            {
                return;
            }

            if (!keyboard)
            {
                keyboard = FindAnyObjectByType<SpatialTextKeyboard>();
            }

            if (keyboard)
            {
                keyboard.Show(this);
            }
            else
            {
                Debug.LogWarning("Assign the saved SpatialTextKeyboard prefab to this field.", this);
            }
        }

        char ValidateNumber(string value, int index, char character)
        {
            if (character >= '0' && character <= '9')
            {
                return character;
            }

            if (character == '-' && index == 0 && !value.Contains('-'))
            {
                return character;
            }

            if ((character == '.'
                || character == ',')
                && input.characterValidation == InputField.CharacterValidation.Decimal
                && value.IndexOfAny(new[] { '.', ',' }) < 0)
            {
                return '.';
            }

            return '\0';
        }

        public void OnPointerDown(PointerEventData data)
        {
            if (data.button == PointerEventData.InputButton.Left && CanEdit && EventSystem.current)
            {
                EventSystem.current.SetSelectedGameObject(gameObject, data);
            }
        }

        public void OnPointerClick(PointerEventData data)
        {
            if (data.button == PointerEventData.InputButton.Left)
            {
                Edit();
            }
        }

        public void OnSelect(BaseEventData data)
        {
            Edit();
        }

        public void OnPointerEnter(PointerEventData data)
        {
            hovered = true;
        }

        public void OnPointerExit(PointerEventData data)
        {
            hovered = false;
        }

        void LateUpdate()
        {
            if (graphic)
            {
                graphic.BorderColor = CanEdit && (hovered || (keyboard && keyboard.Target == this))
                    ? new Color(0.35f, 0.95f, 1, 1)
                    : originalBorder;
            }
        }
    }
}
