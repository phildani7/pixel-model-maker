import QtQuick 2.15
import QtQuick.Controls 2.15
import PixelModelMaker 1.0
import QtQuick3D 1.15
import QtQuick.Controls.Material 2.15


Item {
    property alias canvas: canvas
    property alias view: view
    property alias depth: depth
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
                icon.source: "qrc:/ui/images/ic_arrow_back_48px.svg"
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
                icon.source: "qrc:/ui/images/ic_save_48px.svg"
            }
            anchors.right: parent.right
        }
    }

    Rectangle {
        id: rectangle
        y: toolBar.height
        z: -1
        width: parent.width
        height: parent.height - toolBar.height - viewBar.height
        color: Constants.backgroundColor

        Item {
            id: drawComponents
            visible: viewMode == 0
            anchors.fill: parent

            DrawCanvas {
                id: canvas
            }

            ColorPalette {
                width: 170
                height: 300
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 20
            }
        }

        Item {
            id: depthComponents
            visible: viewMode == 1
            anchors.fill: parent

            DepthCanvas {
                id: depth
            }
        }

        Item {
            id: viewComponents
            visible: viewMode == 2
            anchors.fill: parent

            ViewModel {
                id: view
                anchors.fill: parent
            }
        }

        Item {
            id: exportComponents
            visible: viewMode == 3
            anchors.fill: parent

            ExportModel {
                anchors.fill: parent
            }
        }

        Item {
            id: miniViewCompoent
            visible: viewMode != 2
            anchors.fill: parent
            MiniViewModel {
                id: miniView
                width: 250
                height: 250
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 20
            }
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
                text: qsTr("Draw")
                width: viewBar.buttonSize
                height: viewBar.buttonSize
                flat: viewMode != 0
                font.styleName: "Regular"
                highlighted: viewMode == 0
                icon.source: "qrc:/ui/images/ic_mode_edit_48px.svg"
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
                icon.source: "qrc:/ui/images/layers_black_48dp.svg"
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
                icon.source: "qrc:/ui/images/view_in_ar_black_48dp.svg"
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
                icon.source: "qrc:/ui/images/ic_file_download_48px.svg"
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


/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
