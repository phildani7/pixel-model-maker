pragma Singleton

import QtQuick 2.15

QtObject {
    readonly property var shapes: {
        "cube": {
            "create": (parent, x, y, color, depth) => {
                var cubeComponent = Qt.createComponent(
                    "qrc:/ui/shapes/Cube.qml")

                return cubeComponent.createObject(parent, {
                                                      "x": x,
                                                      "y": y,
                                                      "z": 0,
                                                      "shapeColor": color,
                                                      "depth": depth
                                                  })
            },
            "draw": (ctx, x, y, w, h) => {
                ctx.fillRect(x, y, w, h)
            },
            "next": "cube"
        },
        "tricube": {
            "create": (parent, x, y, color, depth) => {
                var cubeComponent = Qt.createComponent(
                    "qrc:/ui/shapes/Tricube.qml")

                return cubeComponent.createObject(parent, {
                                                      "x": x,
                                                      "y": y,
                                                      "z": 0,
                                                      "shapeColor": color,
                                                      "depth": depth
                                                  })
            },
            "draw": (ctx, x, y, w, h) => {
                ctx.beginPath()
                ctx.moveTo(x, y)
                ctx.lineTo(x, y + h)
                ctx.lineTo(x + w, y + h)
                ctx.lineTo(x, y)
                ctx.closePath()
                ctx.fill()
            },
            "next": "tricube90"
        },
        "tricube90": {
            "create": (parent, x, y, color, depth) => {
                var cubeComponent = Qt.createComponent(
                    "qrc:/ui/shapes/Tricube90.qml")

                return cubeComponent.createObject(parent, {
                                                      "x": x,
                                                      "y": y,
                                                      "z": 0,
                                                      "shapeColor": color,
                                                      "depth": depth
                                                  })
            },
            "draw": (ctx, x, y, w, h) => {
                ctx.beginPath()
                ctx.moveTo(x, y)
                ctx.lineTo(x + w, y)
                ctx.lineTo(x, y + h)
                ctx.lineTo(x, y)
                ctx.closePath()
                ctx.fill()
            },
            "next": "tricube180"
        },
        "tricube180": {
            "create": (parent, x, y, color, depth) => {
                var cubeComponent = Qt.createComponent(
                    "qrc:/ui/shapes/Tricube180.qml")

                return cubeComponent.createObject(parent, {
                                                      "x": x,
                                                      "y": y,
                                                      "z": 0,
                                                      "shapeColor": color,
                                                      "depth": depth
                                                  })
            },
            "draw": (ctx, x, y, w, h) => {
                ctx.beginPath()
                ctx.moveTo(x, y)
                ctx.lineTo(x + w, y)
                ctx.lineTo(x + w, y + h)
                ctx.lineTo(x, y)
                ctx.closePath()
                ctx.fill()
            },
            "next": "tricube270"
        },
        "tricube270": {
            "create": (parent, x, y, color, depth) => {
                var cubeComponent = Qt.createComponent(
                    "qrc:/ui/shapes/Tricube270.qml")

                return cubeComponent.createObject(parent, {
                                                      "x": x,
                                                      "y": y,
                                                      "z": 0,
                                                      "shapeColor": color,
                                                      "depth": depth
                                                  })
            },
            "draw": (ctx, x, y, w, h) => {
                ctx.beginPath()
                ctx.moveTo(x + w, y)
                ctx.lineTo(x + w, y + h)
                ctx.lineTo(x, y + h)
                ctx.lineTo(x + w, y)
                ctx.closePath()
                ctx.fill()
            },
            "next": "tricube"
        },
        "cutcube": {
            "create": (parent, x, y, color, depth) => {
                var cubeComponent = Qt.createComponent(
                    "qrc:/ui/shapes/Cutcube.qml")

                return cubeComponent.createObject(parent, {
                                                      "x": x,
                                                      "y": y,
                                                      "z": 0,
                                                      "shapeColor": color,
                                                      "depth": depth
                                                  })
            },
            "draw": (ctx, x, y, w, h) => {
                ctx.beginPath()
                ctx.moveTo(x, y)
                ctx.lineTo(x + w / 2, y)
                ctx.lineTo(x + w, y + h / 2)
                ctx.lineTo(x + w, y + h)
                ctx.lineTo(x, y + h)
                ctx.lineTo(x, y)
                ctx.closePath()
                ctx.fill()
            },
            "next": "cutcube90"
        },
        "cutcube90": {
            "create": (parent, x, y, color, depth) => {
                var cubeComponent = Qt.createComponent(
                    "qrc:/ui/shapes/Cutcube90.qml")

                return cubeComponent.createObject(parent, {
                                                      "x": x,
                                                      "y": y,
                                                      "z": 0,
                                                      "shapeColor": color,
                                                      "depth": depth
                                                  })
            },
            "draw": (ctx, x, y, w, h) => {
                ctx.beginPath()
                ctx.moveTo(x, y)
                ctx.lineTo(x + w, y)
                ctx.lineTo(x + w, y + h / 2)
                ctx.lineTo(x + w / 2, y + h)
                ctx.lineTo(x, y + h)
                ctx.lineTo(x, y)
                ctx.closePath()
                ctx.fill()
            },
            "next": "cutcube180"
        },
        "cutcube180": {
            "create": (parent, x, y, color, depth) => {
                var cubeComponent = Qt.createComponent(
                    "qrc:/ui/shapes/Cutcube180.qml")

                return cubeComponent.createObject(parent, {
                                                      "x": x,
                                                      "y": y,
                                                      "z": 0,
                                                      "shapeColor": color,
                                                      "depth": depth
                                                  })
            },
            "draw": (ctx, x, y, w, h) => {
                ctx.beginPath()
                ctx.moveTo(x, y)
                ctx.lineTo(x + w, y)
                ctx.lineTo(x + w, y + h)
                ctx.lineTo(x + w / 2, y + h)
                ctx.lineTo(x, y + h / 2)
                ctx.lineTo(x, y)
                ctx.closePath()
                ctx.fill()
            },
            "next": "cutcube270"
        },
        "cutcube270": {
            "create": (parent, x, y, color, depth) => {
                var cubeComponent = Qt.createComponent(
                    "qrc:/ui/shapes/Cutcube270.qml")

                return cubeComponent.createObject(parent, {
                                                      "x": x,
                                                      "y": y,
                                                      "z": 0,
                                                      "shapeColor": color,
                                                      "depth": depth
                                                  })
            },
            "draw": (ctx, x, y, w, h) => {
                ctx.beginPath()
                ctx.moveTo(x + w / 2, y)
                ctx.lineTo(x + w, y)
                ctx.lineTo(x + w, y + h)
                ctx.lineTo(x, y + h)
                ctx.lineTo(x, y + h / 2)
                ctx.lineTo(x + w / 2, y)
                ctx.closePath()
                ctx.fill()
            },
            "next": "cutcube"
        }
    }
}
