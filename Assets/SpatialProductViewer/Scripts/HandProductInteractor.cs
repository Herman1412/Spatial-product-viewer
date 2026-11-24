using UnityEngine;
using UnityEngine.XR.Interaction.Toolkit;
using UnityEngine.XR.Interaction.Toolkit.Interactors;

namespace SpatialProductViewer
{
    [DisallowMultipleComponent, RequireComponent(typeof(NearFarInteractor))]
    public sealed class HandProductInteractor : MonoBehaviour
    {
        [SerializeField]
        NearFarInteractor interactor;
        [SerializeField]
        ProductSelectionController selectionController;

        void Awake()
        {
            if (!interactor)
            {
                interactor = GetComponent<NearFarInteractor>();
            }
        }

        void OnEnable()
        {
            if (!interactor)
            {
                interactor = GetComponent<NearFarInteractor>();
            }

            interactor.selectEntered.AddListener(OnSelected);
        }

        void OnDisable()
        {
            if (interactor)
            {
                interactor.selectEntered.RemoveListener(OnSelected);
            }
        }

        void OnSelected(SelectEnterEventArgs args)
        {
            if (interactor.TryGetCurrentUIRaycastResult(out _))
            {
                return;
            }

            var product = args.interactableObject.transform.GetComponent<SelectableProduct>();
            if (!product)
            {
                return;
            }

            if (!selectionController)
            {
                selectionController = FindAnyObjectByType<ProductSelectionController>();
            }

            if (selectionController)
            {
                selectionController.Select(product);
            }
        }
    }
}
