import QtQuick 2.15
import QtQuick.Controls 2.15
import PixelModelMaker 1.0
import QtQuick.Controls.Material 2.15
import QtQuick.Controls.Material.impl 2.15

Pane {
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
    Item {
        id: header
        height: 30
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        Text {
            text: "Depth"
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            font.pointSize: 14
            font.styleName: "Medium"
            font.family: "Roboto"
            anchors.leftMargin: 0
            color: Constants.titleColor
        }
        Canvas {
            id: selectedCanvas
            width: 20
            height: 20
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            onPaint: {
                let ctx = getContext("2d")
                ctx.fillStyle = Qt.rgba(1, 1, 1, 1)
                ctx.fillRect(0, 0, width, height)

                ctx.textAlign = "center"
                ctx.textBaseline = "middle"
                ctx.fillStyle = Qt.rgba(0, 0, 0, 1)
                ctx.fillText(GlobalState.selectedDepth, 10, 10)
            }
        }
    }

    Row {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        y: header.height
        height: parent.height - header.height
        GridView {
            id: colorGrid
            height: parent.height
            width: parent.width

            cellWidth: 30
            cellHeight: 30
            model: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
            focus: true
            clip: true
            delegate: Item {
                width: 30
                height: 30
                Canvas {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter

                    width: 20
                    height: 20
                    onPaint: {
                        var ctx = getContext("2d")
                        ctx.fillStyle = Qt.rgba(1, 1, 1, 1)
                        ctx.fillRect(0, 0, width, height)

                        ctx.textAlign = "center"
                        ctx.textBaseline = "middle"
                        ctx.fillStyle = Qt.rgba(0, 0, 0, 1)
                        ctx.fillText(modelData, 10, 10)
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: event => {
                                   GlobalState.selectedDepth = modelData
                                   selectedCanvas.requestPaint()
                               }
                }
            }
        }
    }
}
