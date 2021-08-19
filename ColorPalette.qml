import QtQuick 2.15
import PixelModelMaker 1.0

Column {
    Row {
        id: header
        width: parent.width
        height: 30
        Text {
            text: "Color:"
        }
        Rectangle {
            width: 30
            height: 30
            color: GlobalState.selectedColor
        }
    }

    GridView {
        id: colorGrid
        width: parent.width
        height: parent.height - header.height
        cellWidth: 30
        cellHeight: 30
        model: Constants.defaultColorPalette
        focus: true
        clip: true
        delegate: Rectangle {
            x: 5
            y: 5
            width: 20
            height: 20
            color: modelData
            MouseArea {
                anchors.fill: parent
                onClicked: (event) => {
                    colorGrid.currentIndex = index
                    GlobalState.selectedColor = colorGrid.currentItem.color
                }
            }
        }
    }

}

