import QtQuick 2.15
import PixelModelMaker 1.0
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls.Material.impl 2.15

import com.github.zaghaghi.pixelmodelmaker 1.0

Item {
    property alias uploadNft: uploadButton
    property alias solana: solana

    property alias nftNameEdit: nftNameEdit
    property alias nftSymbolEdit: nftSymbolEdit
    property alias nftDescriptionEdit: nftDescriptionEdit
    property alias nftAttributesEdit: nftAttributesEdit
    property alias nftCollectionNameEdit: nftCollectionNameEdit
    property alias nftCollectionFamilyEdit: nftCollectionFamilyEdit
    property alias nftPriceEdit: nftPriceEdit
    property alias nftDateEdit: nftDateEdit
    property alias nftStateText: nftStateText
    property alias nftStateBar: nftStateBar

    anchors.fill: parent
    Text {
        text: qsTr("Powered by Metaplex")
        color: "#aaaaaa"
        font.pointSize: 12
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
    }
    Pane {
        id: walletPane
        padding: 10
        topPadding: 20
        Material.background: Constants.toolbarColor
        width: 200
        height: 250
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.left: inputPane.right
        anchors.leftMargin: 10
        background: Rectangle {
            radius: 5
            color: Constants.toolbarColor
            layer.enabled: true
            layer.effect: ElevationEffect {
                elevation: 10
            }
        }
        ProgressBar {
            id: loadingBar
            indeterminate: true
            anchors.top: parent.top
            anchors.topMargin: -9
            width: 200 - 6
            anchors.horizontalCenter: parent.horizontalCenter
            Material.accent: Material.Cyan
            visible: false
        }

        Column {
            anchors.fill: parent
            Text {
                text: qsTr("Balance")
                color: Constants.titleColor
                font.pointSize: 20
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
            }

            function updateBalance(balance, req) {
                let balanceInt = parseInt(balance / 1000000000.0)
                let balanceFraction = balance / 1000000000.0 - balanceInt
                balanceText.text = balanceInt
                balanceFractionText.text = balanceFraction.toString(
                            ).substring(1)
                if (balanceFractionText.text.length === 0) {
                    balanceFractionText.text = ".0"
                }
                loadingBar.visible = false
            }
            function handleBalanceError(req) {
                balanceFractionText.text = ".0"
                balanceText.text = "NaN"
                loadingBar.visible = false
            }

            Text {
                id: balanceText
                text: qsTr("0")
                color: Constants.titleColor
                font.pointSize: 40
                anchors.horizontalCenter: parent.horizontalCenter

                Component.onCompleted: {
                    if (solana.publicKey.length === 0)
                        return
                    loadingBar.visible = true
                    SolanaApi.getBalance(solana.publicKey,
                                         parent.updateBalance,
                                         parent.handleBalanceError)
                }
            }

            Text {
                id: balanceFractionText
                text: qsTr(".0")
                color: Constants.titleColor
                font.pointSize: 16
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: qsTr("SOL")
                color: Constants.titleColor
                font.pointSize: 12
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Row {
                width: parent.width
                padding: 10
                Text {
                    id: walletAddress
                    topPadding: 10
                    width: parent.width - walletAddressCopyButton.width - parent.padding
                    text: "(" + solana.publicKey + ")"
                    color: Constants.titleColor
                    clip: true
                    elide: Text.ElideMiddle
                }
                TextEdit {
                    id: walletAddressText
                    text: solana.publicKey
                    visible: false
                }
                ToolButton {
                    id: walletAddressCopyButton
                    topPadding: 10
                    icon.source: "qrc:/ui/images/content_copy_black_48dp.svg"
                    width: 34
                    height: 34
                    onClicked: {
                        walletAddressText.selectAll()
                        walletAddressText.copy()
                    }
                }
            }
            ComboBox {
                id: solanaNetwork
                padding: 10
                width: parent.width
                Material.accent: Material.Cyan
                anchors.topMargin: 10
                textRole: "key"
                currentIndex: 1
                enabled: nftStateBar.value === nftStateBar.to
                model: ListModel {
                    id: model
                    ListElement {
                        key: "Mainnet Beta"
                        value: "mainnet-beta"
                    }
                    ListElement {
                        key: "Devnet"
                        value: "devnet"
                    }
                    ListElement {
                        key: "Testnet"
                        value: "testnet"
                    }
                }
                popup.background: Rectangle {
                    color: Constants.toolbarColor
                }

                onActivated: index => {
                                 loadingBar.visible = true
                                 SolanaApi.updateNetwork(model.get(index).value)
                                 SolanaApi.getBalance(solana.publicKey,
                                                      parent.updateBalance,
                                                      parent.handleBalanceError)
                             }
            }
        }
    }
    Pane {
        id: inputPane
        padding: 20
        Material.background: Constants.toolbarColor
        width: Constants.canvasSize + padding * 2
        height: 420 + padding * 2
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        background: Rectangle {
            radius: 5
            color: Constants.toolbarColor
            layer.enabled: true
            layer.effect: ElevationEffect {
                elevation: 10
            }
        }

        Column {
            anchors.fill: parent
            height: parent.height
            Button {
                text: "Create Wallet"
                visible: solana.publicKey.length === 0
                onClicked: {
                    console.log(solana.newKeypair())
                }
            }
            Text {
                text: qsTr("Information")
                color: Constants.titleColor
                font.pointSize: 20
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Row {
                width: parent.width
                spacing: 10
                TextField {
                    id: nftNameEdit
                    width: parent.width / 2 - 5
                    placeholderText: "Name"
                    Material.accent: Material.Cyan
                    selectByMouse: true
                }

                TextField {
                    id: nftSymbolEdit
                    width: parent.width / 2 - 5
                    placeholderText: "Symbol"
                    Material.accent: Material.Cyan
                    selectByMouse: true
                }
            }
            TextField {
                id: nftDescriptionEdit
                width: parent.width
                placeholderText: "Description"
                Material.accent: Material.Cyan
                selectByMouse: true
            }
            TextField {
                id: nftAttributesEdit
                width: parent.width
                placeholderText: "Attributes [attribute1=value1, attribute2=value2]"
                Material.accent: Material.Cyan
                selectByMouse: true
            }

            GroupBox {
                topPadding: 50

                label: Text {
                    topPadding: 15
                    text: "Collection"
                    color: Constants.titleColor
                }
                width: parent.width
                Row {
                    width: parent.width
                    spacing: 10
                    TextField {
                        id: nftCollectionNameEdit
                        width: parent.width / 2 - 5
                        placeholderText: "Name"
                        Material.accent: Material.Cyan
                        selectByMouse: true
                    }

                    TextField {
                        id: nftCollectionFamilyEdit
                        width: parent.width / 2 - 5
                        placeholderText: "Family"
                        Material.accent: Material.Cyan
                        selectByMouse: true
                    }
                }
            }
            Item {
                width: parent.width
                height: 10
            }

            SpinBox {
                id: nftPriceEdit
                property int decimals: 4
                property int multiplyer: 10000 // 10 ** decimals
                property real realValue: value / multiplyer
                from: 0
                value: multiplyer
                to: 100 * multiplyer
                stepSize: 100
                width: parent.width
                editable: true
                Material.accent: Material.Cyan
                validator: DoubleValidator {
                    bottom: Math.min(nftPriceEdit.from, nftPriceEdit.to)
                    top: Math.max(nftPriceEdit.from, nftPriceEdit.to)
                }

                textFromValue: function (value, locale) {
                    return Number(value / multiplyer).toLocaleString(
                                locale, "f", nftPriceEdit.decimals) + " SOL"
                }

                valueFromText: function (text, locale) {
                    text = text.split(" ")[0]
                    return Number.fromLocaleString(locale, text) * multiplyer
                }
            }

            TextField {
                id: nftDateEdit
                topPadding: 10
                text: new Date().toLocaleString(Qt.locale("en_US"),
                                                "dd MMM yyyy HH:mm:ss t")
                width: parent.width
                inputMethodHints: Qt.ImhDate
                placeholderText: "Start [01 Jan 2021 00:00:00 GMT]"
                Material.accent: Material.Cyan
                visible: false
            }
            Item {
                width: parent.width
                height: 20
            }
            Text {
                id: nftStateText
                text: qsTr("Not Started")
                color: Constants.titleColor
                font.pointSize: 10
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
            }

            ProgressBar {
                id: nftStateBar
                from: 0
                to: 7
                value: 7
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                Material.accent: Material.Cyan
            }
            Item {
                width: parent.width
                height: 20
            }

            Button {
                id: uploadButton
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Start"
                Material.accent: Material.Cyan
                enabled: nftNameEdit.text.length && nftSymbolEdit.text.length
                         && nftDescriptionEdit.text.length
                         && nftPriceEdit.value > 0 && nftDateEdit.text.length
                         && nftStateBar.value === nftStateBar.to
            }
        }

        Solana {
            id: solana
            onPublicKeyChanged: {
                console.log(solana.publicKey)
            }
        }
    }
}
