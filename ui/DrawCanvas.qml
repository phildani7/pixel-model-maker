import QtQuick 2.15
import PixelModelMaker 1.0
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

Pane {
    id: drawPane
    padding: 10
    Material.background: Constants.toolbarColor
    width: Constants.canvasSize + padding * 2
    height: Constants.canvasSize + padding * 2
    anchors.verticalCenter: parent.verticalCenter
    anchors.horizontalCenter: parent.horizontalCenter
    background: Rectangle {
        radius: 5
        color: Constants.toolbarColor
    }

    Item {
        anchors.fill: parent
        Canvas {
            id: canvas
            anchors.fill: parent
            onPaint: {
                var ctx = getContext("2d")
                const black = Constants.checkerBoardBlack
                const white = Constants.checkerBoardWhite
                const cellSize = width / GlobalState.gridWidth
                for (var i = 0; i < GlobalState.gridHeight; ++i) {
                    for (var j = 0; j < GlobalState.gridWidth; ++j) {
                        ctx.fillStyle = (i + j) % 2 ? black : white
                        ctx.fillRect(i * cellSize, j * cellSize,
                                     cellSize, cellSize)
                        if (GlobalState.pixelMap[j][i].color) {
                            ctx.fillStyle = GlobalState.pixelMap[j][i].color
                            ShapeCollection.shapes[GlobalState.pixelMap[j][i].shapeName].draw(
                                        ctx, i * cellSize, j * cellSize,
                                        cellSize, cellSize)
                        }
                    }
                }
            }
        }

        MouseArea {
            width: parent.width
            height: parent.height
            acceptedButtons: Qt.AllButtons
            hoverEnabled: true

            onClicked: parent.handleClick(mouse)
            onPositionChanged: parent.handleDrag(mouse)
        }

        function destroyPixel(pixel) {
            pixel.color = null
            pixel.depth = 0
            if (pixel.shape) {
                pixel.shape.destroy()
                pixel.shape = null
            }
            if (pixel.miniShape) {
                pixel.miniShape.destroy()
                pixel.miniShape = null
            }
        }

        function handleClick(mouse) {
            const cellSize = width / GlobalState.gridWidth
            const col = parseInt(mouse.x / cellSize)
            const row = parseInt(mouse.y / cellSize)
            if (col >= GlobalState.gridWidth || col < 0
                    || row >= GlobalState.gridHeight || row < 0)
                return
            let pixel = GlobalState.pixelMap[row][col]
            if (mouse.button === Qt.LeftButton) {
                let color = GlobalState.selectedColor
                pixel.color = Qt.rgba(color.r, color.g, color.b, color.a)
                if (pixel.depth === 0)
                    pixel.depth = 1
                pixel.shapeName = GlobalState.selectedShape
            } else {
                destroyPixel(pixel)
            }
            canvas.requestPaint()
        }

        function handleDrag(mouse) {
            const cellSize = width / GlobalState.gridWidth
            const col = parseInt(mouse.x / cellSize)
            const row = parseInt(mouse.y / cellSize)
            if (col >= GlobalState.gridWidth || col < 0
                    || row >= GlobalState.gridHeight || row < 0)
                return
            let pixel = GlobalState.pixelMap[row][col]
            if (mouse.buttons === Qt.LeftButton
                    && pixel.color !== GlobalState.selectedColor) {
                let color = GlobalState.selectedColor
                pixel.color = Qt.rgba(color.r, color.g, color.b, color.a)
                if (pixel.depth === 0)
                    pixel.depth = 1
                pixel.shapeName = GlobalState.selectedShape
                canvas.requestPaint()
            } else if (mouse.buttons === Qt.RightButton) {
                destroyPixel(pixel)
                canvas.requestPaint()
            }
        }
    }

    function repaint() {
        canvas.requestPaint()
    }
}
