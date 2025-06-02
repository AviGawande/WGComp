import QtQuick 2.15

Item {
    id: root

    property var operationStatus: [false, false, false, false]

    Grid {
        columns: 2
        spacing: 10
        width: parent.width

        Repeater {
            model: ["OP-1", "OP-2", "OP-3", "OP-4"]
            delegate: Row {
                spacing: 8
                width: (parent.width - 10) / 2

                Rectangle {
                    width: 16
                    height: 16
                    radius: 8
                    color: operationStatus[model.index] ?
                           "#6200ee" : "#3a3a3a"
                    border.color: "#444444"
                    border.width: 1

                    // Completion animation
                    ParallelAnimation {
                        id: completeAnimation
                        running: operationStatus[model.index]
                        NumberAnimation {
                            target: statusIndicator
                            property: "scale"
                            from: 1.0
                            to: 1.3
                            duration: 300
                            easing.type: Easing.OutQuad
                        }
                        NumberAnimation {
                            target: statusIndicator
                            property: "scale"
                            from: 1.3
                            to: 1.0
                            duration: 300
                            easing.type: Easing.OutQuad
                        }
                    }

                    // Reference to self for animation
                    property Rectangle statusIndicator: this

                    Text {
                        anchors.centerIn: parent
                        text: operationStatus[model.index] ? "✓" : ""
                        font.pixelSize: 8
                        color: "#ffffff"
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
