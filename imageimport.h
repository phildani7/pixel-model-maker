#ifndef IMAGEIMPORT_H
#define IMAGEIMPORT_H

#include <QColor>
#include <QObject>
#include <QUrl>
#include <QVector>

class ImageImport : public QObject {
  Q_OBJECT
  Q_DISABLE_COPY(ImageImport)

 public:
  explicit ImageImport(QObject *parent = nullptr);
  ~ImageImport();

  Q_INVOKABLE void load(QUrl fileName);
 signals:
  void loaded(int width, int height, QVector<QVector<QColor>> pixels,
              QVector<QColor> palette);
  void error(QString error);
};

#endif  // IMAGEIMPORT_H
