# Spatial Product Viewer

Unity mixed reality product viewer for Meta Quest 3 / 3S.

## Setup

1. Install **Unity 6000.6.9f1** through Unity Hub with **Android Build Support**, **Android SDK & NDK Tools**, and **OpenJDK**.
2. Clone or download this project and add its root folder to Unity Hub. Keep the embedded packages under `Packages/` included.
3. Open the project and wait for Package Manager and asset imports to finish. Dependencies restore from `Packages/manifest.json` and `packages-lock.json`.
4. If the XR Hands sample is absent, open **Window > Package Management > Package Manager**, select **XR Hands > Samples**, and import **HandVisualizer**. The installed 1.9.0 sample retains the GUIDs used by this project. Do not import a second copy if the existing sample is present.
5. Open `Assets/Scenes/QuestFoundation.unity`.

## Build for Quest

1. Open **File > Build Profiles**, select **Meta Quest** (or **Android** if Quest is unavailable), and switch platform.
2. Ensure `Assets/Scenes/QuestFoundation.unity` is enabled in the scene list. The project already configures **OpenXR / Meta Quest**, **Vulkan**, **IL2CPP**, and **ARM64**.
3. Choose **Build** and save the APK under `Builds/`. For **Build and Run**, enable Developer Mode on the headset, connect it by USB, and accept its USB debugging prompt.
4. Complete **Space Setup** on the headset and grant the app spatial-data permission to use room surfaces, snapping, and occlusion. Enable hand tracking in the headset settings to use hands.

Model credits and publication requirements: [asset licence review](Assets/SpatialProductViewer/Models/Curated/MODEL_IMPORT_REPORT.md#public-repository-licence-review-2026-11-24).
