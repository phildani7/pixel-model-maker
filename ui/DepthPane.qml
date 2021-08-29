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
        anchors.fill: parent
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
}
