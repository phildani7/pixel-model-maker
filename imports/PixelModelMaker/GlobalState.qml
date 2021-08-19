pragma Singleton
import QtQuick 2.15
import PixelModelMaker 1.0

QtObject {
    property variant pixelMap: null
    property int gridWidth: 0
    property int gridHeight: 0

    property color selectedColor: Constants.defaultColorPalette[0]

    function createPixelMap(width, height) {
        gridWidth = width
        gridHeight = height
        pixelMap = []
        for (var i = 0; i < gridHeight; ++i) {
            let pixelRow = []
            for (var j = 0; j < gridWidth; ++j) {
                pixelRow.push({
                     color: null,
                     depth: 1,
                     shape: 0
                })
            }
            pixelMap.push(pixelRow)
        }
    }
}
