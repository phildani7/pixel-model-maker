import QtQuick 2.15
import QtQuick.Controls 2.15
import PixelModelMaker 1.0
import QtQuick.Controls.Material 2.12

Rectangle {
    property int gridSize: 4
    property alias canvas: canvas
    property alias backButton: backButton

    width: 1000
    height: 600

    ToolBar {
        id: toolBar
        x: 106
        width: parent.width
        anchors.top: parent.top
        leftPadding: 20
        rightPadding: 20
        font.styleName: "Medium"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 0
        Material.primary: Material.LightBlue

        ToolButton {
            id: backButton
            y: 0
            text: qsTr("Back")
            icon.source: "images/ic_arrow_back_48px.svg"
        }

        Text {
            color: Constants.titleColor
            font.family: "Roboto"
            font.styleName: "Medium"
            font.pixelSize: 18
            text: qsTr("Draw Mode")
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    Rectangle {
        x: 0
        y: toolBar.height
        width: parent.width
        height: parent.height - toolBar.height
        color: Constants.backgroundColor
        GridCanvas {
            id: canvas
            x: 0
            y: 0
            gridHeight: gridSize
            gridWidth: gridSize
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
