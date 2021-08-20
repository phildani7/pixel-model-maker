import QtQuick 2.15
import QtQuick.Window 2.12
import PixelModelMaker 1.0
import QtQuick.Controls.Material 2.12
import QtQuick.Controls 2.15

Window {
    width: Constants.width
    height: Constants.height
    title: "Pixel Model Maker"
    Material.theme: Material.Dark

    StackView {
        id: stackView
        initialItem: sizeSelector
        anchors.fill: parent
    }

    SizeSelector {
        id: sizeSelector
        width: parent.width
        height: parent.height
        buttonSize16.onClicked: pushGridPaint(16)
        buttonSize24.onClicked: pushGridPaint(24)
        buttonSize32.onClicked: pushGridPaint(32)

        function pushGridPaint(size) {
            GlobalState.destroyPixelMap()
            GlobalState.createPixelMap(size, size)
            gridPaint.viewMode = 0
            stackView.push(gridPaint, {
                               "gridSize": size
                           }, StackView.Immediate)
            gridPaint.view.resetRotation()
            gridPaint.canvas.repaint()
            gridPaint.depth.repaint()
        }
    }

    GridPaint {
        id: gridPaint
        visible: false
        width: parent.width
        height: parent.height
        backButton.onClicked: stackView.pop(StackView.Immediate)
        onViewModeChanged: () => {
                               gridPaint.canvas.repaint()
                               gridPaint.depth.repaint()
                           }
    }
}
