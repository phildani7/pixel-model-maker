import QtQuick 2.15
import QtQuick.Controls 2.15
import PixelModelMaker 1.0
import QtQuick.Controls.Material 2.15
import QtQuick.Controls.Material.impl 2.15

Pane {
    background: Rectangle {
        radius: 5
        color: Constants.toolbarColor
        layer.enabled: true
        layer.effect: ElevationEffect {
            elevation: 10
        }
    }
    Slider {
        padding: 10
        anchors.horizontalCenter: parent.horizontalCenter
        height: parent.height / 2
        from: 1
        to: 5
        Material.accent: Material.Cyan
        stepSize: 0.5
        snapMode: Slider.SnapAlways
        value: GlobalState.depthScaleFactor
        onValueChanged: {
            GlobalState.depthScaleFactor = value
        }
    }
    Rectangle {
        anchors.bottom: parent.bottom
        height: parent.height / 2
        width: parent.width
        color: Constants.toolbarColor
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            ToolButton {
                text: ""
                display: AbstractButton.IconOnly
                icon.source: "qrc:/ui/images/align_horizontal_left_black_48dp.svg"
                highlighted: GlobalState.depthAlign === 1
                flat: true
                Material.accent: Material.Cyan
                onClicked: GlobalState.depthAlign = 1
            }
            ToolButton {
                text: ""
                display: AbstractButton.IconOnly
                icon.source: "qrc:/ui/images/align_horizontal_center_black_48dp.svg"
                highlighted: GlobalState.depthAlign === 0
                flat: true
                Material.accent: Material.Cyan
                onClicked: GlobalState.depthAlign = 0
            }
            ToolButton {
                text: ""
                display: AbstractButton.IconOnly
                icon.source: "qrc:/ui/images/align_horizontal_right_black_48dp.svg"
                highlighted: GlobalState.depthAlign === -1
                flat: true
                Material.accent: Material.Cyan
                onClicked: GlobalState.depthAlign = -1
            }
        }
    }
}
