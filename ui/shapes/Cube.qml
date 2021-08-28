import QtQuick 2.15
import QtQuick3D 1.15
import Qt3D.Render 2.12

Node {
    id: cubeNode

    readonly property string name: "cube"
    property vector3d shapeColor: Qt.vector3d(0.8, 0, 0)
    property int depth: 1

    Model {
        id: cube
        source: "qrc:/ui/shapes/meshes/cube.mesh"
        scale: Qt.vector3d(25, 25, 25 * (2 * depth - 1))
        materials: [
            DefaultMaterial {
                diffuseColor: Qt.rgba(shapeColor.x, shapeColor.y,
                                      shapeColor.z, 1)
            }
        ]
    }
}
