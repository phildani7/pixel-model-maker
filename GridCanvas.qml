import QtQuick 2.15

Item {
    property int gridWidth: 4
    property int gridHeight: 4
    property color selectedColor: Qt.rgba(1, 0, 0)
    property variant colorMap: null

    width: 32 * 12
    height: 32 * 12

    Canvas {
        id: canvas
        width: parent.width
        height: parent.height

        onPaint: {
            var ctx = getContext("2d")
            const black = Qt.rgba(0.4, 0.4, 0.4)
            const white = Qt.rgba(0.8, 0.8, 0.8)
            const cellSize = width / gridWidth
            for (var i = 0; i < gridHeight; ++i) {
                for (var j = 0; j < gridWidth; ++j) {
                    if (colorMap && colorMap[j][i] && colorMap[j][i].color) {
                        ctx.fillStyle = colorMap[j][i].color
                    }
                    else {
                        ctx.fillStyle = (i+j)%2 ? black : white
                    }
                    ctx.fillRect(i * cellSize, j * cellSize, cellSize, cellSize)
                }
            }

        }
    }

    MouseArea {
        width: parent.width
        height: parent.height
        acceptedButtons: Qt.AllButtons
        hoverEnabled: true

        onClicked: parent.handleClick(mouse)
        onPositionChanged: parent.handleDrag(mouse)
    }



    onGridHeightChanged: {
        repaint()
    }

    onGridWidthChanged: {
        repaint()
    }

    function repaint() {
        colorMap = []
        for (var i = 0; i < gridHeight; ++i) {
            let colorRow = []
            for (var j = 0; j < gridWidth; ++j) {
                colorRow.push({
                     color: null
                })
            }
            colorMap.push(colorRow)
        }
        canvas.requestPaint()
    }

    function handleClick(mouse) {
        const cellSize = width / gridWidth
        const col = parseInt(mouse.x / cellSize)
        const row = parseInt(mouse.y / cellSize)
        if (mouse.button === Qt.LeftButton) {
            colorMap[row][col].color = selectedColor
        }
        else {
            colorMap[row][col].color = null
        }
        canvas.requestPaint()
    }

    function handleDrag(mouse) {
        const cellSize = width / gridWidth
        const col = parseInt(mouse.x / cellSize)
        const row = parseInt(mouse.y / cellSize)
        if (mouse.buttons === Qt.LeftButton && colorMap[row][col].color === null) {
            colorMap[row][col].color = selectedColor
            canvas.requestPaint()
        }
        else if (mouse.buttons === Qt.RightButton && colorMap[row][col] !== null) {
            colorMap[row][col].color = null
            canvas.requestPaint()
        }

    }
}
