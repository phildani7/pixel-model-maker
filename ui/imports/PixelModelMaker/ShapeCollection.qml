pragma Singleton

import QtQuick 2.15
import PixelModelMaker 1.0

QtObject {
    readonly property var shapes: {
        "cube":{
            create: (parent, x, y, color, depth) => {
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
            draw: (ctx, x, y, w, h) => {
                ctx.fillRect(x, y, w, h)
            }
        },
        "tricube":{
            create: () => {

            },
            draw: () => {

            }
        }
    }

}
