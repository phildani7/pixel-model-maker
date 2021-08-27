import QtQuick 2.15
import PixelModelMaker 1.0
import QtQuick.Controls.Material 2.15
import QtQuick.Controls 2.15

Pane {
    padding: 0
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
        buttonSize16.onClicked: createGridPaint(16)
        buttonSize24.onClicked: createGridPaint(24)
        buttonSize32.onClicked: createGridPaint(32)

        function pushGridPaint() {
            stackView.push(gridPaint, StackView.Immediate)
            gridPaint.viewMode = 0
            gridPaint.view.resetRotation()
            gridPaint.canvas.repaint()
            gridPaint.depth.repaint()
        }

        function createGridPaint(size) {
            GlobalState.destroyPixelMap()
            GlobalState.createPixelMap(size, size)
            pushGridPaint()
        }

        onFileOpnedWithSuccessChanged: {
            if (!sizeSelector.fileOpnedWithSuccess)
                return
            pushGridPaint()
        }
    }

    GridPaint {
        id: gridPaint
        visible: false
        width: parent.width
        height: parent.height
        backButton.onClicked: {
            GlobalState.fileName = ""
            stackView.pop(StackView.Immediate)
        }
        onViewModeChanged: () => {
                               gridPaint.canvas.repaint()
                               gridPaint.depth.repaint()
                           }
    }
}
