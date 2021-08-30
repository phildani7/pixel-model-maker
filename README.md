# Pixel Model Maker
PixelModelMaker allows you to use simple forms to draw on a 2d canvas. You can then raise each pixel's depth and see the outcome in 3d. The image and 3d model can be exported to continue using other softwares.

# Downloads
Download for [Windows](https://github.com/zaghaghi/pixel-model-maker/releases) and [MacOS](https://github.com/zaghaghi/pixel-model-maker/releases)

# Features

* ✅ Draw Pixels
* ✅ Draw Depth
* ✅ Interactive 3d Model Viewer
* ✅ 3d Model Miniview
* ✅ Open & Save
* ✅ Export Image
* ✅ Export 3D
* ✅ More Shapes
* ✅ Depth Scale Slider
* ✅ Depth Palette
* ✅ Shape & Color Picker
* ✅ Rotate Shapes
* ✅ Custom Color Palette
* ✅ Open Image

## Todo
* Undo and Redo
* Model Optimization
* Automatic Depth

# Dependencies
* Qt6

# Deployment Packaging
## MacOS
```bash
macdeployqt PixelModelMaker.app -qmldir=$PROJECT_DIR/ui/ -qmlimport=$PROJECT_DIR/ui/imports/ -dmg
```

## Windows
```bash
windeployqt --release --qmldir %PROJECT_DIR%\ui  --qmlimport %PROJECT_DIR%\ui\imports PixelModelMaker.exe
```

# Help
## Draw Mode Canvas
Action      | Description
------------|------------
Click       | Paste Shape & Color
Click + Shift | Paste Color Only
Click + Ctrl  | Paste Shape Only
RightClick  | Delete Shape & Color
MiddleClick | Pick Shape & Color
MiddleClick + Shift | Pick Color Only
MiddleClick + Ctrl | Pick Shape Only
Mouse Wheel | Rotate Shape

# Screenshots

Screen | Image
-------|:----:
Welcome| ![welcom-screen](screenshots/welcome.png)
Draw   | ![draw-mode](screenshots/draw-mode.png)
Depth  | ![depth-mode](screenshots/depth-mode.png)
3D View| ![view-mode](screenshots/3d-view-mode.png)
Exported to Blender| ![view-mode](screenshots/export-blender.png)