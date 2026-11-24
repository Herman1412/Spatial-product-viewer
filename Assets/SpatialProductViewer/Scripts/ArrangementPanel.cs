using System;
using UnityEngine;
using UnityEngine.UI;

namespace SpatialProductViewer
{
    [DisallowMultipleComponent]
    public sealed class ArrangementPanel : MonoBehaviour
    {
        [SerializeField]
        ArrangementManager manager;
        [SerializeField]
        GameObject panel;
        [SerializeField]
        GameObject catalogPanel;
        [SerializeField]
        InputField layoutName;
        [SerializeField]
        Text message;
        [SerializeField]
        Text[] slotTitles;
        [SerializeField]
        Text[] slotDetails;
        [SerializeField]
        SelectionMenuGraphic[] slotGraphics;
        [SerializeField]
        Button saveButton;
        [SerializeField]
        Button loadButton;
        [SerializeField]
        Button nearButton;
        [SerializeField]
        Text saveLabel;
        [SerializeField]
        Text loadLabel;
        [SerializeField]
        Text nearLabel;

        readonly ArrangementData[] saves = new ArrangementData[ArrangementStore.SlotCount];
        readonly bool[] unreadable = new bool[ArrangementStore.SlotCount];
        int selected;
        string confirmation;
        bool wasReady;

        public void Open()
        {
            catalogPanel.SetActive(false);
            panel.SetActive(true);
            RefreshSlots();
            SelectSlot(selected);
        }

        public void Close()
        {
            confirmation = null;
            panel.SetActive(false);
            catalogPanel.SetActive(true);
        }

        public void SelectSlot(int index)
        {
            if (index < 0 || index >= ArrangementStore.SlotCount)
            {
                return;
            }

            selected = index;
            confirmation = null;
            layoutName.SetTextWithoutNotify(saves[index] != null ? saves[index].name : "Layout " + (index + 1));
            for (int i = 0; i < slotGraphics.Length; i++)
            {
                slotGraphics[i].BorderColor = i == selected ? new Color(0.35f, 0.95f, 1, 1) : new Color(0.65f, 0.9f, 1, 0.35f);
            }

            message.text = unreadable[index]
                ? "This slot is unreadable. Saving here will replace it after confirmation."
                : saves[index] == null
                    ? "Arrange your products, enter a name, then Save."
                    : string.IsNullOrEmpty(saves[index].frameId)
                        ? "Saved in tracking space. Use Place near me after changing spaces."
                        : "Load restores the saved room positions. Place near me moves the whole layout together.";
            RefreshButtons();
        }

        public void Save()
        {
            if (!manager.Ready)
            {
                return;
            }

            if ((saves[selected] != null || unreadable[selected]) && confirmation != "save")
            {
                confirmation = "save";
                message.text = "Save again to overwrite this slot with the current products.";
                RefreshButtons();
                return;
            }

            manager.Save(selected, layoutName.text, out var result);
            confirmation = null;
            RefreshSlots();
            message.text = result;
            RefreshButtons();
        }

        public void Load()
        {
            Load(false);
        }

        public void PlaceNearMe()
        {
            Load(true);
        }

        void Load(bool near)
        {
            if (!manager.Ready || saves[selected] == null)
            {
                return;
            }

            string action = near ? "near" : "load";
            if (ArrangementManager.PlacedProducts().Length > 0 && confirmation != action)
            {
                confirmation = action;
                message.text = "This replaces all currently placed products. Press the same button again to continue, or choose another action to cancel.";
                RefreshButtons();
                return;
            }

            manager.Load(selected, near, out var result);
            confirmation = null;
            message.text = result;
            RefreshButtons();
        }

        public void NameChanged(string _)
        {
            confirmation = null;
            RefreshButtons();
        }

        void Update()
        {
            if (!panel || !panel.activeSelf || wasReady == manager.Ready)
            {
                return;
            }

            if (manager.Ready)
            {
                message.text = "Ready. Select a slot to save or load.";
            }

            RefreshButtons();
        }

        void RefreshSlots()
        {
            for (int i = 0; i < saves.Length; i++)
            {
                saves[i] = null;
                unreadable[i] = false;
                try
                {
                    saves[i] = ArrangementStore.Read(manager.StoragePath, i, out bool recovered);
                    slotTitles[i].text = (i + 1) + "   " + (saves[i]?.name ?? "Empty slot");
                    slotDetails[i].text = saves[i] == null
                        ? "Ready for a new layout"
                        : $"{saves[i].products.Count} product(s)  /  {DateTime.Parse(saves[i].savedUtc).ToLocalTime():dd MMM yyyy, HH:mm}"
                        + (recovered
                            ? "  /  backup"
                            : "");
                }
                catch (Exception)
                {
                    unreadable[i] = true;
                    slotTitles[i].text = (i + 1) + "   Unreadable save";
                    slotDetails[i].text = "Current products will be kept";
                }
            }
        }

        void RefreshButtons()
        {
            wasReady = manager.Ready;
            saveButton.interactable = manager.Ready;
            loadButton.interactable = nearButton.interactable = manager.Ready && saves[selected] != null;
            saveLabel.text = confirmation == "save" ? "Overwrite save" : "Save layout";
            loadLabel.text = confirmation == "load" ? "Replace & load" : "Load in room";
            nearLabel.text = confirmation == "near" ? "Replace & place" : "Place near me";
            if (!manager.Ready)
            {
                message.text = "Loading local models. Arrangement controls will be ready shortly.";
            }
        }
    }
}
