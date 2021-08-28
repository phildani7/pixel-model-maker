pragma Singleton

import QtQuick 2.15

QtObject {
    readonly property var shapeLoader: Qt.createComponent(
                                           "qrc:/ui/shapes/Shape.qml")

    function createInstance(name, parent, x, y, color, depth) {
        return shapeLoader.createObject(parent, {
                                            "name": name,
                                            "x": x,
                                            "y": y,
                                            "z": 0,
                                            "shapeColor": color,
                                            "depth": depth
                                        })
    }

    readonly property var shapes: {
        "cube": {
            "create": (parent, x, y, color, depth) => createInstance("cube",
                                                                     parent, x,
                                                                     y, color,
                                                                     depth),
            "draw": (ctx, x, y, w, h) => {
                ctx.fillRect(x, y, w, h)
            },
            "next": "cube"
        },
        "tricube": {
            "create": (parent, x, y, color, depth) => createInstance("tricube",
                                                                     parent, x,
                                                                     y, color,
                                                                     depth),
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
            "create": (parent, x, y, color, depth) => createInstance(
                          "tricube90", parent, x, y, color, depth),
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
            "create": (parent, x, y, color, depth) => createInstance(
                          "tricube180", parent, x, y, color, depth),
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
            "create": (parent, x, y, color, depth) => createInstance(
                          "tricube270", parent, x, y, color, depth),
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
            "create": (parent, x, y, color, depth) => createInstance("cutcube",
                                                                     parent, x,
                                                                     y, color,
                                                                     depth),
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
            "create": (parent, x, y, color, depth) => createInstance(
                          "cutcube90", parent, x, y, color, depth),
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
            "create": (parent, x, y, color, depth) => createInstance(
                          "cutcube180", parent, x, y, color, depth),
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
            "create": (parent, x, y, color, depth) => createInstance(
                          "cutcube270", parent, x, y, color, depth),
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
            "create": (parent, x, y, color, depth) => createInstance("half",
                                                                     parent, x,
                                                                     y, color,
                                                                     depth),
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
            "create": (parent, x, y, color, depth) => createInstance("half90",
                                                                     parent, x,
                                                                     y, color,
                                                                     depth),
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
            "create": (parent, x, y, color, depth) => createInstance("half180",
                                                                     parent, x,
                                                                     y, color,
                                                                     depth),
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
            "create": (parent, x, y, color, depth) => createInstance("half270",
                                                                     parent, x,
                                                                     y, color,
                                                                     depth),
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
            "create": (parent, x, y, color, depth) => createInstance("pie",
                                                                     parent, x,
                                                                     y, color,
                                                                     depth),
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
            "create": (parent, x, y, color, depth) => createInstance("pie90",
                                                                     parent, x,
                                                                     y, color,
                                                                     depth),
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
            "create": (parent, x, y, color, depth) => createInstance("pie180",
                                                                     parent, x,
                                                                     y, color,
                                                                     depth),
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
            "create": (parent, x, y, color, depth) => createInstance("pie270",
                                                                     parent, x,
                                                                     y, color,
                                                                     depth),
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
            "create": (parent, x, y, color, depth) => createInstance("point",
                                                                     parent, x,
                                                                     y, color,
                                                                     depth),
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
            "create": (parent, x, y, color, depth) => createInstance("point90",
                                                                     parent, x,
                                                                     y, color,
                                                                     depth),
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
            "create": (parent, x, y, color, depth) => createInstance(
                          "point180", parent, x, y, color, depth),
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
            "create": (parent, x, y, color, depth) => createInstance(
                          "point270", parent, x, y, color, depth),
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
        },
        "roundcube": {
            "create": (parent, x, y, color, depth) => createInstance(
                          "roundcube", parent, x, y, color, depth),
            "draw": (ctx, x, y, w, h) => {
                ctx.beginPath()
                ctx.moveTo(x, y)
                ctx.lineTo(x + w / 2, y)
                ctx.arc(x + w / 2, y + h / 2, w / 2, 3 * Math.PI / 2, 0)
                ctx.lineTo(x + w, y + h)
                ctx.lineTo(x, y + h)
                ctx.lineTo(x, y)
                ctx.closePath()
                ctx.fill()
            },
            "next": "roundcube90"
        },
        "roundcube90": {
            "create": (parent, x, y, color, depth) => createInstance(
                          "roundcube90", parent, x, y, color, depth),
            "draw": (ctx, x, y, w, h) => {
                ctx.beginPath()
                ctx.moveTo(x, y)
                ctx.lineTo(x + w, y)
                ctx.lineTo(x + w, y + h / 2)
                ctx.arc(x + w / 2, y + h / 2, w / 2, 0, Math.PI / 2)
                ctx.lineTo(x, y + h)
                ctx.lineTo(x, y)
                ctx.closePath()
                ctx.fill()
            },
            "next": "roundcube180"
        },
        "roundcube180": {
            "create": (parent, x, y, color, depth) => createInstance(
                          "roundcube180", parent, x, y, color, depth),
            "draw": (ctx, x, y, w, h) => {
                ctx.beginPath()
                ctx.moveTo(x, y)
                ctx.lineTo(x + w, y)
                ctx.lineTo(x + w, y + h)
                ctx.lineTo(x + w / 2, y + h)
                ctx.arc(x + w / 2, y + h / 2, w / 2, Math.PI / 2, Math.PI)
                ctx.lineTo(x, y)
                ctx.closePath()
                ctx.fill()
            },
            "next": "roundcube270"
        },
        "roundcube270": {
            "create": (parent, x, y, color, depth) => createInstance(
                          "roundcube270", parent, x, y, color, depth),
            "draw": (ctx, x, y, w, h) => {
                ctx.beginPath()
                ctx.moveTo(x + w / 2, y)
                ctx.lineTo(x + w, y)
                ctx.lineTo(x + w, y + h)
                ctx.lineTo(x, y + h)
                ctx.lineTo(x, y + h / 2)
                ctx.arc(x + w / 2, y + h / 2, w / 2, Math.PI, 3 * Math.PI / 2)
                ctx.closePath()
                ctx.fill()
            },
            "next": "roundcube"
        },
        "roundpoint": {
            "create": (parent, x, y, color, depth) => createInstance(
                          "roundpoint", parent, x, y, color, depth),
            "draw": (ctx, x, y, w, h) => {
                ctx.beginPath()
                ctx.moveTo(x, y)
                ctx.lineTo(x + w / 2, y)
                ctx.arc(x + w / 2, y + h / 2, w / 2,
                        3 * Math.PI / 2, Math.PI / 2)
                ctx.lineTo(x, y + h)
                ctx.closePath()
                ctx.fill()
            },
            "next": "roundpoint90"
        },
        "roundpoint90": {
            "create": (parent, x, y, color, depth) => createInstance(
                          "roundpoint90", parent, x, y, color, depth),
            "draw": (ctx, x, y, w, h) => {
                ctx.beginPath()
                ctx.moveTo(x, y)
                ctx.lineTo(x + w, y)
                ctx.lineTo(x + w, y + h / 2)
                ctx.arc(x + w / 2, y + h / 2, w / 2, 0, Math.PI)
                ctx.closePath()
                ctx.fill()
            },
            "next": "roundpoint180"
        },
        "roundpoint180": {
            "create": (parent, x, y, color, depth) => createInstance(
                          "roundpoint180", parent, x, y, color, depth),
            "draw": (ctx, x, y, w, h) => {
                ctx.beginPath()
                ctx.moveTo(x + w / 2, y)
                ctx.lineTo(x + w, y)
                ctx.lineTo(x + w, y + h)
                ctx.lineTo(x + w / 2, y + h)
                ctx.arc(x + w / 2, y + h / 2, w / 2, Math.PI / 2,
                        3 * Math.PI / 2)
                ctx.closePath()
                ctx.fill()
            },
            "next": "roundpoint270"
        },
        "roundpoint270": {
            "create": (parent, x, y, color, depth) => createInstance(
                          "roundpoint270", parent, x, y, color, depth),
            "draw": (ctx, x, y, w, h) => {
                ctx.beginPath()
                ctx.moveTo(x + w, y + h / 2)
                ctx.lineTo(x + w, y + h)
                ctx.lineTo(x, y + h)
                ctx.arc(x + w / 2, y + h / 2, w / 2, Math.PI, 0)
                ctx.closePath()
                ctx.fill()
            },
            "next": "roundpoint"
        },
        "curve": {
            "create": (parent, x, y, color, depth) => createInstance("curve",
                                                                     parent, x,
                                                                     y, color,
                                                                     depth),
            "draw": (ctx, x, y, w, h) => {
                ctx.beginPath()
                ctx.moveTo(x, y)
                ctx.lineTo(x, y + h)
                ctx.lineTo(x + 1, y + h)
                ctx.arc(x + w, y, w, Math.PI / 2, Math.PI)
                ctx.closePath()
                ctx.fill()
            },
            "next": "curve90"
        },
        "curve90": {
            "create": (parent, x, y, color, depth) => createInstance("curve90",
                                                                     parent, x,
                                                                     y, color,
                                                                     depth),
            "draw": (ctx, x, y, w, h) => {
                ctx.beginPath()
                ctx.moveTo(x, y)
                ctx.lineTo(x, y + h)
                ctx.arc(x + w, y + h, w, Math.PI, 3 * Math.PI / 2)
                ctx.closePath()
                ctx.fill()
            },
            "next": "curve180"
        },
        "curve180": {
            "create": (parent, x, y, color, depth) => createInstance(
                          "curve180", parent, x, y, color, depth),
            "draw": (ctx, x, y, w, h) => {
                ctx.beginPath()
                ctx.moveTo(x, y)
                ctx.arc(x, y + h, w, 3 * Math.PI / 2, 0)
                ctx.lineTo(x + w, y)
                ctx.closePath()
                ctx.fill()
            },
            "next": "curve270"
        },
        "curve270": {
            "create": (parent, x, y, color, depth) => createInstance(
                          "curve270", parent, x, y, color, depth),
            "draw": (ctx, x, y, w, h) => {
                ctx.beginPath()
                ctx.arc(x, y, w, 0, Math.PI / 2)
                ctx.lineTo(x + w, y + h)
                ctx.closePath()
                ctx.fill()
            },
            "next": "curve"
        }
    }
}
