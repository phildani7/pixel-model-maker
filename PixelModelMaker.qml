import QtQuick 2.15
import QtQuick.Window 2.12
import PixelModelMaker 1.0
import QtQuick.Controls.Material 2.12

Window {
    width: Constants.width
    height: Constants.height
    title: "Pixel Model Maker"
    Material.theme: Material.Dark

    SizeSelector {
        width: parent.width
        height: parent.height
    }

}
