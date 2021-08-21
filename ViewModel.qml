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
        camera: perspCamera
        environment: environment

        SceneEnvironment {
            id: environment
            antialiasingMode: SceneEnvironment.SSAA
            aoSampleRate: 4
            aoStrength: 20
        }
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
                            let pixel = GlobalState.pixelMap[i][j]
                            if (pixel.color !== null) {

                                let color = pixel.color
                                let colorVector = Qt.vector3d(color.r,
                                                              color.g, color.b)

                                if (pixel.shape === null) {
                                    var cubeComponent = Qt.createComponent(
                                                "shapes/Cube.qml")

                                    let instance = cubeComponent.createObject(
                                            gridModelContainer, {
                                                "x": -xOffset + j * scale,
                                                "y": yOffset - i * scale,
                                                "z": 0,
                                                "shapeColor": colorVector,
                                                "depth": pixel.depth
                                            })
                                    pixel.shape = instance
                                } else {
                                    if (pixel.shape.shapeColor !== colorVector) {
                                        pixel.shape.shapeColor = colorVector
                                    }
                                    if (pixel.depth !== pixel.shape.depth) {
                                        pixel.shape.depth = pixel.depth
                                    }
                                }
                            } else if (GlobalState.pixelMap[i][j].shape !== null) {
                                pixel.shape.destroy()
                                pixel.shape = null
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

    MouseArea {
        id: mouseArea
        property real lastX: 0
        property real lastY: 0

        anchors.fill: parent
        acceptedButtons: Qt.AllButtons
        hoverEnabled: true

        onPositionChanged: handleDrag(mouse)
        onPressedChanged: handlePressed()

        function handlePressed() {
            if (pressedButtons === Qt.LeftButton) {
                lastX = mouseX
                lastY = mouseY
            }
        }

        function handleDrag(event) {
            if (event.buttons === Qt.LeftButton) {
                const diffX = lastX - event.x
                const diffY = lastY - event.y
                gridModelContainer.eulerRotation.y = gridModelContainer.eulerRotation.y - diffX
                gridModelContainer.eulerRotation.x = gridModelContainer.eulerRotation.x - diffY
                lastX = event.x
                lastY = event.y
            }
        }
    }

    function resetRotation() {
        gridModelContainer.eulerRotation.x = 0
        gridModelContainer.eulerRotation.y = 0
        gridModelContainer.eulerRotation.z = 0
    }
}
