#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQuick>

#include "fileio.h"
#include "gltfexport.h"
#include "imageimport.h"
#include "paletteloader.h"

int main(int argc, char *argv[]) {
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
  QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

  QGuiApplication app(argc, argv);
  QStringList args = app.arguments();
  bool inputPane = args.contains("-input-pane");

  qmlRegisterType<FileIO>("com.github.zaghaghi.pixelmodelmaker", 1, 0,
                          "FileIO");
  qmlRegisterType<GLTFExport>("com.github.zaghaghi.pixelmodelmaker", 1, 0,
                              "GltfExport");
  qmlRegisterType<PaletteLoader>("com.github.zaghaghi.pixelmodelmaker", 1, 0,
                                 "PaletteLoader");
  qmlRegisterType<ImageImport>("com.github.zaghaghi.pixelmodelmaker", 1, 0,
                               "ImageImport");

  QQuickView view;
  view.setWidth(1200);
  view.setHeight(800);
  view.setResizeMode(QQuickView::SizeRootObjectToView);
  view.setTitle("Pixel Model Maker");
  view.engine()->addImportPath("qrc:/ui/imports");
  view.engine()->rootContext()->setContextProperty("InputPane", inputPane);
  view.setSource(QUrl("qrc:/ui/PixelModelMaker.qml"));
  if (!view.errors().isEmpty()) {
    qDebug() << view.errors();
    return -1;
  }
  view.show();

  return app.exec();
}
