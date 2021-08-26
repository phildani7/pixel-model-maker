#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQuick>
#include "fileio.h"
#include "gltfexport.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);


    qmlRegisterType<FileIO>("com.github.zaghaghi.pixelmodelmaker", 1, 0, "FileIO");
    qmlRegisterType<GLTFExport>("com.github.zaghaghi.pixelmodelmaker", 1, 0, "GltfExport");
    QQuickView view;
    view.setTitle("Pixel Model Maker");
    view.engine()->addImportPath("qrc:/ui/imports");
    view.setSource(QUrl("qrc:/ui/PixelModelMaker.qml"));
    if (!view.errors().isEmpty()) {
        qDebug() << view.errors();
       return -1;
    }
    view.show();


    return app.exec();
}
