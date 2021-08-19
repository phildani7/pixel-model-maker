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
                        if (GlobalState.pixelMap && GlobalState.pixelMap[j][i] && GlobalState.pixelMap[j][i].color) {
                            ctx.fillStyle = GlobalState.pixelMap[j][i].color
                        }
                        else {
                            ctx.fillStyle = (i+j)%2 ? black : white
                        }
                        ctx.fillRect(i * cellSize, j * cellSize, cellSize, cellSize)
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
            if (mouse.button === Qt.LeftButton) {
                GlobalState.pixelMap[row][col].color = GlobalState.selectedColor.toString()
            }
            else {
                GlobalState.pixelMap[row][col].color = null
            }
            canvas.requestPaint()
        }

        function handleDrag(mouse) {
            const cellSize = width / GlobalState.gridWidth
            const col = parseInt(mouse.x / cellSize)
            const row = parseInt(mouse.y / cellSize)
            if (mouse.buttons === Qt.LeftButton && GlobalState.pixelMap[row][col].color !== GlobalState.selectedColor) {
                GlobalState.pixelMap[row][col].color = GlobalState.selectedColor.toString()
                canvas.requestPaint()
            }
            else if (mouse.buttons === Qt.RightButton) {
                GlobalState.pixelMap[row][col].color = null
                canvas.requestPaint()
            }

        }
    }

    function repaint() {
        canvas.requestPaint()
    }
}
