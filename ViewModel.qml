import QtQuick 2.15
import QtQuick3D 1.15
import QtQuick3D.Helpers 1.14
import QtQuick3D.Effects 1.15
import QtQuick3D.Materials 1.14
import PixelModelMaker 1.0

Item {
    width: 1920
    height: 1080

    View3D {
        anchors.fill: parent
        camera: orthoCamera
        anchors.rightMargin: 0
        anchors.bottomMargin: -8
        anchors.leftMargin: 0
        anchors.topMargin: 8
        environment: environment

        SceneEnvironment {
            id: environment
            antialiasingMode: SceneEnvironment.SSAA
            aoSampleRate: 4
            aoStrength: 20
        }
        Node {
            id: scene
            PerspectiveCamera {
                id: perspCamera
                x: 0
                y: 201.958
                z: 521.69043
                eulerRotation.z: -0
                eulerRotation.y: 0
                eulerRotation.x: -16.1518
            }

            OrthographicCamera {
                id: orthoCamera
                x: 0
                y: 0
                z: 500
            }

            Node {
                id: gridModelContainer

                Timer {
                    interval: 1000
                    repeat: true
                    running: true
                    onTriggered: updateViewModel()

                    function updateViewModel() {
                        gridModelContainer.updateShapes()
                    }
                }
                function updateShapes() {
                    const scale = 50
                    const xOffset = GlobalState.gridWidth / 2 * scale
                    const yOffset = GlobalState.gridHeight / 2 * scale
                    for (var i = 0; i < GlobalState.gridWidth; ++i) {
                        for (var j = 0; j < GlobalState.gridHeight; ++j) {
                            if (GlobalState.pixelMap[i][j].color !== null) {

                                let color = GlobalState.pixelMap[i][j].color
                                let colorVector = Qt.vector3d(color.r,
                                                              color.g, color.b)

                                if (GlobalState.pixelMap[i][j].shape === null) {
                                    var cubeComponent = Qt.createComponent(
                                                "shapes/PixelCube.qml")

                                    let instance = cubeComponent.createObject(
                                            gridModelContainer, {
                                                "x": -xOffset + j * scale,
                                                "y": yOffset - i * scale,
                                                "z": 0,
                                                "shapeColor": colorVector
                                            })
                                    GlobalState.pixelMap[i][j].shape = instance
                                } else if (GlobalState.pixelMap[i][j].shape.shapeColor
                                           !== colorVector) {
                                    GlobalState.pixelMap[i][j].shape.shapeColor = colorVector
                                }
                            } else if (GlobalState.pixelMap[i][j].shape !== null) {
                                GlobalState.pixelMap[i][j].shape.destroy()
                                GlobalState.pixelMap[i][j].shape = null
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
                z: 500
            }
        }
    }
}
