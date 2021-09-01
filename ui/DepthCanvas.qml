import QtQuick 2.15
import PixelModelMaker 1.0
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

Pane {
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
            id: depthCanvas
            anchors.fill: parent
            onPaint: {
                var ctx = getContext("2d")
                ctx.font = "bold normal 10px Roboto"
                const black = Constants.checkerBoardBlack
                const white = Constants.checkerBoardWhite
                const cellSize = width / GlobalState.gridWidth
                for (var i = 0; i < GlobalState.gridHeight; ++i) {
                    for (var j = 0; j < GlobalState.gridWidth; ++j) {
                        ctx.fillStyle = (i + j) % 2 ? black : white
                        ctx.fillRect(i * cellSize, j * cellSize,
                                     cellSize, cellSize)
                        let pixel = GlobalState.pixelMap[j][i]
                        if (pixel.color) {
                            const fillColor = pixel.color
                            ctx.fillStyle = Qt.rgba(fillColor.r, fillColor.g,
                                                    fillColor.b, 0.6)
                            ShapeCollection.shapes[GlobalState.pixelMap[j][i].shapeName].draw(
                                        ctx, i * cellSize, j * cellSize,
                                        cellSize, cellSize)
                        }
                        if (pixel.depth) {
                            ctx.fillStyle = Qt.rgba(0, 0, 0, 1)
                            ctx.textAlign = "center"
                            ctx.textBaseline = "middle"
                            ctx.fillText(pixel.depth,
                                         i * cellSize + cellSize / 2,
                                         j * cellSize + cellSize / 2)
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

            onClicked: parent.handleClick(mouse)
            onPositionChanged: parent.handleDrag(mouse)
            onWheel: parent.handleWheel(wheel)
        }

        function handleClick(mouse) {
            const cellSize = width / GlobalState.gridWidth
            const col = parseInt(mouse.x / cellSize)
            const row = parseInt(mouse.y / cellSize)
            if (col >= GlobalState.gridWidth || col < 0
                    || row >= GlobalState.gridHeight || row < 0)
                return
            let pixel = GlobalState.pixelMap[row][col]
            if (pixel.color === null || pixel.depth === 0)
                return
            if (mouse.button === Qt.LeftButton) {
                pixel.depth = GlobalState.selectedDepth
                GlobalState.setInputSequenceFromMouse(mouse, "Mouse Click")
                depthCanvas.requestPaint()
            }
        }

        function handleDrag(mouse) {
            const cellSize = width / GlobalState.gridWidth
            const col = parseInt(mouse.x / cellSize)
            const row = parseInt(mouse.y / cellSize)
            if (col >= GlobalState.gridWidth || col < 0
                    || row >= GlobalState.gridHeight || row < 0)
                return
            let pixel = GlobalState.pixelMap[row][col]
            if (pixel.color === null || pixel.depth === 0)
                return

            if (mouse.buttons === Qt.LeftButton
                    && pixel.depth !== GlobalState.selectedDepth) {
                pixel.depth = GlobalState.selectedDepth
                GlobalState.setInputSequenceFromMouse(mouse, "Mouse Drag")
                depthCanvas.requestPaint()
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
            if (pixel.color === null || pixel.depth === 0)
                return
            if (event.angleDelta.y > 0)
                pixel.depth = Math.max(1, pixel.depth - 1)
            else
                pixel.depth = Math.min(10, pixel.depth + 1)
            GlobalState.setInputSequenceFromMouse(event, "Mouse Wheel")
            depthCanvas.requestPaint()
        }
    }

    function repaint() {
        depthCanvas.requestPaint()
    }
}
