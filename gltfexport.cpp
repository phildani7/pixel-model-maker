#include "gltfexport.h"
#include <QJsonObject>
#include <QColor>

GLTFExport::GLTFExport(QObject *parent)
{

}

GLTFExport::~GLTFExport()
{

}

void GLTFExport::write(QString fileName, QJsonObject data)
{
    int width = data.take("width").toInt();
    int height = data.take("height").toInt();
    QJsonArray palette = data.take("palette").toArray();
    buildMaterials(palette);
    emit exported(fileName);
}

void GLTFExport::buildMeshes()
{

}

QJsonArray GLTFExport::buildMaterials(QJsonArray &palette, float metallicFactor, float roughnessFactor)
{
    QJsonArray materials;
    for(int i=0; i<palette.size(); ++i) {
        QColor color(palette[i].toString());
        QJsonObject material
        {{
            "pbrMetallicRoughness", QJsonObject {
                {"baseColorFactor", QJsonArray {color.redF(), color.greenF(), color.blueF(), color.alphaF()}},
                {"metallicFactor", metallicFactor},
                {"roughnessFactor", roughnessFactor}
            }
        }};
        materials.append(material);
    }
    return materials;
}
