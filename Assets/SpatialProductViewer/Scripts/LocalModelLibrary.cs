using System;
using System.Collections.Generic;
using System.IO;
using System.Threading.Tasks;
using GLTFast;
using GLTFast.Loading;
using Gsplat;
using UnityEngine;

#if UNITY_EDITOR
using UnityEditor;

#endif
namespace SpatialProductViewer
{
    [DisallowMultipleComponent]
    public sealed class LocalModelLibrary : MonoBehaviour
    {
        [SerializeField]
        ProductCatalogController catalog;
        [SerializeField]
        SelectableProduct importedProductPrefab;
        [SerializeField]
        SelectableProduct importedGaussianPrefab;
        [SerializeField, Min(1)]
        int maximumSplatsPerModel = 250000;
        [SerializeField, Min(1)]
        int maximumLibrarySplats = 750000;
        [SerializeField]
        Transform inactiveTemplates;
        [SerializeField]
        ModelThumbnailStudio thumbnailStudio;

        readonly List<GltfImport> retainedImports = new List<GltfImport>();
        readonly List<GsplatAsset> retainedGaussians = new List<GsplatAsset>();
        readonly List<ProductDefinition> definitions = new List<ProductDefinition>();
        readonly List<Sprite> thumbnails = new List<Sprite>();
        GltfImport pendingImport;
        GsplatAsset pendingGaussian;
        SelectableProduct pendingTemplate;
        byte[] pendingBytes;
        string pendingName;
        string pendingExtension;
        bool choosingFile;
#if UNITY_ANDROID && !UNITY_EDITOR
        bool applicationPaused;
        int resumeFrame;
        float nextPickerPoll;
        void OnApplicationPause(bool paused)
        {
            applicationPaused = paused;
            resumeFrame = Time.frameCount;
        }

        void OnApplicationFocus(bool focused)
        {
            if (focused)
            {
                resumeFrame = Time.frameCount;
            }
        }

        void Update()
        {
            if (!choosingFile || applicationPaused || !Application.isFocused || Time.frameCount - resumeFrame < 3 || Time.unscaledTime < nextPickerPoll)
            {
                return;
            }

            nextPickerPoll = Time.unscaledTime + 0.1f;
            try
            {
                using var picker = new AndroidJavaClass("com.spatialproductviewer.importing.LocalModelPickerActivity");
                string result = picker.CallStatic<string>("takeResult", gameObject.name);
                if (string.IsNullOrEmpty(result))
                {
                    return;
                }

                if (result.StartsWith("file:", StringComparison.Ordinal))
                {
                    Debug.Log("[ModelImport] File picker closed; processing selected file after application resume.", this);
                    OnFilePicked(result.Substring(5));
                }
                else
                {
                    OnFilePickerError(result.StartsWith("error:", StringComparison.Ordinal) ? result.Substring(6) : "Invalid file picker response.");
                }
            }
            catch (Exception e)
            {
                OnFilePickerError("Could not retrieve the selected file: " + e.Message);
            }
        }

#endif
        public event Action Changed;

        public bool Busy { get; private set; }
        public bool IsReady { get; private set; }
        public bool HasPending => pendingTemplate;
        public Vector3 NativeDimensions { get; private set; }
        public Vector3 SuggestedDimensions { get; private set; }
        public string PendingName => pendingName;
        public string Message { get; private set; } = "Choose a local GLB or Gaussian PLY / SPZ / SPLAT. Files stay on this device.";

        string StorageRoot
        {
            get
            {
#if UNITY_EDITOR
                return Path.Combine(Path.GetDirectoryName(Application.dataPath), "UserSettings", "LocalModelLibrary");
#else
                return Application.persistentDataPath;
#endif
            }
        }

        string LibraryPath => Path.Combine(StorageRoot, "ProductLibrary");

        [Serializable]
        sealed class Entry
        {
            public int version = 2;
            public string displayName;
            public Vector3 dimensionsMeters;
            public string modelFile = "model.glb";
        }

        async void Start()
        {
            Busy = true;
            try
            {
                Directory.CreateDirectory(LibraryPath);
                int loaded = 0;
                int failed = 0;
                var folders = Directory.GetDirectories(LibraryPath);
                Array.Sort(folders, StringComparer.Ordinal);
                foreach (var folder in folders)
                {
                    if (!Guid.TryParseExact(Path.GetFileName(folder), "N", out _))
                    {
                        continue;
                    }

                    if (!catalog.HasImportSlot)
                    {
                        break;
                    }

                    try
                    {
                        var entry = JsonUtility.FromJson<Entry>(File.ReadAllText(Path.Combine(folder, "product.json")));
                        if (entry == null
                            || (entry.version != 1
                            && entry.version != 2)
                            || !LocalModelFiles.ValidSize(entry.dimensionsMeters))
                        {
                            throw new InvalidDataException("Invalid saved dimensions.");
                        }

                        string file = entry.version == 1 ? "model.glb" : entry.modelFile;
                        if (file != "model.glb" && file != "model.ply" && file != "model.spz" && file != "model.splat")
                        {
                            throw new InvalidDataException("Invalid saved model format.");
                        }

                        SetMessage($"Loading saved models ({loaded + 1})...");
                        await PrepareAsync(Path.Combine(folder, file));
                        destroyCancellationToken.ThrowIfCancellationRequested();
                        AddToCatalog(Path.GetFileName(folder), entry.displayName, entry.dimensionsMeters);
                        loaded++;
                    }
                    catch (OperationCanceledException)
                    {
                        return;
                    }
                    catch (Exception e)
                    {
                        failed++;
                        ClearPending();
                        Debug.LogWarning($"Could not restore local model: {e.Message}", this);
                    }
                }

                SetMessage(failed > 0
                    ? $"Restored {loaded} model(s); {failed} could not be read. Their files were kept."
                    : loaded > 0
                        ? $"Restored {loaded} local model(s). Choose another model to import."
                        : Message);
            }
            catch (Exception e)
            {
                SetMessage("Could not open the local library: " + e.Message);
            }
            finally
            {
                Busy = false;
                IsReady = true;
                Changed?.Invoke();
            }
        }

        public void ChooseFile()
        {
            if (Busy || choosingFile)
            {
                return;
            }

            if (!catalog.HasImportSlot)
            {
                SetMessage("Your local model library is full.");
                return;
            }

#if UNITY_EDITOR
            var path = EditorUtility.OpenFilePanelWithFilters("Import a local model", "", new[] { "GLB or Gaussian model", "glb,ply,spz,splat" });
            if (!string.IsNullOrEmpty(path))
            {
                OnFilePicked(path);
            }
#elif UNITY_ANDROID
            try
            {
                using var player = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
                using var activity = player.GetStatic<AndroidJavaObject>("currentActivity");
                using var picker = new AndroidJavaClass("com.spatialproductviewer.importing.LocalModelPickerActivity");
                choosingFile = true;
                nextPickerPoll = 0;
                SetMessage("Choose a GLB, Gaussian PLY, SPZ or SPLAT in the system file picker.");
                picker.CallStatic("open", activity, gameObject.name);
            }
            catch (Exception e)
            {
                choosingFile = false;
                SetMessage("The system file picker could not be opened. Please try again.");
                Debug.LogWarning(e.Message, this);
            }
#else
            SetMessage("Local file selection is supported in the Unity Editor and on Quest.");
#endif
        }

        [UnityEngine.Scripting.Preserve]
        public async void OnFilePicked(string path)
        {
            choosingFile = false;
            if (Busy)
            {
                return;
            }

            Busy = true;
            try
            {
                if (!catalog.HasImportSlot)
                {
                    throw new InvalidOperationException("Your local model library is full.");
                }

                ClearPending();
                SetMessage("Reading model...");
                await PrepareAsync(path);
                destroyCancellationToken.ThrowIfCancellationRequested();
                string scaleMessage = SuggestedDimensions == NativeDimensions
                    ? "Using the file's metre units. Enter a known size, or use Fit to 50 cm if the scale is unknown."
                    : "File units look unsuitable for a product. Estimated size: longest side 50 cm. Enter known dimensions for accuracy.";
                SetMessage(pendingGaussian
                    ? $"{pendingGaussian.SplatCount:N0} Gaussian splats. Estimated longest side: 50 cm. Enter a known dimension for accurate scale, or use file units."
                    : scaleMessage);
                Debug.Log("[ModelImport] Model ready for dimension controls.", this);
            }
            catch (OperationCanceledException)
            {
            }
            catch (Exception e)
            {
                ClearPending();
                SetMessage("Import failed: " + e.Message);
                Debug.LogWarning("[ModelImport] " + e.Message, this);
            }
            finally
            {
                Busy = false;
                Changed?.Invoke();
            }
        }

        [UnityEngine.Scripting.Preserve]
        public void OnFilePickerError(string reason)
        {
            choosingFile = false;
            SetMessage(reason);
        }

        async Task PrepareAsync(string path)
        {
            pendingExtension = Path.GetExtension(path).ToLowerInvariant();
            bool gaussian = GaussianModelFiles.Supports(pendingExtension);
            if (pendingExtension != ".glb" && !gaussian)
            {
                throw new InvalidDataException("Choose a GLB or Gaussian PLY, SPZ or SPLAT file.");
            }

            var info = new FileInfo(path);
            if (!info.Exists || info.Length > LocalModelFiles.MaximumBytes)
            {
                throw new InvalidDataException("Choose an existing model smaller than 64 MB.");
            }

            Debug.Log("[ModelImport] Reading " + pendingExtension + " file (" + info.Length + " bytes).", this);
            pendingBytes = await File.ReadAllBytesAsync(path, destroyCancellationToken);
            Debug.Log("[ModelImport] Local file read complete.", this);
            pendingName = Path.GetFileNameWithoutExtension(path);
            if (!inactiveTemplates || inactiveTemplates.gameObject.activeInHierarchy)
            {
                throw new InvalidOperationException("Assign inactive template storage in Unity.");
            }

            if (gaussian)
            {
                if (!importedGaussianPrefab)
                {
                    throw new InvalidOperationException("Assign ImportedGaussianProduct.prefab in the local library.");
                }

                var cancellation = destroyCancellationToken;
                var bytes = pendingBytes;
                var extension = pendingExtension;
                var maximum = maximumSplatsPerModel;
                Debug.Log("[ModelImport] Decoding Gaussian data on a worker.", this);
                var prepared = await Task.Run(() =>
                {
                    var data = GaussianModelFiles.Decode(bytes, extension, maximum, cancellation);
                    float units = GaussianModelFiles.NormalizeForPacking(data, cancellation);
                    return (data, units);
                }, cancellation);
                var decoded = prepared.data;
                cancellation.ThrowIfCancellationRequested();
                long total = decoded.Count;
                foreach (var asset in retainedGaussians)
                {
                    if (asset)
                    {
                        total += asset.SplatCount;
                    }
                }

                if (total > maximumLibrarySplats)
                {
                    throw new InvalidDataException($"The local library limit is {maximumLibrarySplats:N0} Gaussian splats in total. Use smaller captures.");
                }

                pendingGaussian = ScriptableObject.CreateInstance<GsplatAssetSpark>();
                pendingGaussian.name = pendingName;
                Debug.Log("[ModelImport] Packing " + decoded.Count + " Gaussian splats.", this);
                pendingGaussian.LoadFromDecoded(decoded);
                pendingTemplate = Instantiate(importedGaussianPrefab, inactiveTemplates, false);
                pendingTemplate.gameObject.SetActive(false);
                pendingTemplate.transform.localScale = Vector3.one;
                pendingTemplate.name = pendingName;
                pendingTemplate.GetComponent<GaussianProduct>().SetAsset(pendingGaussian, prepared.units);
                pendingTemplate.ConfigureImportedModel();
                SetDimensions(true);
                return;
            }

            Debug.Log("[ModelImport] Validating GLB data.", this);
            var glbBytes = pendingBytes;
            var validationCancellation = destroyCancellationToken;
            await Task.Run(() => LocalModelFiles.ValidateGlb(glbBytes), validationCancellation);
            validationCancellation.ThrowIfCancellationRequested();
            var logger = new GLTFast.Logging.CollectingLogger();
            pendingImport = new GltfImport(downloadProvider: new EmbeddedOnlyDownloads(), logger: logger);
            Debug.Log("[ModelImport] Loading GLB meshes and textures.", this);
            if (!await pendingImport.Load(
                pendingBytes,
                importSettings: new ImportSettings { AnimationMethod = AnimationMethod.None },
                cancellationToken: destroyCancellationToken
            ))
            {
                throw new InvalidDataException("glTFast could not load the model. Re-export an uncompressed GLB with embedded PNG/JPEG textures.");
            }

            destroyCancellationToken.ThrowIfCancellationRequested();
            if (!importedProductPrefab || !inactiveTemplates || inactiveTemplates.gameObject.activeInHierarchy)
            {
                throw new InvalidOperationException("Assign the imported-product prefab and inactive template storage in Unity.");
            }

            pendingTemplate = Instantiate(importedProductPrefab, inactiveTemplates, false);
            pendingTemplate.gameObject.SetActive(false);
            pendingTemplate.transform.localScale = Vector3.one;
            pendingTemplate.name = pendingName;
            Debug.Log("[ModelImport] Creating inactive GLB template.", this);
            var instantiator = new GameObjectInstantiator(
                pendingImport,
                pendingTemplate.transform,
                settings: new InstantiationSettings { Mask = ComponentType.Mesh }
            );
            if (!await pendingImport.InstantiateMainSceneAsync(instantiator, destroyCancellationToken))
            {
                throw new InvalidDataException("The GLB has no usable default scene.");
            }

            destroyCancellationToken.ThrowIfCancellationRequested();
            pendingTemplate.ConfigureImportedModel();
            if (logger.Items != null)
            {
                foreach (var item in logger.Items)
                {
                    if (item.Type == LogType.Error)
                    {
                        throw new InvalidDataException("A model resource could not be loaded: " + item.ToString());
                    }
                }
            }

            SetDimensions();
        }

        void SetDimensions(bool unknownUnits = false)
        {
            NativeDimensions = pendingTemplate.GetLocalBounds().size;
            if (!LocalModelFiles.ValidSize(NativeDimensions))
            {
                throw new InvalidDataException("The model has empty, flat or invalid bounds.");
            }

            float longest = Mathf.Max(NativeDimensions.x, NativeDimensions.y, NativeDimensions.z);
            SuggestedDimensions = unknownUnits || longest < 0.01f || longest > 10f
                ? LocalModelFiles.FitToHalfMetre(NativeDimensions)
                : NativeDimensions;
        }

        public bool Commit(string title, Vector3 dimensions)
        {
            if (Busy || !HasPending)
            {
                return false;
            }

            if (!catalog.HasImportSlot)
            {
                SetMessage("Your local model library is full.");
                return false;
            }

            string temporary = null;
            try
            {
                if (!LocalModelFiles.ValidSize(dimensions))
                {
                    throw new InvalidDataException("Invalid model dimensions.");
                }

                title = string.IsNullOrWhiteSpace(title) ? pendingName : title.Trim();
                if (title.Length > 64)
                {
                    title = title.Substring(0, 64);
                }

                var id = Guid.NewGuid().ToString("N");
                temporary = Path.Combine(LibraryPath, ".pending-" + id);
                Directory.CreateDirectory(temporary);
                string modelFile = "model" + pendingExtension;
                File.WriteAllBytes(Path.Combine(temporary, modelFile), pendingBytes);
                File.WriteAllText(
                    Path.Combine(temporary, "product.json"),
                    JsonUtility.ToJson(
                        new Entry { displayName = title, dimensionsMeters = dimensions, modelFile = modelFile },
                        true
                    )
                );
                Directory.Move(temporary, Path.Combine(LibraryPath, id));
                temporary = null;
                AddToCatalog(id, title, dimensions);
                catalog.ShowImported();
                SetMessage("Added " + title + ". It is saved on this device and ready to spawn.");
                return true;
            }
            catch (Exception e)
            {
                SetMessage("Could not save model: " + e.Message);
                return false;
            }
            finally
            {
                if (temporary != null && Directory.Exists(temporary))
                {
                    Directory.Delete(temporary, true);
                }
            }
        }

        void AddToCatalog(string id, string title, Vector3 dimensions)
        {
            Sprite image = thumbnailStudio ? thumbnailStudio.Capture(pendingTemplate, dimensions) : null;
            var definition = ScriptableObject.CreateInstance<ProductDefinition>();
            definition.ConfigureImported(title, dimensions, pendingTemplate, image);
            definition.SetPersistentId("import:" + id);
            if (!catalog.AddImported(definition))
            {
                Destroy(definition);
                if (image)
                {
                    Destroy(image.texture);
                    Destroy(image);
                }

                throw new InvalidOperationException("No imported-model slot is available.");
            }

            definitions.Add(definition);
            if (image)
            {
                thumbnails.Add(image);
            }

            if (pendingImport != null)
            {
                retainedImports.Add(pendingImport);
            }

            if (pendingGaussian)
            {
                retainedGaussians.Add(pendingGaussian);
            }

            pendingImport = null;
            pendingGaussian = null;
            pendingTemplate = null;
            pendingBytes = null;
        }

        public void CancelPending()
        {
            if (!Busy)
            {
                ClearPending();
                Changed?.Invoke();
            }
        }

        void ClearPending()
        {
            if (pendingTemplate)
            {
                Destroy(pendingTemplate.gameObject);
            }

            pendingTemplate = null;
            pendingBytes = null;
            pendingImport?.Dispose();
            pendingImport = null;
            if (pendingGaussian)
            {
                Destroy(pendingGaussian);
            }

            pendingGaussian = null;
        }

        void SetMessage(string value)
        {
            Message = value;
            Changed?.Invoke();
        }

        void OnDestroy()
        {
            ClearPending();
            foreach (var importer in retainedImports)
            {
                importer.Dispose();
            }

            foreach (var asset in retainedGaussians)
            {
                if (asset)
                {
                    Destroy(asset);
                }
            }

            foreach (var definition in definitions)
            {
                if (definition)
                {
                    Destroy(definition);
                }
            }

            foreach (var sprite in thumbnails)
            {
                if (sprite)
                {
                    Destroy(sprite.texture);
                    Destroy(sprite);
                }
            }
        }

        sealed class EmbeddedOnlyDownloads : IDownloadProvider
        {
            public Task<IDownload> Request(Uri uri)
            {
                throw new InvalidDataException("External model resources are disabled. Use a self-contained GLB.");
            }

            public Task<ITextureDownload> RequestTexture(Uri uri, bool nonReadable)
            {
                throw new InvalidDataException("External textures are disabled. Embed textures in the GLB.");
            }
        }
    }
}
