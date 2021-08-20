import QtQuick 2.15
import QtQuick.Controls 2.12
import PixelModelMaker 1.0
import QtQuick.Controls.Material 2.12

Pane {
    id: palettePane
    padding: 10
    Material.background: Constants.toolbarColor
    Material.elevation: 10
    Item {
        id: header
        height: 30
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        Text {
            text: "Color"
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            font.pointSize: 14
            font.styleName: "Medium"
            font.family: "Roboto"
            anchors.leftMargin: 0
            color: Constants.titleColor
        }
        Rectangle {
            width: 20
            height: 20
            color: GlobalState.selectedColor
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            radius: 3
            border.color: "white"
            border.width: 1
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
            model: Constants.defaultColorPalette
            focus: true
            clip: true
            delegate: Item {
                width: 30
                height: 30
                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter

                    width: 20
                    height: 20
                    color: modelData
                    radius: 3
                    border.color: "#888888"
                    border.width: 1
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: event => {
                                   colorGrid.currentIndex = index
                                   GlobalState.selectedColor
                                   = colorGrid.currentItem.children[0].color
                               }
                }
            }
        }
    }
}
