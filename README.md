# Pixel Model Maker
PixelModelMaker is an opensource clone of [KenShape](https://tools.kenney.nl/kenshape/) from [Kenny](https://kenney.nl/).

# Features

* ✅ Draw Pixels
* ✅ Draw Depth
* ✅ Interactive 3d Model Viewer
* ✅ 3d Model Miniview
* ✅ Open & Save
* ✅ Export Image
* ✅ Export 3D
* ✅ More Shapes

## Todo
* Scale Slider
* Depth Palette
* Shape & Color Picker
* Rotate Shapes
* Custom Color Palette
* Model Optimization
* Automatic Depth

# Dependencies
* Qt6

# Deployment Packaging
## MacOS
```bash
macdeployqt PixelModelMaker.app -qmldir=$PROJECT_DIR/ui/ -qmlimport=$PROJECT_DIR/ui/imports/
```
# Screenshots

Screen | Image
-------|:----:
Welcome| ![welcom-screen](screenshots/welcome.png)
Draw   | ![draw-mode](screenshots/draw-mode.png)
Depth  | ![depth-mode](screenshots/depth-mode.png)
3D View| ![view-mode](screenshots/3d-view-mode.png)
Exported to Blender| ![view-mode](screenshots/export-blender.png)