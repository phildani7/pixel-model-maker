import QtQuick 2.15
import PixelModelMaker 1.0
import QtGraphicalEffects 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

Pane {
    padding: 10
    Material.background: Constants.toolbarColor
    width: Constants.canvasSize + padding * 2
    height: Constants.canvasSize + padding * 2
    anchors.verticalCenter: parent.verticalCenter
    anchors.horizontalCenter: parent.horizontalCenter
    layer.enabled: true
    layer.effect: OpacityMask {
        maskSource: Rectangle {
            width: Constants.canvasSize
            height: Constants.canvasSize
            radius: 7
        }
    }

    Item {
        anchors.fill: parent
        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Rectangle {
                width: Constants.canvasSize
                height: Constants.canvasSize
                radius: 5
            }
        }
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
                        let fillColor = (i + j) % 2 ? black : white
                        if (GlobalState.pixelMap && GlobalState.pixelMap[j][i]
                                && GlobalState.pixelMap[j][i].color) {
                            fillColor = GlobalState.pixelMap[j][i].color
                        }
                        ctx.fillStyle = fillColor
                        ctx.fillRect(i * cellSize, j * cellSize,
                                     cellSize, cellSize)
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
            } else {
                pixel.color = null
                pixel.depth = 0
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
                canvas.requestPaint()
            } else if (mouse.buttons === Qt.RightButton) {
                pixel.color = null
                pixel.depth = 0
                canvas.requestPaint()
            }
        }
    }

    function repaint() {
        canvas.requestPaint()
    }
}
