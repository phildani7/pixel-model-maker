import QtQuick 2.15
import QtQuick.Controls 2.15
import PixelModelMaker 1.0
import QtQuick.Controls.Material 2.15
import QtQuick.Controls.Material.impl 2.15

Pane {
    property int helpMode: 0

    readonly property string drawHelp: "
## Color Palette
The color palette is on the top right of the draw canvas and you can change the current color of the brush by clicking on the color you want.
You could change the colors in the color palette, by the palette icon on toolbar and open a PNG file as color palette.

## Shape Palette
The shape palette is below the color palette and you can change the current shape of the brush by clicking on the shape you want.
After drawing on the canvas you can use mouse wheel to rotate the shape to the right angle you want.

## Draw Pixels
You could draw current shape and color on the canvas using the mouse.
You could also use Ctrl/Command to only change the shape and use Shift to only change the color of an existing pixel on the canvas.

## Delete Pixels
Using the mouse right click you can delete the pixels you don't want any more.

## Picking Shape and Color
You can use the mouse middle click to pick the shape and the color of an existing pixel from canvas.
You could use Ctrl/Command and Shift to pick the shape or the color of existing pixel respectively.
"
    readonly property string depthHelp: "
## Depth Palette
The depth palette is on the top right of the depth canvas and you can change the current depth of the brush by clicking on the depth you want.
You could also use the mouse wheel to change the depth of a pixel.
"
    readonly property string viewHelp: "
## 3D View
Using the mouse drag you could rotate the 3d model. Depth slider is for changing the depth scale of the mdoel.
"

    readonly property string nftHelp: ""

    readonly property var helpList: [drawHelp, depthHelp, viewHelp, nftHelp]
    id: palettePane
    padding: 10
    background: Rectangle {
        radius: 5
        color: Constants.toolbarColor
        layer.enabled: true
        layer.effect: ElevationEffect {
            elevation: 10
        }
    }
    clip: true
    Flickable {
        anchors.fill: parent
        contentHeight: helpContent.height
        contentWidth: parent.width
        Text {
            id: helpContent
            width: parent.width
            text: helpList[helpMode]
            textFormat: Text.MarkdownText
            color: "white"
            wrapMode: Text.WrapAnywhere
        }
    }
}
