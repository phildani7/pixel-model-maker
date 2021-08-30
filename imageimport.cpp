#include "imageimport.h"

#include <QColor>
#include <QImage>
#include <QSet>
#include <QUrl>
#include <QVector>

ImageImport::ImageImport(QObject *parent) : QObject(parent) {}

ImageImport::~ImageImport() {}

void ImageImport::load(QUrl fileName) {
  const QImage image(fileName.toLocalFile());

  QVector<int> validSizes{16, 24, 32};
  int size = std::max(image.width(), image.height());
  int selectedSize = 32;
  for (auto validSize : validSizes) {
    if (size <= validSize) {
      selectedSize = validSize;
      break;
    }
  }
  QVector<QVector<QColor>> pixels;
  QSet<QRgb> palette;

  for (int j = 0; j < std::min(selectedSize, image.height()); ++j) {
    QVector<QColor> row;
    for (int i = 0; i < std::min(selectedSize, image.width()); ++i) {
      QRgb color = image.pixel(i, j);
      if (qAlpha(color) > 0) {
        palette.insert(color);
      }
      row.append(color);
    }
    pixels.append(row);
  }

  emit loaded(selectedSize, selectedSize, pixels,
              QVector<QColor>(palette.begin(), palette.end()));
}
