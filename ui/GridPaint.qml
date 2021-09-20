import QtQuick 2.15
import QtQuick.Controls 2.15
import PixelModelMaker 1.0
import QtQuick3D 1.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls.Material.impl 2.15
import Qt.labs.platform 1.1 as QtLabs

import com.github.zaghaghi.pixelmodelmaker 1.0

Item {
    property alias canvas: canvas
    property alias view: view
    property alias depth: depth
    property alias backButton: backButton
    property int viewMode: 0
    property variant viewNames: ["Edit Mode", "Depth Mode", "View Mode", "NFT"]
    property bool helpPane: false

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
            anchors.right: parent.right
            ToolButton {
                id: exportImage

                text: qsTr("")
                display: AbstractButton.IconOnly
                icon.source: "qrc:/ui/images/camera_black_48dp.svg"
                hoverEnabled: true

                ToolTip {
                    parent: exportImage.handle
                    visible: exportImage.hovered
                    text: qsTr("Export Current View")
                }

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
                hoverEnabled: true
                ToolTip {
                    parent: export3d.handle
                    visible: export3d.hovered
                    text: qsTr("Export 3D Model (glTF 2.0)")
                }

                visible: viewMode == 2
                onClicked: {
                    exportModelDialog.file = ""
                    exportModelDialog.open()
                }
            }

            ToolButton {
                id: paletteButton

                text: qsTr("")
                display: AbstractButton.IconOnly
                icon.source: "qrc:/ui/images/palette_black_48dp.svg"
                hoverEnabled: true
                ToolTip {
                    parent: paletteButton.handle
                    visible: paletteButton.hovered
                    text: qsTr("Open Image For Palette")
                }

                visible: viewMode == 0
                onClicked: {
                    loadPaletteDialog.file = ""
                    loadPaletteDialog.open()
                }
            }

            ToolButton {
                id: helpButton
                text: qsTr("")
                display: AbstractButton.IconOnly
                icon.source: "qrc:/ui/images/help_center_black_48dp.svg"
                hoverEnabled: true
                highlighted: helpPane
                Material.accent: Material.Cyan
                ToolTip {
                    parent: helpButton.handle
                    visible: helpButton.hovered
                    text: qsTr("Toggle Help Pane")
                }

                onClicked: helpPane = !helpPane
            }

            ToolButton {
                id: saveButton
                text: qsTr("")
                display: AbstractButton.IconOnly
                icon.source: "qrc:/ui/images/ic_save_48px.svg"
                hoverEnabled: true
                ToolTip {
                    parent: saveButton.handle
                    visible: saveButton.hovered
                    text: qsTr("Save")
                }

                onClicked: {
                    if (GlobalState.fileName === "") {
                        saveFileDialog.open()
                    } else {
                        if (io.source.toString() !== GlobalState.fileName) {
                            io.source = GlobalState.fileName
                        } else {
                            io.text = GlobalState.getSaveString()
                        }
                    }
                }
            }
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

            DepthPalette {
                width: 170
                height: 120
                anchors.top: parent.top
                anchors.topMargin: 20
                anchors.right: parent.right
                anchors.rightMargin: 20
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

            DepthPane {
                width: 200
                height: 100
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 20
            }
        }

        Item {
            id: nftComponents
            visible: viewMode == 3
            anchors.fill: parent

            NFTView {
                id: nftView
                property string cacheName: "temp"
                uploadNft.onClicked: {
                    let pathSegments = GlobalState.fileName.toString(
                            ).split("/")
                    if (pathSegments.length
                            && pathSegments[pathSegments.length - 1].length)
                        cacheName = pathSegments[pathSegments.length - 1]
                    nftView.nftStateText.text = "Started"
                    nftView.nftStateBar.value = 1
                    view.grabToImage(function (result) {
                        let attributes = nftView.nftAttributesEdit.text.split(
                                ",").map(item => item.trim()).filter(
                                item => item.length && item.includes(
                                    "=")).map(item => {
                                                  return {
                                                      "trait_type": item.split(
                                                                        "=")[0].trim(
                                                          ),
                                                      "value": item.split(
                                                                   "=")[1].trim(
                                                          )
                                                  }
                                              })
                        let options = {
                            "assets": cacheName + "-assets",
                            "network": SolanaApi.network,
                            "cachename": cacheName,
                            "name": nftView.nftNameEdit.text,
                            "symbol": nftView.nftSymbolEdit.text,
                            "description": nftView.nftDescriptionEdit.text,
                            "attributes": [{
                                    "trait_type": "creator",
                                    "value": "Pixel Model Maker"
                                }, ...attributes],
                            "collection": {
                                "name": nftView.nftCollectionNameEdit.text,
                                "family": nftView.nftCollectionFamilyEdit.text
                            },
                            "creators": [{
                                    "address": solana.publicKey,
                                    "share": 100
                                }]
                        }
                        solana.upload(result.image,
                                      GlobalState.getSaveObject(), options)
                    })
                }
                solana.onUploadFinished: (data, code, status) => {
                                             console.log(
                                                 "upload finished, start verifying")
                                             if (code === 0) {
                                                 let options = {
                                                     "network": SolanaApi.network,
                                                     "cachename": cacheName
                                                 }

                                                 nftView.nftStateText.text = "Uploaded"
                                                 nftView.nftStateBar.value = 2

                                                 solana.verify(options)
                                             } else {
                                                 nftView.nftStateText.text = "Error on Upload"
                                                 nftView.nftStateBar.value = nftView.nftStateBar.to
                                             }
                                         }
                solana.onVerifyFinished: (data, code, status) => {
                                             console.log(
                                                 "verify finished, start candy machine")
                                             if (code === 0) {
                                                 let options = {
                                                     "network": SolanaApi.network,
                                                     "cachename": cacheName,
                                                     "price": nftPriceEdit.realValue
                                                 }
                                                 solana.create(options)
                                                 nftView.nftStateText.text = "Verified"
                                                 nftView.nftStateBar.value = 3
                                             } else {
                                                 nftView.nftStateText.text
                                                 = "Error on Upload Verification"
                                                 nftView.nftStateBar.value = nftView.nftStateBar.to
                                             }
                                         }
                solana.onCreateFinished: (data, code, status) => {
                                             console.log(
                                                 "candy machine created, update start date")
                                             if (code === 0) {
                                                 let options = {
                                                     "network": SolanaApi.network,
                                                     "cachename": cacheName,
                                                     "date": new Date().toLocaleString(
                                                                 Qt.locale(
                                                                     "en_US"),
                                                                 "dd MMM yyyy HH:mm:ss t") // nftDateEdit.text
                                                 }
                                                 solana.update(options)
                                                 nftView.nftStateText.text = "Candy Machine Created"
                                                 nftView.nftStateBar.value = 4
                                             } else {
                                                 nftView.nftStateText.text
                                                 = "Error on Candy Machine Creation"
                                                 nftView.nftStateBar.value = nftView.nftStateBar.to
                                             }
                                         }
                solana.onUpdateFinished: (data, code, status) => {
                                             console.log(
                                                 "candy machine updated, start minting")
                                             if (code === 0) {
                                                 let options = {
                                                     "network": SolanaApi.network,
                                                     "cachename": cacheName
                                                 }
                                                 solana.mint(options)
                                                 nftView.nftStateText.text = "Candy Machine Updated"
                                                 nftView.nftStateBar.value = 5
                                             } else {
                                                 nftView.nftStateText.text
                                                 = "Error on Candy Machine Update"
                                                 nftView.nftStateBar.value = nftView.nftStateBar.to
                                             }
                                         }
                solana.onMintFinished: (data, code, status) => {
                                           console.log(
                                               "token minted, start signing")
                                           if (code === 0) {
                                               let options = {
                                                   "network": SolanaApi.network,
                                                   "cachename": cacheName
                                               }
                                               solana.sign(options)
                                               nftView.nftStateText.text = "Token Minted"
                                               nftView.nftStateBar.value = 6
                                           } else {
                                               nftView.nftStateText.text = "Error on Token Mint"
                                               nftView.nftStateBar.value = nftView.nftStateBar.to
                                           }
                                       }
                solana.onSignFinished: (data, code, status) => {
                                           console.log(
                                               "candy machine created, update start date")
                                           if (code === 0) {
                                               nftView.nftStateText.text = "Candy Machine Signed"
                                               nftView.nftStateBar.value = 7

                                               console.log(
                                                   "Your NFT are ready in your account")
                                           } else {
                                               nftView.nftStateText.text = "Candy Machine Signed"
                                               nftView.nftStateBar.value = nftView.nftStateBar.to
                                           }
                                       }
            }
        }

        Item {
            id: helpComponent
            visible: helpPane
            anchors.fill: parent

            HelpView {
                id: help
                width: 250
                height: 300
                helpMode: viewMode
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.top: parent.top
                anchors.topMargin: 20
            }
        }

        Item {
            id: miniViewComponent
            visible: viewMode < 2
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

        Item {
            id: inputViewer
            visible: InputPane
            anchors.fill: parent
            InputViewer {}
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

            Button {
                id: nftButton
                width: viewBar.buttonSize
                height: viewBar.buttonSize
                text: qsTr("NFT")
                flat: viewMode != 3
                font.styleName: "Regular"
                highlighted: viewMode == 3
                icon.source: "qrc:/ui/images/storefront_black_48dp.svg"
                display: AbstractButton.TextUnderIcon
                Material.accent: Material.Cyan
                onClicked: {
                    viewMode = 3
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

    QtLabs.FileDialog {
        id: saveFileDialog
        folder: QtLabs.StandardPaths.writableLocation(
                    QtLabs.StandardPaths.DocumentsLocation)
        fileMode: QtLabs.FileDialog.SaveFile
        defaultSuffix: "json"
        nameFilters: ["JSON Files (*.json)"]
    }

    QtLabs.FileDialog {
        id: exportImageDialog
        folder: QtLabs.StandardPaths.writableLocation(
                    QtLabs.StandardPaths.PicturesLocation)
        fileMode: QtLabs.FileDialog.SaveFile
        defaultSuffix: "png"
        nameFilters: ["PNG Image Files (*.png)"]

        onFileChanged: {
            let exportFileName = exportImageDialog.file.toString()

            if (exportFileName === "")
                return
            view.grabToImage(function (result) {
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

    PaletteLoader {
        id: paletteLoader
        onLoaded: colors => {
                      Constants.defaultColorPalette = colors.map(
                          color => color.toString())
                  }
    }

    QtLabs.FileDialog {
        id: loadPaletteDialog
        folder: QtLabs.StandardPaths.writableLocation(
                    QtLabs.StandardPaths.HomeLocation)
        fileMode: QtLabs.FileDialog.OpenFile
        defaultSuffix: "png"
        nameFilters: ["PNG Image Files (*.png)"]

        onFileChanged: {
            let paletteFileName = loadPaletteDialog.file.toString()

            if (paletteFileName === "")
                return
            paletteLoader.load(paletteFileName)
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

    QtLabs.FileDialog {
        id: exportModelDialog
        folder: QtLabs.StandardPaths.writableLocation(
                    QtLabs.StandardPaths.DocumentsLocation)
        fileMode: QtLabs.FileDialog.SaveFile
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

    Dialog {
        id: openPaletteInfoDialog
        modal: true
        standardButtons: Dialog.Ok
        title: qsTr("Palette loaded")
        Label {
            text: "Color palette loaded successfully"
        }
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
    }
    Dialog {
        id: openPaletteErrorDialog
        modal: true
        standardButtons: Dialog.Ok
        title: qsTr("Error Loading Palette")
        Label {
            text: "Can't load color palette right now!"
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

