#ifndef PALETTELOADER_H
#define PALETTELOADER_H

#include <QColor>
#include <QVector>
#include <QtCore>

class PaletteLoader : public QObject {
  Q_OBJECT
  Q_DISABLE_COPY(PaletteLoader)
 public:
  PaletteLoader(QObject *parent = 0);
  ~PaletteLoader();

  Q_INVOKABLE void load(QUrl fileName);

 signals:
  void loaded(QVector<QColor> colors);
};

#endif  // PALETTELOADER_H
