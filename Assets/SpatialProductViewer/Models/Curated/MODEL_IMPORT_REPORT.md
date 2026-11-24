# Curated product catalog — import report

The saved catalog contains **27 products**: 15 Poly Haven models, seven selected Kenney models, two user-provided Sketchfab models, and three placeholder boxes. The scene still starts without preplaced products.

The original downloaded collection uses CC0 assets from [Poly Haven](https://polyhaven.com/license) and the [Kenney Furniture Kit](https://kenney.nl/assets/furniture-kit). Original creators and source pages are recorded below and in `catalog.json`. Kenney’s supplied license is retained at `Kenney/LICENSE.txt`.

## Public repository licence review (2026-11-24)

**The 24 bundled catalog model files can remain in a public Unity project under their published licences.** They comprise 15 Poly Haven models, seven Kenney Furniture Kit models, and two Sketchfab models. The three other catalog entries are Unity primitive placeholder boxes. Each GLB was checked against its recorded SHA-256; all 24 still match the original downloaded files.

| Assets | Licence | Public source repository |
| --- | --- | --- |
| All 15 models in `PolyHaven/`, with embedded textures | [CC0](https://polyhaven.com/license) | Redistribution is allowed, including the raw GLBs. Creator/source links remain in the table below and `catalog.json`. |
| All seven models and supplied isometric thumbnails in `Kenney/` | [CC0](https://kenney.nl/assets/furniture-kit) | Redistribution is allowed. The pack's original `Kenney/LICENSE.txt` is retained. |
| [A Bubble Seal](https://sketchfab.com/3d-models/a-bubble-seal-53d7a286c48e472d86a6625e5293d71c), by Hai Cau Tap Chung / Harry Lee | [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/) | Redistribution is allowed with author credit, source and licence links, and modification notes. Keep `Sketchfab/ATTRIBUTION.md` with the assets. The original creator spelling is retained there. |
| [PlayStation 5 - PS5](https://sketchfab.com/3d-models/playstation-5-ps5-862e45a52a414a9586d1849c58c6e8eb), by alzarac | [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/) | Same attribution conditions. Original GLB bytes are unchanged; wrapper scaling and generated previews are documented in `Sketchfab/ATTRIBUTION.md`. |

Both Sketchfab listings identify the licence as CC Attribution, consistent with their embedded GLB metadata. These are not noncommercial or editorial-only licences. CC BY does not grant trademark rights or imply endorsement; the PS5 name and branding remain Sony's. This review concerns the bundled model files and their associated images, rather than assigning a licence to the project's own code or every dependency.

### Preview images corrected

Poly Haven's [website terms, section 4](https://polyhaven.com/license) distinguish the CC0 asset downloads from website content, including asset example renders. The 15 previously downloaded website preview PNGs have therefore been **replaced with new 512 x 512 renders made locally in Unity from the bundled CC0 models**. The image paths and Unity sprite GUIDs are unchanged. Kenney thumbnails come from the supplied CC0 Furniture Kit archive; Sketchfab thumbnails were already rendered locally from their credited models.

### Unity template and sample models

The controller, UI and primitive FBX assets under `Assets/MRTemplateAssets/` and `Assets/Samples/XR Interaction Toolkit/3.5.1/` are Unity content, not CC0 catalog models. Their [Unity Companion License](https://unity.com/legal/licenses/unity-companion-license) allows distribution in connection with a Unity project. The original notices are restored as `Assets/MRTemplateAssets/LICENSE.md` and `Assets/Samples/XR Interaction Toolkit/LICENSE.md`. Retain these notices and the Unity-use restrictions; do not relabel these assets as MIT or CC0.

**Exclude `Assets/Samples/XR Hands/1.8.1/HandVisualizer/` from a public source snapshot unless you obtain separate permission.** This includes the four `Models/*.fbx` hand meshes and the rest of the sample. The [XR Hands 1.8.1 licence notice](https://docs.unity3d.com/Packages/com.unity.xr.hands@1.8/license/LICENSE.html) specifies the [Unity Package Distribution License](https://unity.com/legal/licenses/unity-package-distribution-license), whose distribution grant is limited to binaries integrated into project content. No separate source-redistribution grant was found for this sample. Adding a credit file alone does not resolve that restriction.

The sample is left intact in this working project so hand tracking continues to work. For a public copy, omit the sample and let each developer import **XR Hands > Samples > HandVisualizer** through Package Manager after opening the project. The currently installed XR Hands 1.9.0 sample preserves all 27 corresponding asset GUIDs from the saved 1.8.1 sample, including all four FBX GUIDs; README setup covers that import. Keep the package dependency in the manifest, and let Unity obtain it from its registry rather than committing `Library/PackageCache`.

### Before publishing existing Git history

Replacing a file only changes the current revision. The old Poly Haven website preview PNGs and the XR Hands sample have already been committed locally and remain available in earlier commits. Publish a clean snapshot with those files excluded/replaced, or remove the restricted versions from every branch/tag being published before making an existing repository public. Merely adding `.gitignore` rules does not remove tracked files or historical blobs. No files have been removed from Git's index and no history has been rewritten by this review.

Keep the source credits, `catalog.json`, `Sketchfab/ATTRIBUTION.md`, Kenney licence and Unity notices alongside their assets. Runtime imports and test captures under ignored local data/build directories are not part of this catalog review; check their own licences if you later bundle them.

## Added products

Dimensions below are **width × height × depth**, in centimeters, measured from the imported geometry after the stated size calibration. They match the saved product definitions and the catalog cards. The popup measures the current product bounds, so resizing updates its dimensions.

| Product / source | Creator | W × H × D (cm) | Triangles | Material slots |
| --- | --- | --- | ---: | ---: |
| [Modern Arm Chair 01](https://polyhaven.com/a/modern_arm_chair_01) | Vibrant Nordic | 82 × 102.3 × 98.7 | 8,916 | 2 |
| [Mid Century Lounge Chair](https://polyhaven.com/a/mid_century_lounge_chair) | Kuutti Siitonen | 100.9 × 116.9 × 119 | 6,148 | 1 |
| [Modern Coffee Table 02](https://polyhaven.com/a/modern_coffee_table_02) | Amin | 119.9 × 36.9 × 120 | 13,645 | 2 |
| [Modern Wooden Cabinet](https://polyhaven.com/a/modern_wooden_cabinet) | Patrik Pangerl | 244 × 68 × 52 | 24,976 | 3 |
| [Sofa 02](https://polyhaven.com/a/sofa_02) | Kirill Sannikov | 180.7 × 70.9 × 81.8 | 2,728 | 2 |
| [Sofa 03](https://polyhaven.com/a/sofa_03) | Fran Calvente | 273.1 × 111.8 × 92.5 | 8,004 | 2 |
| [Metal Office Desk](https://polyhaven.com/a/metal_office_desk) | Ulan Cabanilla | 200 × 78.8 × 94.7 | 6,898 | 9 |
| [Classic Laptop](https://polyhaven.com/a/classic_laptop) | Arrangemonk | 65.2 × 54.3 × 48.6 | 14,450 | 4 |
| [Television 01](https://polyhaven.com/a/Television_01) | Gabriel Radić | 60 × 45.7 × 47.1 | 1,918 | 1 |
| [Camera 01](https://polyhaven.com/a/Camera_01) | Rajil Jose Macatangay | 21.4 × 7.8 × 26.3 | 26,987 | 5 |
| [Modified Thermos](https://polyhaven.com/a/modified_thermos) | Alex Weber | 14.3 × 30.6 × 10.1 | 11,576 | 1 |
| [Binder Notebook](https://polyhaven.com/a/binder_notebook) | DaDrood | 58.4 × 2.5 × 20 | 18,077 | 2 |
| [Stationery Supplies](https://polyhaven.com/a/stationery_supplies) | Mateusz Sadek | 30.2 × 16.4 × 8.4 | 4,412 | 9 |
| [Antique Ceramic Vase 01](https://polyhaven.com/a/antique_ceramic_vase_01) | James Ray Cock | 25.5 × 44 × 25.5 | 9,408 | 1 |
| [Plastic Crate 02](https://polyhaven.com/a/plastic_crate_02) | Fabi_G | 50.6 × 25.4 × 40.6 | 5,840 | 1 |
| [Double Bed](https://kenney.nl/assets/furniture-kit) | Kenney | 170 × 66.7 × 200 | 264 | 7 |
| [Open Bookcase](https://kenney.nl/assets/furniture-kit) | Kenney | 81.8 × 180 × 51.1 | 320 | 1 |
| [Floor Lamp](https://kenney.nl/assets/furniture-kit) | Kenney | 28.3 × 160 × 32.7 | 76 | 2 |
| [Computer Monitor](https://kenney.nl/assets/furniture-kit) | Kenney | 60 × 45 × 15.9 | 72 | 2 |
| [Desktop Speaker](https://kenney.nl/assets/furniture-kit) | Kenney | 8.9 × 18 × 8 | 220 | 2 |
| [Flat-screen TV](https://kenney.nl/assets/furniture-kit) | Kenney | 144 × 95.6 × 27 | 72 | 2 |
| [Books](https://kenney.nl/assets/furniture-kit) | Kenney | 34.8 × 24 × 21.8 | 62 | 4 |

The list’s “Vintage Television 01” and “Vintage Camera 01” are included under their actual Poly Haven titles: **Television 01** and **Camera 01**.

## Scale and rendering

- **Poly Haven:** retain the native glTF metre scale. Unity/glTFast handles coordinate conversion. These are author-sized visualization assets, not manufacturer-certified product dimensions. Open notebooks, camera straps and other protrusions contribute to their overall bounding dimensions.
- **Kenney:** use uniform scaling on the visual child, preserving proportions. These stylized models use explicitly chosen reference dimensions: bed depth **200 cm**, bookcase height **180 cm**, floor lamp height **160 cm**, monitor width **60 cm**, speaker height **18 cm**, television width **144 cm**, books height **24 cm**. The television is a generic reference model, not a verified 65-inch television.
- The product wrapper stays at unit scale; its box collider is fitted to the complete renderer bounds. The original source origin is preserved. The existing spawn code accounts for offset bounds when placing the product.
- Poly Haven downloads use **1K textures**, repacked with their original mesh and materials into self-contained GLB files. Kenney GLBs retain their supplied materials. The source model/thumbnail collection is approximately **27 MiB**; imported/build size and runtime GPU memory differ.
- Existing grab, selection, scale locking/reset, bounding box and room constraints apply to each saved wrapper. Interaction and room fit still use bounding boxes; the open space beneath a chair/table is not represented by a detailed collision mesh.
- Some products have several materials (nine slots on the desk and stationery). Actual standalone Quest frame rate with many simultaneous instances remains a device test.

## User-provided model additions

The locally supplied GLBs are included unchanged, with their embedded creator and CC-BY-4.0 credits retained in [Sketchfab/ATTRIBUTION.md](Sketchfab/ATTRIBUTION.md) and `catalog.json`. Both products have saved thumbnails, ProductDefinition assets, editable interaction prefabs, and authored catalog cards.

| Product | Category | W ? H ? D (cm) | Triangles | Scale basis |
| --- | --- | --- | ---: | --- |
| Bubble Seal | Objects | 36.3 ? 29.4 ? 50.0 | 18,560 | Chosen stylized reference size: 50 cm longest dimension. |
| PlayStation 5 | Electronics | 14.8 ? 40.1 ? 35.5 | 186,680 | Console shell height calibrated to 39 cm; base included in overall bounds. |

The PS5 uses the artist's proportions. Its body-height reference follows [Sony's original PS5 specifications](https://sonyinteractive.com/en/press-releases/2020/playstation-5-launches-this-november-at-399-for-ps5-digital-edition-and-499-for-ps5-with-ultra-hd-blu-ray-disc-drive/); the mesh's width, depth, and stand are not manufacturer-certified geometry. Both default sizes remain editable in their product assets.

## Requested items not added

The pasted list contained names/platform labels but no actual hyperlink targets. Public metadata was used to identify matching download pages. Sketchfab’s official download endpoint returned **HTTP 401: Authentication credentials were not provided**. These models were not downloaded through a signed-in account.

| Requested model | Download page / status |
| --- | --- |
| IKEA MARKUS office chair | [Matching page](https://sketchfab.com/3d-models/ikea-markus-office-chair-cee12c29ebda4bcdb91b84a6f126a971) by Graham Rust; download manually while signed in. |
| IKEA SIGTRYGG chair | [Matching page](https://sketchfab.com/3d-models/sigtrygg-ikea-chair-d837f9f1717044fa8641b48bb54e4a0a) by ditovirnantio; download manually while signed in. |
| Sony WH-1000XM5 headphones | [Matching page](https://sketchfab.com/3d-models/sony-wh-1000xm5-5d8aea0a780b49fa89c9c205912414e3) by Zalaneke; download manually while signed in. |
| JBL Go 3 speaker | [Matching page](https://sketchfab.com/3d-models/speaker-jbl-go-3-portable-8587d39f1c404c039eb8df77ef1b8114) by kuaho; download manually while signed in. |
| Logitech MX Master 3 scan | [Matching page](https://sketchfab.com/3d-models/logitech-mx-master-3-scan-f0295665d86e4e12afd1398905fc189b) by chopraz2431; download manually while signed in. |
| Gamer Setup Pack | [Matching page](https://sketchfab.com/3d-models/gamer-setup-pack-49aa58309ef64c3c8ba0be1a8fa1b84d) by Phuc13b; download manually while signed in. |
| Basic Computer Monitor / TV | [Matching page](https://sketchfab.com/3d-models/basic-computer-monitor-tv-lowpoly-967ebecf66ef4d69b90655b173fb444f) by fatihmcnn; download manually while signed in. |
| Desktop Computer Speakers | [Matching page](https://sketchfab.com/3d-models/computer-speakers-60ea790042904974b3361a2add8e7921) by Darren McNerney 3D; download manually while signed in. |
| Low-poly Gaming PC | [Matching page](https://sketchfab.com/3d-models/gaming-pc-low-poly-4a5f924f7ce94d41baeac720d738484f) by LagzDesign; download manually while signed in. |
| Apple iPhone 15 Pro | [14.9k-triangle model by rtql8d](https://sketchfab.com/3d-models/iphone-15-pro-21a243ccceb64a4da8c0f622dcb935d3); download manually while signed in. |
| 65-inch Flat Screen TV | [276-triangle model by mtperlman](https://sketchfab.com/3d-models/65-flat-screen-tv-f56e802ba8c348c8a8b1da270edc4351); download manually while signed in. |
| Game-ready Headphones | [5.6k-triangle model by uday](https://sketchfab.com/3d-models/headphone-9fde82f5157140f3bae64b2fd5f94429); download manually while signed in. |
| Nintendo Switch | The specified 56.8k-triangle version was not uniquely identified. Use the original model page if available. A [different public model](https://sketchfab.com/3d-models/nintendo-switch-b8e8670918944c6398174e90c129b926) exists, but is not the same mesh from the list. |
| Decorative Book Set 01 | [Poly Haven page](https://polyhaven.com/a/decorative_book_set_01). The files API offers FBX, Blender and USD, but no glTF export. The FBX package references 117 texture files/variants; it was not added as a complete product. Use a selected book/arrangement exported to GLB instead. The added Kenney Books are a separate model. |
| Next-gen Electronics Pack | [Unity Asset Store page](https://assetstore.unity.com/packages/3d/props/electronics/next-gen-electronics-pack-35718). Add to your Unity account and import through Package Manager / My Assets. Its older built-in-pipeline materials may need URP conversion. |
| Low Poly Interior Pack (31 prefabs) | No unique matching publisher/download page could be confirmed from the supplied name. Use the original Asset Store link and add it to your Unity account; do not assume a similarly named pack is the same asset. |

For Sketchfab files, retain the license shown on the downloaded model page. CC BY models need author/source/license credit and modification notes; the MARKUS model uses a separate Free Standard license. The bundled CC0 catalog does not include these account-bound assets.

## Manual import on the headset or in Play mode

1. Download the model yourself from its source page. If it is already a self-contained **GLB 2.0** with embedded PNG/JPEG textures, keep that file.
2. For a Sketchfab glTF ZIP, extract it with its `.bin` and texture folders intact. In Blender, import `scene.gltf`, then export **glTF 2.0 → GLB**. For Poly Haven’s book set, open the supplied Blender file, choose the book(s) you want, and export only those selected objects as GLB. Apply required modifiers/transforms and avoid Draco, Meshopt or KTX2 compression.
3. Copy the GLB to the Quest, for example into **Download**, or keep it on your PC for Unity Play mode.
4. Press **Import GLB** in the catalog, choose the file, inspect its preview, and enter a product name. Keep file units when sensible, use **Fit to 50 cm** for unknown units, or enter known dimensions in centimeters.
5. Entering **one dimension** scales proportionally. Entering **all three** sets each axis explicitly and may alter proportions. Fields are **width (X), height (Y), depth (Z)**; check the actual orientation and product variant before using the dimensions from your original list.
6. Press **Add**. It appears under **All** and **Imported**, can be spawned and manipulated, and is saved locally for later launches. Imports made in Editor Play mode stay in that editor library; they are not automatically bundled into the APK.

Current importer limits: 64 MiB, 500,000 referenced position vertices and 2,500 nodes. Particularly large scanned files, such as the mouse, may need decimation. Those limits do not guarantee good Quest performance.

## Editing and bundling more products in Unity

- Product settings: `Assets/SpatialProductViewer/Products/Curated/*.asset`.
- Editable product wrappers: `Assets/SpatialProductViewer/Prefabs/Products/*.prefab`. Each has a nested source model, fitted box collider, grab transformer, selectable product and spatial constraint.
- Source GLBs and thumbnails: `Assets/SpatialProductViewer/Models/Curated/PolyHaven/` and `Kenney/`.
- Authored catalog cards and filters: open `Assets/SpatialProductViewer/Prefabs/ProductCatalogWindow.prefab`. The 25 products are saved instances of `ProductCard.prefab`; the 24 empty imported-product slots remain separate.

To add your own bundled model, place its GLB/native model and thumbnail under Assets, then append an entry to `Models/Curated/catalog.json` (a plain JSON file). Copy the structure of an existing entry and use a unique ID, paths under Assets, and category **3 = Furniture**, **4 = Electronics**, or **5 = Objects**. Use `scaleAxis: -1` for native metres; otherwise use **0/1/2 = width/height/depth** with a positive `targetMeters` to calibrate uniformly. Record the actual source, author and license.

Run **Tools → Spatial Product Viewer → Rebuild Curated Catalog** to author the wrapper, product definition and card. This is an explicit Editor command; startup and normal builds never run it. It regenerates the listed products from their source files, so use it deliberately when you want to regenerate those defaults. Subsequent normal prefab/inspector edits remain editable. The separate **Validate Curated Catalog** command checks that every manifest product has a saved card, along with dimensions, materials, thumbnails and the 24 free import slots.

Alternatively, duplicate a similar product wrapper and ProductDefinition, replace its visual child, assign all model renderers and fit the root BoxCollider, then duplicate a card in the catalog and assign the new definition. Keep the empty local-import slots available for runtime imports.

## Verification

- Imported all 22 source models through the installed Unity/glTFast importer and saved ordinary product prefabs, ProductDefinitions and catalog instances.
- Validated 25 populated cards, 24 empty import slots, centimetre labels, dimensions, supported materials and thumbnails.
- Passed **509 Unity Play-mode assertions**, covering self-contained GLB validation, category counts, button targets/fonts, spawning all 25 products, measured world/collider bounds, duplicate/delete, scale reset on originals and duplicates, minimize/restore and subsequent import-card insertion.
- Captured and inspected the rendered catalog preview; compiled runtime code for both Editor and Quest branches.
- Unity emitted an existing Editor Search indexing exception during batch startup; the product checks completed successfully. No Quest APK was built or installed for this change. Headset rendering, interaction feel and performance remain your device test.

Provenance: `catalog.json` stores source links, authors, licenses, scale basis and source-GLB SHA-256 values. `measurements.json` stores native Unity bounds, triangle counts and material-slot counts.
