pragma Singleton

import QtQuick 2.15
import PixelModelMaker 1.0

QtObject {
    property variant pixelMap: null
    property int gridWidth: 0
    property int gridHeight: 0

    property color selectedColor: Constants.defaultColorPalette[0]

    function destroyPixelMap() {
        if (pixelMap === null || gridHeight === 0 || gridWidth === 0) {
            return
        }
        if (pixelMap !== null) {
            for (var i = 0; i < gridHeight; ++i) {
                for (var j = 0; j < gridWidth; ++j) {
                    if (pixelMap[i][j].shape !== null) {
                        pixelMap[i][j].shape.destroy()
                    }
                }
            }
        }
    }

    function createPixelMap(width, height) {

        gridWidth = width
        gridHeight = height
        pixelMap = []
        for (var i = 0; i < gridHeight; ++i) {
            let pixelRow = []
            for (var j = 0; j < gridWidth; ++j) {
                pixelRow.push({
                                  "color": null,
                                  "depth": 0,
                                  "shape": null
                              })
            }
            pixelMap.push(pixelRow)
        }
    }
}
