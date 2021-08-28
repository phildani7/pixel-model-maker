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
        },
        "half": {
            "create": (parent, x, y, color, depth) => {
                var cubeComponent = Qt.createComponent(
                    "qrc:/ui/shapes/Half.qml")

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
                ctx.lineTo(x + w / 2, y + h)
                ctx.lineTo(x, y + h)
                ctx.lineTo(x, y)
                ctx.closePath()
                ctx.fill()
            },
            "next": "half90"
        },
        "half90": {
            "create": (parent, x, y, color, depth) => {
                var cubeComponent = Qt.createComponent(
                    "qrc:/ui/shapes/Half90.qml")

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
                ctx.lineTo(x, y + h / 2)
                ctx.lineTo(x, y)
                ctx.closePath()
                ctx.fill()
            },
            "next": "half180"
        },
        "half180": {
            "create": (parent, x, y, color, depth) => {
                var cubeComponent = Qt.createComponent(
                    "qrc:/ui/shapes/Half180.qml")

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
                ctx.lineTo(x + w / 2, y + h)
                ctx.lineTo(x + w / 2, y)
                ctx.closePath()
                ctx.fill()
            },
            "next": "half270"
        },
        "half270": {
            "create": (parent, x, y, color, depth) => {
                var cubeComponent = Qt.createComponent(
                    "qrc:/ui/shapes/Half270.qml")

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
                ctx.moveTo(x, y + h / 2)
                ctx.lineTo(x + w, y + h / 2)
                ctx.lineTo(x + w, y + h)
                ctx.lineTo(x, y + h)
                ctx.lineTo(x, y + h / 2)
                ctx.closePath()
                ctx.fill()
            },
            "next": "half"
        },
        "pie": {
            "create": (parent, x, y, color, depth) => {
                var cubeComponent = Qt.createComponent("qrc:/ui/shapes/Pie.qml")

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
                ctx.arc(x, y + h, w, 3 * Math.PI / 2, 0)
                ctx.lineTo(x, y + h)
                ctx.closePath()
                ctx.fill()
            },
            "next": "pie90"
        },
        "pie90": {
            "create": (parent, x, y, color, depth) => {
                var cubeComponent = Qt.createComponent(
                    "qrc:/ui/shapes/Pie90.qml")

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
                ctx.arc(x, y, w, 0, Math.PI / 2)
                ctx.lineTo(x, y)
                ctx.closePath()
                ctx.fill()
            },
            "next": "pie180"
        },
        "pie180": {
            "create": (parent, x, y, color, depth) => {
                var cubeComponent = Qt.createComponent(
                    "qrc:/ui/shapes/Pie180.qml")

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
                ctx.arc(x + w, y, w, Math.PI / 2, Math.PI)
                ctx.lineTo(x + w, y)
                ctx.closePath()
                ctx.fill()
            },
            "next": "pie270"
        },
        "pie270": {
            "create": (parent, x, y, color, depth) => {
                var cubeComponent = Qt.createComponent(
                    "qrc:/ui/shapes/Pie270.qml")

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
                ctx.arc(x + w, y + h, w, Math.PI, 3 * Math.PI / 2)
                ctx.lineTo(x + w, y + h)
                ctx.closePath()
                ctx.fill()
            },
            "next": "pie"
        },
        "point": {
            "create": (parent, x, y, color, depth) => {
                var cubeComponent = Qt.createComponent(
                    "qrc:/ui/shapes/Point.qml")

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
                ctx.lineTo(x + w / 2, y + h)
                ctx.lineTo(x, y + h)
                ctx.closePath()
                ctx.fill()
            },
            "next": "point90"
        },
        "point90": {
            "create": (parent, x, y, color, depth) => {
                var cubeComponent = Qt.createComponent(
                    "qrc:/ui/shapes/Point90.qml")

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
                ctx.lineTo(x, y + h / 2)
                ctx.closePath()
                ctx.fill()
            },
            "next": "point180"
        },
        "point180": {
            "create": (parent, x, y, color, depth) => {
                var cubeComponent = Qt.createComponent(
                    "qrc:/ui/shapes/Point180.qml")

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
                ctx.lineTo(x + w / 2, y + h)
                ctx.lineTo(x, y + h / 2)
                ctx.closePath()
                ctx.fill()
            },
            "next": "point270"
        },
        "point270": {
            "create": (parent, x, y, color, depth) => {
                var cubeComponent = Qt.createComponent(
                    "qrc:/ui/shapes/Point270.qml")

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
                ctx.lineTo(x + w, y + h / 2)
                ctx.lineTo(x + w, y + h)
                ctx.lineTo(x, y + h)
                ctx.lineTo(x, y + h / 2)
                ctx.closePath()
                ctx.fill()
            },
            "next": "point"
        }
    }
}
