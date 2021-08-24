pragma Singleton

import QtQuick 2.15

QtObject {
    readonly property int width: 1280
    readonly property int height: 720

    readonly property string mySystemFontName: "Arial"
//    readonly property FontLoader mySystemFont: FontLoader {
//        name: mySystemFontName
//    }

    property alias fontDirectory: directoryFontLoader.fontDirectory
    property alias relativeFontDirectory: directoryFontLoader.relativeFontDirectory

    /* Edit this comment to add your custom font */
    readonly property font font: Qt.font({
                                             "family": mySystemFontName,
                                             "pixelSize": Qt.application.font.pixelSize
                                         })
    readonly property font largeFont: Qt.font({
                                                  "family": mySystemFontName,
                                                  "pixelSize": Qt.application.font.pixelSize * 1.6
                                              })
    readonly property color backgroundColor: "#333333"
    readonly property color toolbarColor: "#222222"
    readonly property color titleColor: "#eeeeee"
    readonly property color checkerBoardBlack: Qt.rgba(0.85, 0.85, 0.85)
    readonly property color checkerBoardWhite: Qt.rgba(0.9, 0.9, 0.9)

    readonly property int canvasSize: 32 * 12
    readonly property int maxDepthValue: 8

    property variant defaultColorPalette: ["#f2f0e5", "#b8b5b9", "#868188", "#646365", "#45444f", "#3a3858", "#212123", "#352b42", "#43436a", "#4b80ca", "#68c2d3", "#a2dcc7", "#ede19e", "#d3a068", "#b45252", "#6a536e", "#4b4158", "#80493a", "#a77b5b", "#e5ceb4", "#c2d368", "#8ab060", "#567b79", "#4e584a", "#7b7243", "#b2b47e", "#edc8c4", "#cf8acb", "#5f556a"]

    property DirectoryFontLoader directoryFontLoader: DirectoryFontLoader {
        id: directoryFontLoader
    }
}
