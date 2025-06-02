import QtQuick 2.15

Item {
    id: root

    property var subStepsCompleted: [false, false, false, false, false]

    signal subStepClicked(int index)

    Column {
        width: parent.width
        spacing: 8

        Text {
            text: "Sub-Progress (P1 - P5)"
            font.pixelSize: 12
            font.bold: true
            color: "#ffffff"
        }

        // P1-P5 labels
        Row {
            width: parent.width
            spacing: (parent.width - 100) / 4

            Repeater {
                model: ["P1", "P2", "P3", "P4", "P5"]
                delegate: Text {
                    text: modelData
                    font.pixelSize: 10
                    color: "#aaaaaa"
                    width: 20
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }

        // Progress circles with connecting lines
        Item {
            width: parent.width
            height: 30

            // Connecting lines
            Row {
                anchors.centerIn: parent
                spacing: (parent.width - 100) / 4

                Repeater {
                    model: 4 // 4 lines between 5 circles
                    delegate: Item {
                        width: 20
                        height: 30

                        Rectangle {
                            width: (parent.parent.width - 100) / 4
                            height: 2
                            anchors.centerIn: parent
                            color: subStepsCompleted[model.index] &&
                                   subStepsCompleted[model.index + 1] ?
                                   "#6200ee" : "#555555"

                            Behavior on color {
                                ColorAnimation { duration: 300 }
                            }
                        }
                    }
                }
            }

            // Progress circles
            Row {
                anchors.centerIn: parent
                spacing: (parent.width - 100) / 4

                Repeater {
                    model: 5
                    delegate: Rectangle {
                        width: 20
                        height: 20
                        radius: 10
                        color: subStepsCompleted[model.index] ?
                               "#6200ee" : "#3a3a3a"
                        border.color: "#ffffff"
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: subStepsCompleted[model.index] ? "✓" : (model.index + 1)
                            font.pixelSize: subStepsCompleted[model.index] ? 8 : 10
                            color: "#ffffff"
                            font.bold: true
                        }

                        // Hover effect
                        scale: mouseArea.containsMouse ? 1.1 : 1.0
                        Behavior on scale {
                            NumberAnimation { duration: 150 }
                        }

                        // Completion animation
                        ParallelAnimation {
                            id: completeAnimation
                            NumberAnimation {
                                target: circleDelegate
                                property: "scale"
                                from: 1.0
                                to: 1.3
                                duration: 200
                                easing.type: Easing.OutQuad
                            }
                            NumberAnimation {
                                target: circleDelegate
                                property: "scale"
                                from: 1.3
                                to: 1.0
                                duration: 200
                                easing.type: Easing.OutQuad
                            }
                        }

                        // Reference to self for animation
                        property Rectangle circleDelegate: this

                        // Run animation when completed
                        onColorChanged: {
                            if (color.toString() === "#6200ee") {
                                completeAnimation.start()
                            }
                        }

                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: root.subStepClicked(model.index)
                        }
                    }
                }
            }
        }
    }
}
