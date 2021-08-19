import QtQuick 2.15
import QtQuick.Controls 2.15
import PixelModelMaker 1.0
import QtQuick.Controls.Material 2.12
import QtGraphicalEffects 1.12

Item {
    property int gridSize: 4
    property alias canvas: canvas
    property alias backButton: backButton
    property int viewMode: 0
    property variant viewNames: ["Edit Mode", "Depth Mode", "View Mode", "Export"]

    width: 1000
    height: 600

    ToolBar {
        id: toolBar
        width: parent.width
        anchors.top: parent.top
        leftPadding: 20
        rightPadding: 20
        font.styleName: "Medium"
        anchors.horizontalCenter: parent.horizontalCenter
        Material.primary: Constants.toolbarColor

        Row {
            ToolButton {
                id: backButton
                text: qsTr("Discard")
                icon.source: "images/ic_arrow_back_48px.svg"
            }
        }

        Text {
            color: Constants.titleColor
            font.family: "Roboto"
            font.styleName: "Medium"
            font.pixelSize: 18
            text: qsTr(viewNames[viewMode])
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Row {
            ToolButton {
                id: saveButton
                text: qsTr("")
                display: AbstractButton.IconOnly
                icon.source: "images/ic_save_48px.svg"
            }
            anchors.right: parent.right
        }
    }

    Rectangle {
        x: 0
        y: toolBar.height
        z: -1
        width: parent.width
        height: parent.height - toolBar.height - viewBar.height
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

    ToolBar {
        id: viewBar
        height: 2 * toolBar.height
        width: parent.width
        position: ToolBar.Footer
        anchors.bottom: parent.bottom
        leftPadding: 20
        rightPadding: 20
        Material.primary: Constants.toolbarColor
        property int buttonSize: 80
        Row {
            spacing: 10
            padding: 10
            anchors.horizontalCenter: parent.horizontalCenter

            Button {
                id: drawButton
                width: viewBar.buttonSize
                height: viewBar.buttonSize
                text: qsTr("Draw")
                flat: viewMode != 0
                font.styleName: "Regular"
                highlighted: viewMode == 0
                icon.source: "images/ic_mode_edit_48px.svg"
                display: AbstractButton.TextUnderIcon
                Material.accent: Material.Cyan

                Connections {
                    target: drawButton
                    onClicked: viewMode = 0
                }
            }

            Button {
                id: depthButton
                width: viewBar.buttonSize
                height: viewBar.buttonSize
                text: qsTr("Depth")
                flat: viewMode != 1
                font.styleName: "Regular"
                highlighted: viewMode == 1
                icon.source: "images/layers_black_48dp.svg"
                display: AbstractButton.TextUnderIcon
                Material.accent: Material.Cyan

                Connections {
                    target: depthButton
                    onClicked: viewMode = 1
                }
            }

            Button {
                id: viewButton
                width: viewBar.buttonSize
                height: viewBar.buttonSize
                text: qsTr("View")
                flat: viewMode != 2
                font.styleName: "Regular"
                highlighted: viewMode == 2
                icon.source: "images/view_in_ar_black_48dp.svg"
                display: AbstractButton.TextUnderIcon
                Material.accent: Material.Cyan

                Connections {
                    target: viewButton
                    onClicked: viewMode = 2
                }
            }

            Button {
                id: exportButton
                width: viewBar.buttonSize
                height: viewBar.buttonSize
                text: qsTr("Export")
                flat: viewMode != 3
                font.styleName: "Regular"
                highlighted: viewMode == 3
                icon.source: "images/ic_file_download_48px.svg"
                display: AbstractButton.TextUnderIcon
                Material.accent: Material.Cyan
                Connections {
                    target: exportButton
                    onClicked: viewMode = 3
                }
            }
        }
    }
}
