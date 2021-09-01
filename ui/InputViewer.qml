import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls.Material.impl 2.15
import PixelModelMaker 1.0

Item {
    visible: GlobalState.inputSequence.length > 0
    anchors.fill: parent
    Pane {
        width: 300
        height: 50
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        background: Rectangle {
            radius: 5
            color: Constants.toolbarColor
            layer.enabled: true
            layer.effect: ElevationEffect {
                elevation: 10
            }
        }
        Text {
            id: inputViewerText
            text: GlobalState.inputSequence.split("|")[0]
            color: "white"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
