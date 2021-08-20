import QtQuick 2.15
import QtQuick3D 1.15
import QtQuick3D.Materials 1.15

Node {
    id: cubeNode

    property vector3d shapeColor: Qt.vector3d(0.8, 0, 0)
    property real rotX: 0
    property real rotY: 0
    property real rotZ: 0
    Model {
        id: cubeModel
        source: "#Cube"
        scale: Qt.vector3d(0.5, 0.5, 0.5)
        eulerRotation.z: rotX
        eulerRotation.y: rotY
        eulerRotation.x: rotZ
        materials: [
            DefaultMaterial {
                diffuseColor: Qt.rgba(shapeColor.x, shapeColor.y,
                                      shapeColor.z, 1)
            }
        ]
    }
}
