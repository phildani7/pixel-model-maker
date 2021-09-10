pragma Singleton

import QtQuick 2.15
import PixelModelMaker 1.0

QtObject {
    property variant pixelMap: null
    property int gridWidth: 0
    property int gridHeight: 0

    property color selectedColor: Constants.defaultColorPalette[0]
    property string selectedShape: "cube"
    property int selectedDepth: 1
    property double depthScaleFactor: 1.0

    property int depthAlign: 0

    property string inputSequence: ""
    property var timer: Timer {
        id: inputSequenceClearTimer
        interval: 1000
        running: false
        onTriggered: {
            inputSequence = ""
        }
    }
    function setInputSequenceFromMouse(mouseEvent, text) {
        let inputSeqText = []
        if (mouseEvent.modifiers === Qt.ControlModifier) {
            inputSeqText.push("Ctrl")
        }
        if (mouseEvent.modifiers === Qt.ShiftModifier) {
            inputSeqText.push("Shift")
        }
        if (mouseEvent.modifiers === Qt.AltModifier) {
            inputSeqText.push("Alt")
        }

        if (mouseEvent.buttons === Qt.LeftButton
                || mouseEvent.button === Qt.LeftButton) {
            inputSeqText.push("Left")
        }
        if (mouseEvent.buttons === Qt.RightButton
                || mouseEvent.button === Qt.RightButton) {
            inputSeqText.push("Right")
        }
        if (mouseEvent.buttons === Qt.MiddleButton
                || mouseEvent.button === Qt.MiddleButton) {
            inputSeqText.push("Middle")
        }
        inputSequence = inputSeqText.join(
                    " + ") + " " + text + "|" + mouseEvent.x + mouseEvent.y
        inputSequenceClearTimer.restart()
    }

    property string fileName: ''

    function getSaveObject() {
        return {
            "version": "1.0",
            "palette": Constants.defaultColorPalette,
            "width": gridWidth,
            "height": gridHeight,
            "align": depthAlign,
            "pixels": pixelMap.map(row => row.map(item => {
                                                      return {
                                                          "color": item.color ? item.color.toString(
                                                                                    ) : null,
                                                          "depth": item.depth,
                                                          "shape": item.shapeName
                                                      }
                                                  }))
        }
    }

    function getSaveString() {
        return JSON.stringify(getSaveObject(), null, 2)
    }

    function buildSaveStringFromPixels(width, height, pixels, palette) {
        let jsonData = {
            "version": "1.0",
            "palette": palette.map(item => item.toString()),
            "width": width,
            "height": height,
            "align": 0,
            "pixels": null
        }

        let pixelsFixed = []
        if (pixels.length)
            for (var i = 0; i < height; ++i) {
                let row = []
                if (i < pixels.length) {
                    row = pixels[i]
                }
                let oldLength = row.length
                row.length = width
                row.fill(null, oldLength, width)
                pixelsFixed.push(row)
            }

        jsonData["pixels"] = pixelsFixed.map(row => row.map(item => {
                                                                return {
                                                                    "color": item ? item.toString(
                                                                                        ) : null,
                                                                    "depth": item ? 1 : 0,
                                                                    "shape": item ? "cube" : null
                                                                }
                                                            }))
        return JSON.stringify(jsonData)
    }

    function setOpenString(jsonData, fileName) {
        try {
            let data = JSON.parse(jsonData)
            if (data.version !== "1.0") {
                console.log("invalid version")
                return false
            }
            destroyPixelMap()
            gridWidth = data.width
            gridHeight = data.height
            depthAlign = data.align || 0
            Constants.defaultColorPalette = data.palette
            selectedColor = Constants.defaultColorPalette[0]
            pixelMap = data.pixels.map(row => row.map(item => {
                                                          return {
                                                              "color": item.color ? Qt.color(item.color) : null,
                                                              "depth": item.depth,
                                                              "shape": null,
                                                              "miniShape"// find and create shape based on item.shape which is shape name
                                                              : null,
                                                              "shapeName": item.shape
                                                          }
                                                      }))
            GlobalState.fileName = fileName
        } catch (exception) {
            console.log(exception)
            return false
        }
        return true
    }

    function destroyPixelMap() {
        if (pixelMap === null || gridHeight === 0 || gridWidth === 0) {
            return
        }
        if (pixelMap !== null) {
            for (var i = 0; i < gridHeight; ++i) {
                for (var j = 0; j < gridWidth; ++j) {
                    if (pixelMap[i][j].shape !== null) {
                        pixelMap[i][j].shape.destroy()
                        pixelMap[i][j].shape = null
                    }
                    if (pixelMap[i][j].miniShape !== null) {
                        pixelMap[i][j].miniShape.destroy()
                        pixelMap[i][j].miniShape = null
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
                                  "shape": null,
                                  "miniShape": null,
                                  "shapeName": null
                              })
            }
            pixelMap.push(pixelRow)
        }
    }
}
