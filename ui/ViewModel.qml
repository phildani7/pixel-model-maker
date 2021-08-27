import QtQuick 2.15
import QtQuick3D 1.15
import QtQuick3D.Helpers 1.15
import PixelModelMaker 1.0

Item {
    id: root
    property alias sceneView: sceneView
    property alias gridModelContainer: gridModelContainer
    width: 300
    height: 300

    View3D {
        id: sceneView
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

                function createShape(row, col, parent) {
                    const scale = 50
                    const xOffset = GlobalState.gridWidth / 2 * scale
                    const yOffset = GlobalState.gridHeight / 2 * scale
                    let pixel = GlobalState.pixelMap[row][col]
                    let color = pixel.color
                    let colorVector = Qt.vector3d(color.r, color.g, color.b)

                    return ShapeCollection.shapes[pixel.shapeName].create(
                                parent, -xOffset + col * scale,
                                yOffset - row * scale, colorVector, pixel.depth)
                }

                function updateShape(row, col) {
                    let pixel = GlobalState.pixelMap[row][col]
                    let color = pixel.color
                    let colorVector = Qt.vector3d(color.r, color.g, color.b)

                    if (pixel.shape === null) {
                        pixel.shape = createShape(row, col, gridModelContainer)
                    } else {
                        if (pixel.shape.shapeColor !== colorVector) {
                            pixel.shape.shapeColor = colorVector
                        }
                        if (pixel.depth !== pixel.shape.depth) {
                            pixel.shape.depth = pixel.depth
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

            PointLight {
                id: mainLight
                x: 0
                y: 0
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
