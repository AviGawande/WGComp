import QtQuick 2.15

Item {
    id: root

    property var parameters: [false, false, false, false, false, false]

    signal parameterClicked(int index)

    Column {
        width: parent.width
        spacing: 8

        Text {
            text: "ANAMOLIES"
            font.pixelSize: 12
            font.bold: true
            color: "#ffffff"
        }

        Grid {
            columns: 3
            spacing: 10
            width: parent.width

            Repeater {
                model: ["Warning", "Temperature", "Depth", "Damage","Course","Launch Domain"]
                delegate: Row {
                    spacing: 5
                    width: (parent.width - 20) / 3

                    Rectangle {
                        width: 16
                        height: 16
                        color: parameters[model.index] ?
                               "red" : "#42BE65"
                        border.color: "#444444"
                        border.width: 1
                    }

                    Text {
                        text: modelData
                        font.pixelSize: 12
                        color: "#aaaaaa"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }
    }
}
