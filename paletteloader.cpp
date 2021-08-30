#include "paletteloader.h"

#include <QColor>
#include <QImage>
#include <QSet>
#include <QVector>

PaletteLoader::PaletteLoader(QObject *parent) {}

PaletteLoader::~PaletteLoader() {}

void PaletteLoader::load(QUrl fileName) {
  QImage image(fileName.toLocalFile());
  QSet<QRgb> uniqueColors;
  for (int i = 0; i < image.width(); ++i) {
    for (int j = 0; j < image.height(); ++j) {
      QRgb color = image.pixel(i, j);
      uniqueColors.insert(color);
    }
  };
  emit loaded(QVector<QColor>(uniqueColors.begin(), uniqueColors.end()));
}
