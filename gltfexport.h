#ifndef GLTFEXPORT_H
#define GLTFEXPORT_H

#include <QtCore>

class GLTFExport : public QObject {
  Q_OBJECT
  Q_DISABLE_COPY(GLTFExport)

 public:
  GLTFExport(QObject *parent = 0);
  ~GLTFExport();

  Q_INVOKABLE void write(QUrl fileName, QJsonObject data);

 signals:
  void exported(QString fileName);
  void error(QString fileName, QString error);

 private:
  struct Node {
    int mesh;
    int depth;
    int row;
    int col;
  };

  void buildUniqueVectors(const QJsonArray &pixelMap, QVector<QString> &shapes,
                          QVector<QString> &colors,
                          QVector<QPair<int, int>> &meshes,
                          QVector<Node> &nodes);
  QJsonArray materialsFromColors(const QVector<QString> &colors,
                                 float metallicFactor = 0.0f,
                                 float roughnessFactor = 1.0f);
  void insertInfo(QJsonObject &exportModel);
  void insertScene(QJsonObject &exportModel, int numNodes);
  void insertNodes(QJsonObject &exportModel,
                   const QVector<GLTFExport::Node> &nodes, int height,
                   int depthAlign);
  void insertMeshes(QJsonObject &exportModel,
                    const QVector<QPair<int, int>> meshes);
  void insertMaterials(QJsonObject &exportModel,
                       const QVector<QString> &colors);
  bool insertShapeData(QJsonObject &exportModel,
                       const QVector<QString> &shapes);
  bool writeModel(const QJsonObject &exportModel, const QString &fileName);
};

#endif  // GLTFEXPORT_H
