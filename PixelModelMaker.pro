QT += quick widgets svg

CONFIG += c++11

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        fileio.cpp \
        gltfexport.cpp \
        imageimport.cpp \
        libs/ed25519/src/add_scalar.c \
        libs/ed25519/src/fe.c \
        libs/ed25519/src/ge.c \
        libs/ed25519/src/key_exchange.c \
        libs/ed25519/src/keypair.c \
        libs/ed25519/src/sc.c \
        libs/ed25519/src/seed.c \
        libs/ed25519/src/sha512.c \
        libs/ed25519/src/sign.c \
        libs/ed25519/src/verify.c \
        main.cpp \
        paletteloader.cpp \
        solana.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH = ui/imports

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    fileio.h \
    gltfexport.h \
    imageimport.h \
    libs/ed25519/src/ed25519.h \
    libs/ed25519/src/fe.h \
    libs/ed25519/src/fixedint.h \
    libs/ed25519/src/ge.h \
    libs/ed25519/src/precomp_data.h \
    libs/ed25519/src/sc.h \
    libs/ed25519/src/sha512.h \
    paletteloader.h \
    solana.h

ICON = ui/images/icon.icns
RC_ICONS =  ui/images/icon.ico
