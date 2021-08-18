import QtQuick 2.15
import QtQuick.Controls 2.15
import PixelModelMaker 1.0
import QtQuick.Controls.Material 2.12

Rectangle {
    id: rectangle
    width: 1000
    height: 600

    color: Constants.backgroundColor

    Item {
        id: row1
        x: 0
        width: parent.width
        height: parent.height / 2
        anchors.top: parent.top
        anchors.topMargin: 0
        Text {
            id: text1
            color: Constants.titleColor
            text: qsTr("Select Model Size")
            anchors.bottom: parent.bottom
            font.pixelSize: 60
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.styleName: "Thin"
            font.italic: false
            font.bold: false
            anchors.bottomMargin: 0
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: "Roboto"
            font.weight: Font.Medium
        }
    }
    Item {
        id: row2
        x: 0
        y: parent.height / 2
        width: parent.width
        height: parent.height / 2
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0

        Row {
            spacing: 10
            padding: 10
            anchors.horizontalCenter: parent.horizontalCenter

            Button {
                id: button1
                //                icon.source:
                width: 100
                height: 100
                text: qsTr("16 X 16")
                display: AbstractButton.TextBesideIcon
                font.styleName: "Regular"
                highlighted: true
                Material.accent: Material.Red
            }

            Button {
                id: button2
                width: 100
                height: 100
                text: qsTr("32 X 32")
                font.styleName: "Regular"
                highlighted: true
                Material.accent: Material.Pink
            }

            Button {
                id: button3
                width: 100
                height: 100
                text: qsTr("64  X 64")
                font.styleName: "Regular"
                highlighted: true
                Material.accent: Material.Purple
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.9}
}
##^##*/

