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

    readonly property var shapeNames: ["cube", "tricube", "cutcube", "half", "pie", "point", "roundcube", "roundpoint", "curve"]
    readonly property var shapes: {
        "cube": {
            "create": (parent, x, y, color, depth) => createInstance("cube",
                                                                     parent, x,
                                                                     y, color,
                                                                     depth),
            "draw": (ctx, x, y, w, h) => {
                ctx.fillRect(x, y, w, h)
            },
            "next": "cube",
            "prev": "cube"
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
            "next": "tricube90",
            "prev": "tricube270"
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
            "next": "tricube180",
            "prev": "tricube"
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
            "next": "tricube270",
            "prev": "tricube90"
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
            "next": "tricube",
            "prev": "tricube180"
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
            "next": "cutcube90",
            "prev": "cutcube270"
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
            "next": "cutcube180",
            "prev": "cutcube"
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
            "next": "cutcube270",
            "prev": "cutcube90"
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
            "next": "cutcube",
            "prev": "cutcube180"
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
            "next": "half90",
            "prev": "half270"
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
            "next": "half180",
            "prev": "half"
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
            "next": "half270",
            "prev": "half90"
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
            "next": "half",
            "prev": "half180"
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
            "next": "pie90",
            "prev": "pie270"
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
            "next": "pie180",
            "prev": "pie"
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
            "next": "pie270",
            "prev": "pie90"
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
            "next": "pie",
            "prev": "pie180"
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
            "next": "point90",
            "prev": "point270"
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
            "next": "point180",
            "prev": "point"
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
            "next": "point270",
            "prev": "point90"
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
            "next": "point",
            "prev": "point180"
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
            "next": "roundcube90",
            "prev": "roundcube270"
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
            "next": "roundcube180",
            "prev": "roundcube"
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
            "next": "roundcube270",
            "prev": "roundcube90"
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
            "next": "roundcube",
            "prev": "roundcube180"
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
            "next": "roundpoint90",
            "prev": "roundpoint270"
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
            "next": "roundpoint180",
            "prev": "roundpoint"
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
            "next": "roundpoint270",
            "prev": "roundpoint90"
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
            "next": "roundpoint",
            "prev": "roundpoint180"
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
            "next": "curve90",
            "prev": "curve270"
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
            "next": "curve180",
            "prev": "curve"
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
            "next": "curve270",
            "prev": "curve90"
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
            "next": "curve",
            "prev": "curve180"
        }
    }
}
