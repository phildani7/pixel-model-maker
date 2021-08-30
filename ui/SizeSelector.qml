import QtQuick 2.15
import QtQuick.Controls 2.15
import PixelModelMaker 1.0
import QtQuick.Controls.Material 2.15
import Qt.labs.platform 1.1 as QtLabs

import com.github.zaghaghi.pixelmodelmaker 1.0

Rectangle {
    id: rectangle
    width: 1000
    height: 600

    color: Constants.backgroundColor

    property alias buttonSize16: button_16
    property alias buttonSize24: button_24
    property alias buttonSize32: button_32

    property bool fileOpnedWithSuccess: false

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

            Button {
                id: button_open
                width: 100
                height: 100
                text: qsTr("Open")
                font.styleName: "Regular"
                highlighted: true
                icon.source: "qrc:/ui/images/open_in_browser_black_48dp.svg"
                display: AbstractButton.TextUnderIcon
                Material.accent: Material.BlueGrey

                onClicked: {
                    fileOpnedWithSuccess = false
                    openFileDialog.file = ""
                    io.reset()
                    openFileDialog.open()
                }
            }
            Button {
                id: button_import
                width: 100
                height: 100
                text: qsTr("Import PNG")
                font.styleName: "Regular"
                highlighted: true
                icon.source: "qrc:/ui/images/insert_photo_black_48dp.svg"
                display: AbstractButton.TextUnderIcon
                Material.accent: Material.BlueGrey

                onClicked: {
                    importPNGDialog.file = ""
                    importPNGDialog.open()
                }
            }
        }
    }
    FileIO {
        id: io
        source: openFileDialog.file

        onSourceChanged: {
            io.read()
        }

        onTextChanged: {
            if (!GlobalState.setOpenString(io.text, io.source)) {
                errorDialog.open()
                return
            }
            fileOpnedWithSuccess = true
        }
    }

    QtLabs.FileDialog {
        id: openFileDialog
        folder: QtLabs.StandardPaths.writableLocation(
                    QtLabs.StandardPaths.DocumentsLocation)
        fileMode: QtLabs.FileDialog.OpenFile
        defaultSuffix: "json"
        nameFilters: ["JSON Files (*.json)"]
    }

    Dialog {
        id: errorDialog
        modal: true
        standardButtons: Dialog.Ok
        title: qsTr("Error Loading File")
        Label {
            text: "The selected file is invalid or have incompatible version"
        }
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
    }

    QtLabs.FileDialog {
        id: importPNGDialog
        folder: QtLabs.StandardPaths.writableLocation(
                    QtLabs.StandardPaths.DownloadsLocation)
        fileMode: QtLabs.FileDialog.OpenFile
        defaultSuffix: "png"
        nameFilters: ["PNG Image Files (*.png)"]

        onFileChanged: {
            imageImport.load(importPNGDialog.file)
        }
    }

    ImageImport {
        id: imageImport
        onLoaded: (width, height, pixels, palette) => {
                      console.log(palette)
                      let saveString = GlobalState.buildSaveStringFromPixels(
                          width, height, pixels, palette)

                      if (!GlobalState.setOpenString(saveString, "")) {
                          errorDialog.open()
                          return
                      }
                      fileOpnedWithSuccess = true
                  }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.9}
}
##^##*/

