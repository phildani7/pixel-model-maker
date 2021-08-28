import QtQuick 2.15
import QtQuick3D 1.15
import Qt3D.Render 2.12

Node {
    required property string name
    property vector3d shapeColor: Qt.vector3d(0.8, 0, 0)
    property int depth: 1

    Model {
        source: `qrc:/ui/shapes/meshes/${name}.mesh`
        scale: Qt.vector3d(25, 25, 25 * depth)
        materials: [
            DefaultMaterial {
                diffuseColor: Qt.rgba(shapeColor.x, shapeColor.y,
                                      shapeColor.z, 1)
            }
        ]
    }
}
