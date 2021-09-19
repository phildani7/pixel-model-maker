import QtQuick 2.15
import PixelModelMaker 1.0
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls.Material.impl 2.15

import com.github.zaghaghi.pixelmodelmaker 1.0

Item {
    property alias uploadNft: uploadButton
    property alias solana: solana
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
                Material.background: Constants.toolbarColor
                Material.accent: Material.Cyan
                textRole: "key"
                currentIndex: 1
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
        padding: 10
        Material.background: Constants.toolbarColor
        width: Constants.canvasSize + padding * 2
        height: Constants.canvasSize + padding * 2
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

        Item {
            anchors.fill: parent

            Column {
                Button {
                    text: "create wallet"
                    visible: solana.publicKey.length === 0
                    onClicked: {
                        console.log(solana.newKeypair())
                    }
                }

                Button {
                    text: "airdrop"
                    visible: solana.publicKey.length > 0
                    onClicked: {
                        SolanaApi.requestAirdrop(solana.publicKey,
                                                 1000000000, () => {
                                                     console.log("OK")
                                                 }, req => {
                                                     console.log("ERR",
                                                                 req.status)
                                                 })
                    }
                }

                Button {
                    text: "balance"
                    visible: solana.publicKey.length > 0
                    onClicked: {
                        SolanaApi.getBalance(solana.publicKey,
                                             (balance, req) => {
                                                 console.log("OK, Balance=",
                                                             balance, req)
                                             }, req => {
                                                 console.log("ERR", req.status)
                                             })
                    }
                }

                Button {
                    id: uploadButton
                    text: "Upload"
                }

                Text {
                    id: publicKey
                    text: solana.publicKey
                    color: "white"
                }
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
