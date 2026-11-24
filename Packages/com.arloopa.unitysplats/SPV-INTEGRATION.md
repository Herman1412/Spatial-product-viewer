# Spatial Product Viewer integration

Upstream: https://github.com/arloopa/UnitySplats
Version: 2.1.0; pinned source revision: 0abd9370f1038a04e8d17e2883a1df70b419295d.
License: MIT. Upstream license and Third Party Notices.md are retained.

This is an embedded Unity Package Manager package so builds do not depend on a moving Git branch.
Project compatibility patches:

- `Runtime/GsplatSorter.cs`: Unity 6000.4+ uses `GetEntityId().GetHashCode()` in the optional
  Web sorting diagnostics instead of the removed `GetInstanceID()` API. Older versions retain
  the original call.
- `Runtime/SRP/GsplatURPFeature.cs`: the sorting pass requests an intermediate camera texture.
  This preserves opaque mesh colour across the opaque/transparent pass split on XR/MSAA targets,
  independently of whether the selection outline is active. The pass is still enqueued only
  for cameras that contain splats; the renderer's global Intermediate Texture mode stays Auto.

The decoder, GPU buffers, sort algorithms and editor importer are upstream code.

The app-specific shader, alpha silhouette pass, bounds adapter, file limits, SPLAT decoder and
catalog/persistence integration are under Assets/SpatialProductViewer. No upstream renderer code
is needed for selection masks: GaussianProduct uses the public asset/resource API.

Unity.WebP 0.3.22 is embedded separately as the package's required dependency, with its original
license and Android ARM64 plugin settings. PLY/SPZ/SPLAT imports do not use the SOG/WebP path.
