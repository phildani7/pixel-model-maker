import QtQuick 2.15

import QtQuick3D 1.15
import QtQuick3D.Helpers 1.14
import QtQuick3D.Effects 1.15
import QtQuick3D.Materials 1.14
import QtQuick.Controls.Material 2.12
import PixelModelMaker 1.0
import QtQuick.Controls 2.15

Pane {
    id: palettePane
    z: 1
    padding: 10
    Material.background: Constants.toolbarColor
    Material.elevation: 10

    Item {
        id: root
        property alias sceneView: sceneView
        property alias gridModelContainer: gridModelContainer
        width: 230
        height: 230

        View3D {
            id: sceneView
            anchors.fill: parent
            camera: perspCamera
            environment: environment

            Node {
                id: scene
                OrthographicCamera {
                    id: orthoCamera
                    x: 0
                    y: 0
                    z: 1600
                }

                PerspectiveCamera {
                    id: perspCamera
                    x: 0
                    y: 0
                    z: 1600
                }

                Node {
                    id: gridModelContainer

                    SequentialAnimation {
                        running: true
                        loops: Animation.Infinite
                        NumberAnimation {
                            target: gridModelContainer
                            running: true
                            property: "eulerRotation.y"
                            duration: 5000
                            from: 45
                            to: -45
                        }
                        NumberAnimation {
                            target: gridModelContainer
                            running: true
                            property: "eulerRotation.y"
                            duration: 5000
                            from: -45
                            to: 45
                        }
                    }

                    Timer {
                        interval: 1000
                        repeat: true
                        running: true
                        onTriggered: updateViewModel()

                        function updateViewModel() {
                            gridModelContainer.updateShapes()
                        }
                    }

                    function createShape(row, col, parent) {
                        const scale = 50
                        const xOffset = GlobalState.gridWidth / 2 * scale
                        const yOffset = GlobalState.gridHeight / 2 * scale
                        let pixel = GlobalState.pixelMap[row][col]
                        let color = pixel.color
                        let colorVector = Qt.vector3d(color.r, color.g, color.b)

                        var cubeComponent = Qt.createComponent(
                                    "shapes/Cube.qml")

                        let instance = cubeComponent.createObject(parent, {
                                                                      "x": -xOffset + col * scale,
                                                                      "y": yOffset - row * scale,
                                                                      "z": 0,
                                                                      "shapeColor": colorVector,
                                                                      "depth": pixel.depth
                                                                  })
                        return instance
                    }

                    function updateShape(row, col) {
                        let pixel = GlobalState.pixelMap[row][col]
                        let color = pixel.color
                        let colorVector = Qt.vector3d(color.r, color.g, color.b)

                        if (pixel.miniShape === null) {
                            pixel.miniShape = createShape(row, col,
                                                          gridModelContainer)
                        } else {
                            if (pixel.miniShape.shapeColor !== colorVector) {
                                pixel.miniShape.shapeColor = colorVector
                            }
                            if (pixel.depth !== pixel.miniShape.depth) {
                                pixel.miniShape.depth = pixel.depth
                            }
                        }
                    }

                    function updateShapes() {
                        for (var i = 0; i < GlobalState.gridWidth; ++i) {
                            for (var j = 0; j < GlobalState.gridHeight; ++j) {
                                if (GlobalState.pixelMap[i][j].color) {
                                    updateShape(i, j)
                                }
                            }
                        }
                    }
                }

                AreaLight {
                    id: mainLight
                    x: 0
                    y: 0
                    width: 3200
                    height: 3200
                    brightness: 150
                    z: 1600
                }

                PointLight {
                    id: fillLight
                    x: 0
                    y: 1600
                    brightness: 150
                    z: 0
                }
            }
        }
    }
}
