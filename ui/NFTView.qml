import QtQuick 2.15
import PixelModelMaker 1.0
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

import com.github.zaghaghi.pixelmodelmaker 1.0

Pane {
    padding: 10
    Material.background: Constants.toolbarColor
    width: Constants.canvasSize + padding * 2
    height: Constants.canvasSize + padding * 2
    anchors.verticalCenter: parent.verticalCenter
    anchors.horizontalCenter: parent.horizontalCenter
    background: Rectangle {
        radius: 5
        color: Constants.toolbarColor
    }

    Item {
        anchors.fill: parent

        Column {
            Button {
                text: "create wallete"
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
                                                 console.log("ERR", req.status)
                                             })
                }
            }

            Button {
                text: "balance"
                visible: solana.publicKey.length > 0
                onClicked: {
                    SolanaApi.getBalance(solana.publicKey, (balance, req) => {
                                             console.log("OK, Balance=",
                                                         balance, req)
                                         }, req => {
                                             console.log("ERR", req.status)
                                         })
                }
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
