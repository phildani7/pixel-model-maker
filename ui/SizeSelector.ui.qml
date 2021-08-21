import QtQuick 2.15
import QtQuick.Controls 2.15
import PixelModelMaker 1.0
import QtQuick.Controls.Material 2.15

Rectangle {
    id: rectangle
    width: 1000
    height: 600

    color: Constants.backgroundColor

    property alias buttonSize16: button_16
    property alias buttonSize24: button_24
    property alias buttonSize32: button_32

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
            padding: 10
            font.styleName: "Thin"
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
                id: button_16
                width: 100
                height: 100
                text: qsTr("16 X 16")
                font.styleName: "Regular"
                highlighted: true
                icon.source: "qrc:/ui/images/ic_grid_on_48px.svg"
                display: AbstractButton.TextUnderIcon
                Material.accent: Material.Red
            }

            Button {
                id: button_24
                width: 100
                height: 100
                text: qsTr("24 X 24")
                font.styleName: "Regular"
                highlighted: true
                icon.source: "qrc:/ui/images/ic_grid_on_48px.svg"
                display: AbstractButton.TextUnderIcon
                Material.accent: Material.Pink
            }

            Button {
                id: button_32
                width: 100
                height: 100
                text: qsTr("32  X 32")
                font.styleName: "Regular"
                highlighted: true
                icon.source: "qrc:/ui/images/ic_grid_on_48px.svg"
                display: AbstractButton.TextUnderIcon
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

