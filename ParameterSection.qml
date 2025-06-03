import QtQuick 2.15

Item {
    id: root

    property var parameters: [false, false, false, false, false, false]

    signal parameterClicked(int index)

    Column {
        width: parent.width
        spacing: 8

        Text {
            text: "Parameters"
            font.pixelSize: 12
            font.bold: true
            color: "#ffffff"
        }

        Grid {
            columns: 2
            spacing: 10
            width: parent.width

            Repeater {
                model: ["A", "B", "C", "D"]
                delegate: Row {
                    spacing: 5
                    width: (parent.width - 20) / 3

                    Rectangle {
                        width: 16
                        height: 16
                        color: parameters[model.index] ?
                               "#6200ee" : "#3a3a3a"
                        border.color: "#444444"
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: parameters[model.index] ? "✓" : ""
                            font.pixelSize: 8
                            color: "#ffffff"
                        }

                        // Hover effect
                        scale: mouseArea.containsMouse ? 1.1 : 1.0
                        Behavior on scale {
                            NumberAnimation { duration: 150 }
                        }

                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: root.parameterClicked(model.index)
                        }
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
