#include "gltfexport.h"

#include <QColor>
#include <QJsonObject>
#include <algorithm>

GLTFExport::GLTFExport(QObject *) {}

GLTFExport::~GLTFExport() {}

void GLTFExport::write(const QUrl &fileName, const QJsonObject &data) {
  QString localFileName = fileName.toLocalFile();
  QJsonValue exportModel = model(data);
  if (exportModel.isNull()) return;
  if (!writeModel(exportModel.toObject(), localFileName)) {
    emit error(localFileName, "Can't write to file!");
    return;
  }
  emit exported(localFileName);
}

QJsonValue GLTFExport::model(const QJsonObject &data) {
  QString version = data.value("version").toString();
  if (version != "1.0") {
    emit error(":memory:", "Invalid version number [1.0 != " + version + "]");
    return QJsonValue();
  }

  int width = data.value("width").toInt();
  int height = data.value("height").toInt();
  if (width != height) {
    emit error(":memory:", "invalid size");
    return QJsonValue();
  }

  QJsonArray pixelMap = data.value("pixels").toArray();
  int depthAlign = data.value("align").toInt(0);
  QVector<Node> nodes;
  QVector<QString> shapes, colors;
  QVector<QPair<int, int>> meshes;

  buildUniqueVectors(pixelMap, shapes, colors, meshes, nodes);

  QJsonObject exportModel;

  insertInfo(exportModel);
  insertScene(exportModel, nodes.size());
  insertNodes(exportModel, nodes, height, depthAlign);
  insertMeshes(exportModel, meshes);
  insertMaterials(exportModel, colors);
  if (!insertShapeData(exportModel, shapes)) {
    emit error(":memory:", "Can't find or open shape files");
    return QJsonValue();
  }
  return exportModel;
}

void GLTFExport::buildUniqueVectors(const QJsonArray &pixelMap,
                                    QVector<QString> &shapes,
                                    QVector<QString> &colors,
                                    QVector<QPair<int, int>> &meshes,
                                    QVector<GLTFExport::Node> &nodes) {
  /* in this function we build unique sets of all used colors, shapes, ...
   * so we can keep track of the indices in glTF format
   */
  QMap<QString, int> uniqueShapes, uniqueColors;
  QMap<QPair<int, int>, int> uniqueMeshes;

  for (int i = 0; i < pixelMap.size(); ++i) {
    QJsonArray row = pixelMap[i].toArray();
    for (int j = 0; j < row.size(); ++j) {
      QJsonObject item = row[j].toObject();
      QJsonValue itemColor = item.take("color");
      QJsonValue itemShape = item.take("shape");
      QJsonValue itemDepth = item.take("depth");
      if (itemColor.isNull() || itemShape.isNull() || itemDepth.isNull())
        continue;
      QString color = itemColor.toString();
      QString shape = itemShape.toString();
      int depth = itemDepth.toInt();

      int shapeIdx;
      if (!uniqueShapes.contains(shape)) {
        shapeIdx = uniqueShapes.size();
        uniqueShapes.insert(shape, shapeIdx);
      } else {
        shapeIdx = uniqueShapes[shape];
      }

      int colorIdx;
      if (!uniqueColors.contains(color)) {
        colorIdx = uniqueColors.size();
        uniqueColors.insert(color, colorIdx);
      } else {
        colorIdx = uniqueColors[color];
      }

      int meshIdx;
      QPair<int, int> mesh(shapeIdx, colorIdx);
      if (!uniqueMeshes.contains(mesh)) {
        meshIdx = uniqueMeshes.size();
        uniqueMeshes.insert(mesh, meshIdx);
      } else {
        meshIdx = uniqueMeshes[mesh];
      }

      Node node{.mesh = meshIdx, .depth = depth, .row = i, .col = j};
      nodes.append(node);
    }
  }

  /* now, converting each of the sets into an ordered vector for random access
   */
  shapes.resize(uniqueShapes.size());
  for (auto shapeIter = uniqueShapes.begin(); shapeIter != uniqueShapes.end();
       ++shapeIter) {
    shapes[shapeIter.value()] = shapeIter.key();
  }

  colors.resize(uniqueColors.size());
  for (auto colorIter = uniqueColors.begin(); colorIter != uniqueColors.end();
       ++colorIter) {
    colors[colorIter.value()] = colorIter.key();
  }

  meshes.resize(uniqueMeshes.size());
  for (auto meshIter = uniqueMeshes.begin(); meshIter != uniqueMeshes.end();
       ++meshIter) {
    meshes[meshIter.value()] = meshIter.key();
  }
}

QJsonArray GLTFExport::materialsFromColors(const QVector<QString> &colors,
                                           float metallicFactor,
                                           float roughnessFactor) {
  QJsonArray materials;
  for (int i = 0; i < colors.size(); ++i) {
    QColor color(colors[i]);
    QJsonObject material{
        {"pbrMetallicRoughness",
         QJsonObject{
             {"baseColorFactor", QJsonArray{color.redF(), color.greenF(),
                                            color.blueF(), color.alphaF()}},
             {"metallicFactor", metallicFactor},
             {"roughnessFactor", roughnessFactor}}}};
    materials.append(material);
  }
  return materials;
}

void GLTFExport::insertInfo(QJsonObject &exportModel) {
  exportModel.insert("asset", QJsonObject{{"generator", "Pixel Model Maker"},
                                          {"version", "2.0"}});
}

void GLTFExport::insertScene(QJsonObject &exportModel, int numNodes) {
  /* we only have one scene and this scene have only one node
   * which is the last node in the node lists.
   * not that node list includes numNodes + 1 nodes
   */
  exportModel.insert("scene", 0);
  exportModel.insert("scenes",
                     QJsonArray{QJsonObject{{"nodes", QJsonArray{numNodes}}}});
}

void GLTFExport::insertNodes(QJsonObject &exportModel,
                             const QVector<GLTFExport::Node> &nodes, int height,
                             int depthAlign) {
  // insert all the nodes with ids related to other part of the gltf
  QJsonArray nodesDef;
  for (int i = 0; i < nodes.size(); ++i) {
    float depth = 2 * nodes[i].depth - 1;
    QJsonObject nodeDef{

        {"mesh", nodes[i].mesh},
        {"translation", QJsonArray{nodes[i].row * 2 + 1, nodes[i].col * 2 + 1,
                                   depthAlign * depth}},
        {"rotation", QJsonArray{0, 0, 0.7071068286895752, 0.7071068286895752}},
        {"scale", QJsonArray{1, 1, depth}}};
    nodesDef.append(nodeDef);
  }

  /*
   * insert one additional node for final adjustments like translation and
   * rotations all other nodes added to the children of this node, and this
   * node is the only node in the scene
   */

  QJsonArray scenesNodes;
  for (int i = 0; i < nodes.size(); ++i) scenesNodes.append(i);
  nodesDef.append(QJsonObject{
      {"children", scenesNodes},
      {"translation", QJsonArray{0, 2 * height, 0}},
      {"rotation", QJsonArray{0, 0, -0.7071068286895752, 0.7071068286895752}}});
  exportModel.insert("nodes", nodesDef);
}

void GLTFExport::insertMeshes(QJsonObject &exportModel,
                              const QVector<QPair<int, int>> meshes) {
  /* INFO: the only assumption is that every shape should have exactly
   *       3 accessors
   */

  /* WARNING: for now its only working with one shape wich is cube
   *       when you want to add other shapes you must remember to adjust
   *       bufer indices inside bufferviews and buferview indices inside
   *       accessors
   */
  QJsonArray meshesDef;
  for (int i = 0; i < meshes.size(); ++i) {
    QJsonObject meshDef{
        {"primitives",
         QJsonArray{QJsonObject{
             {"attributes", QJsonObject{{"POSITION", meshes[i].first * 3},
                                        {"NORMAL", meshes[i].first * 3 + 1}}},
             {"indices", meshes[i].first * 3 + 2},
             {"material", meshes[i].second}}}}};
    meshesDef.append(meshDef);
  }
  exportModel.insert("meshes", meshesDef);
}

void GLTFExport::insertMaterials(QJsonObject &exportModel,
                                 const QVector<QString> &colors) {
  QJsonArray materials = materialsFromColors(colors);
  exportModel.insert("materials", materials);
}

bool GLTFExport::insertShapeData(QJsonObject &exportModel,
                                 const QVector<QString> &shapes) {
  /* Note: in this function we should merge all the shape infos and
   * adjust all the refrences in accessors and buffer views
   * for now it only support one shape so we only use shape[0]
   */
  QJsonArray modelBuffers;
  QJsonArray modelBufferViews;
  QJsonArray modelAccessors;
  for (int i = 0; i < shapes.size(); ++i) {
    int bufferOffset = modelBuffers.size();
    int bufferViewOffset = modelBufferViews.size();

    QFile shapeFile(":/ui/exports/" + shapes[i] + ".gltf");
    if (!shapeFile.exists()) {
      return false;
    }
    if (!shapeFile.open(QIODevice::ReadOnly)) {
      return false;
    }

    QJsonObject shapeDef =
        QJsonDocument::fromJson(shapeFile.readAll()).object();
    QJsonArray buffers = shapeDef.take("buffers").toArray();
    std::copy(buffers.begin(), buffers.end(), std::back_inserter(modelBuffers));

    QJsonArray bufferViews = shapeDef.take("bufferViews").toArray();
    for (auto it = bufferViews.begin(); it != bufferViews.end(); ++it) {
      QJsonObject view = it->toObject();
      view["buffer"] = view["buffer"].toInt() + bufferOffset;
      modelBufferViews.append(view);
    }

    QJsonArray accessors = shapeDef.take("accessors").toArray();
    for (auto it = accessors.begin(); it != accessors.end(); ++it) {
      QJsonObject acc = it->toObject();
      acc["bufferView"] = acc["bufferView"].toInt() + bufferViewOffset;
      modelAccessors.append(acc);
    }

    shapeFile.close();
  }
  exportModel.insert("buffers", modelBuffers);
  exportModel.insert("bufferViews", modelBufferViews);
  exportModel.insert("accessors", modelAccessors);

  return true;
}

bool GLTFExport::writeModel(const QJsonObject &exportModel,
                            const QString &fileName) {
  QJsonDocument doc(exportModel);
  QByteArray exportData = doc.toJson();
  QFile exportFile(fileName);
  if (exportFile.open(QIODevice::WriteOnly)) {
    exportFile.write(exportData);
  } else {
    return false;
  }
  exportFile.close();
  return true;
}
