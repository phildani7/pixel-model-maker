#ifndef GLTFEXPORT_H
#define GLTFEXPORT_H


#include <QtCore>

class GLTFExport : public QObject {
  Q_OBJECT
  Q_DISABLE_COPY(GLTFExport)

public:
  GLTFExport(QObject *parent = 0);
  ~GLTFExport();

  Q_INVOKABLE void write(QString fileName, QJsonObject data);
signals:
  void exported(QString fileName);
  void error(QString fileName, QString error);

private:
  void buildMeshes();
  QJsonArray buildMaterials(QJsonArray &palette,  float metallicFactor=0.0f, float roughnessFactor=1.0f);
};

#endif // GLTFEXPORT_H
