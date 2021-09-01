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
                ctx.strokeStyle = Qt.rgba(0.3, 0.3, 0.3, 0.2)
                ctx.beginPath()
                ctx.moveTo(GlobalState.gridWidth * cellSize / 2, 0)
                ctx.lineTo(GlobalState.gridWidth * cellSize / 2,
                           GlobalState.gridHeight * cellSize)
                ctx.moveTo(0, GlobalState.gridHeight * cellSize / 2)
                ctx.lineTo(GlobalState.gridWidth * cellSize,
                           GlobalState.gridHeight * cellSize / 2)
                ctx.stroke()
                ctx.strokeStyle = Qt.rgba(0, 0, 0, 0)
            }
        }

        MouseArea {
            width: parent.width
            height: parent.height
            acceptedButtons: Qt.AllButtons
            hoverEnabled: true

            onClicked: parent.handleClick(mouse)
            onPositionChanged: parent.handleDrag(mouse)
            onWheel: parent.handleWheel(wheel)
        }

        function destroyPixel(pixel) {
            pixel.color = null
            pixel.depth = 0
            if (pixel.shape) {
                pixel.shape.destroy()
                pixel.shape = null
                pixel.shapeName = null
            }
            if (pixel.miniShape) {
                pixel.miniShape.destroy()
                pixel.miniShape = null
                pixel.shapeName = null
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
                if (mouse.modifiers !== Qt.NoModifier && pixel.depth === 0)
                    return
                if (mouse.modifiers === Qt.ShiftModifier
                        || mouse.modifiers === Qt.NoModifier)
                    pixel.color = Qt.rgba(color.r, color.g, color.b, color.a)
                if (pixel.depth === 0)
                    pixel.depth = 1
                if (mouse.modifiers === Qt.ControlModifier
                        || mouse.modifiers === Qt.NoModifier)
                    pixel.shapeName = GlobalState.selectedShape
            } else if (mouse.button === Qt.MiddleButton) {
                if (mouse.modifiers === Qt.ShiftModifier
                        || mouse.modifiers === Qt.NoModifier)
                    GlobalState.selectedColor = Qt.rgba(pixel.color.r,
                                                        pixel.color.g,
                                                        pixel.color.b,
                                                        pixel.color.a)
                if (mouse.modifiers === Qt.ControlModifier
                        || mouse.modifiers === Qt.NoModifier)
                    GlobalState.selectedShape = pixel.shapeName
            } else {
                destroyPixel(pixel)
            }
            GlobalState.setInputSequenceFromMouse(mouse, "Mouse Click")
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
                    && (pixel.color !== GlobalState.selectedColor
                        || pixel.shapeName !== GlobalState.selectedShape)) {
                if (mouse.modifiers !== Qt.NoModifier && pixel.depth === 0)
                    return

                let color = GlobalState.selectedColor
                if (mouse.modifiers === Qt.ShiftModifier
                        || mouse.modifiers === Qt.NoModifier)
                    pixel.color = Qt.rgba(color.r, color.g, color.b, color.a)
                if (pixel.depth === 0)
                    pixel.depth = 1
                if (mouse.modifiers === Qt.ControlModifier
                        || mouse.modifiers === Qt.NoModifier)
                    pixel.shapeName = GlobalState.selectedShape
                GlobalState.setInputSequenceFromMouse(mouse, "Mouse Drag")
                canvas.requestPaint()
            } else if (mouse.buttons === Qt.RightButton) {
                destroyPixel(pixel)
                GlobalState.setInputSequenceFromMouse(mouse, "Mouse Drag")
                canvas.requestPaint()
            }
        }

        function handleWheel(event) {
            const cellSize = width / GlobalState.gridWidth
            const col = parseInt(event.x / cellSize)
            const row = parseInt(event.y / cellSize)
            if (col >= GlobalState.gridWidth || col < 0
                    || row >= GlobalState.gridHeight || row < 0)
                return
            let pixel = GlobalState.pixelMap[row][col]
            if (pixel.shapeName === null)
                return
            if (event.angleDelta.y > 0)
                pixel.shapeName = ShapeCollection.shapes[pixel.shapeName].next
            else
                pixel.shapeName = ShapeCollection.shapes[pixel.shapeName].prev
            GlobalState.setInputSequenceFromMouse(event, "Mouse Wheel")
            canvas.requestPaint()
        }
    }

    function repaint() {
        canvas.requestPaint()
    }
}
