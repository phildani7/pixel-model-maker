import Qt.labs.platform 1.1

import QtQuick 2.15
import QtQuick.Controls 2.15
import PixelModelMaker 1.0
import QtQuick3D 1.15
import QtQuick.Controls.Material 2.15

import com.github.zaghaghi.pixelmodelmaker 1.0

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

                onClicked: {
                    if (GlobalState.fileName === "") {
                        saveFileDialog.open()
                    } else {
                        if (io.source !== GlobalState.fileName) {
                            io.source = GlobalState.fileName
                        } else {
                            io.text = GlobalState.getSaveString()
                        }
                    }
                }
            }
            ToolButton {
                id: exportImage

                text: qsTr("")
                display: AbstractButton.IconOnly
                icon.source: "qrc:/ui/images/camera_black_48dp.svg"
                visible: viewMode == 2
                onClicked: {
                    exportImageDialog.file = ""
                    exportImageDialog.open()
                }
            }
            ToolButton {
                id: export3d

                text: qsTr("")
                display: AbstractButton.IconOnly
                icon.source: "qrc:/ui/images/ic_file_download_48px.svg"
                visible: viewMode == 2
                onClicked: {
                    exportModelDialog.file = ""
                    exportModelDialog.open()
                }
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
                id: colorPalette
                width: 170
                height: 300
                anchors.top: parent.top
                anchors.topMargin: 20
                anchors.right: parent.right
                anchors.rightMargin: 20
            }

            ShapePalette {
                width: 170
                height: 260
                anchors.top: colorPalette.bottom
                anchors.topMargin: 20
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
            id: miniViewComponent
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
                onClicked: {
                    viewMode = 0
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
                onClicked: {
                    viewMode = 1
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
                onClicked: {
                    viewMode = 2
                }
            }
        }
    }

    FileIO {
        id: io
        source: saveFileDialog.file

        onSourceChanged: {
            if (`${io.source}` === `.${saveFileDialog.defaultSuffix}`)
                return
            GlobalState.fileName = io.source
            io.text = GlobalState.getSaveString()
        }

        onTextChanged: {
            io.write()
        }
    }

    FileDialog {
        id: saveFileDialog
        folder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
        fileMode: FileDialog.SaveFile
        defaultSuffix: "json"
        nameFilters: ["JSON Files (*.json)"]
    }

    FileDialog {
        id: exportImageDialog
        folder: StandardPaths.writableLocation(StandardPaths.PicturesLocation)
        fileMode: FileDialog.SaveFile
        defaultSuffix: "png"
        nameFilters: ["PNG Image Files (*.png)"]

        onFileChanged: {
            let exportFileName = exportImageDialog.file.toString()

            if (exportFileName === "")
                return
            viewComponents.grabToImage(function (result) {
                try {
                    if (exportFileName.startsWith("file://")) {
                        exportFileName = exportFileName.substr(7)
                    }

                    if (!result.saveToFile(exportFileName)) {
                        exportImageErrorDialog.open()
                    }
                } catch (exception) {
                    exportImageErrorDialog.open()
                }
            })
        }
    }

    Dialog {
        id: exportImageErrorDialog
        modal: true
        standardButtons: Dialog.Ok
        title: qsTr("Error Exporting Image")
        Label {
            text: "Can't save image right now!"
        }
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
    }

    GltfExport {
        id: exporter

        onExported: {
            exportModelInfoDialog.open()
        }

        onError: (fileName, errorMsg) => {
                     exportModelErrorDialog.open()
                 }
    }

    FileDialog {
        id: exportModelDialog
        folder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
        fileMode: FileDialog.SaveFile
        defaultSuffix: "gltf"
        nameFilters: ["glTF 2.0 (*.gltf)"]

        onFileChanged: {
            let exportFileName = exportModelDialog.file.toString()

            if (exportFileName === "")
                return
            exporter.write(exportFileName, GlobalState.getSaveObject())
        }
    }

    Dialog {
        id: exportModelErrorDialog
        modal: true
        standardButtons: Dialog.Ok
        title: qsTr("Error Exporting 3D Model")
        Label {
            text: "Can't export 3d model right now!"
        }
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
    }

    Dialog {
        id: exportModelInfoDialog
        modal: true
        standardButtons: Dialog.Ok
        title: qsTr("Model Exported")
        Label {
            text: "Model exported successfully"
        }
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/

