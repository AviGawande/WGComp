import QtQuick 2.15

Item {
    id: root

    property int currentStep: 0
    property bool isComplete: false

    Column {
        width: parent.width
        spacing: 5

        Text {
            text: "Main Progress"
            font.pixelSize: 12
            font.bold: true
            color: "#ffffff"
        }

        Item {
            width: parent.width
            height: 50

            // Progress line background
            Rectangle {
                width: parent.width - 60
                height: 4
                anchors.centerIn: parent
                color: "#444444"
                radius: 2
            }

            // Progress line filled
            Rectangle {
                width: (parent.width - 60) * (currentStep / 3)
                height: 4
                anchors.left: parent.left
                anchors.leftMargin: 30
                anchors.verticalCenter: parent.verticalCenter
                color: "#6200ee"
                radius: 2

                Behavior on width {
                    NumberAnimation { duration: 500; easing.type: Easing.OutCubic }
                }
            }

            // Step indicators
            Row {
                anchors.centerIn: parent
                spacing: (parent.width - 120) / 3

                Repeater {
                    model: ["A", "B", "C", "D"]
                    delegate: Rectangle {
                        width: 30
                        height: 30
                        radius: 15
                        color: currentStep > model.index ?
                               "#6200ee" : (currentStep === model.index ? "#6200ee" : "#3a3a3a")
                        border.color: "#ffffff"
                        border.width: 2

                        Text {
                            anchors.centerIn: parent
                            text: currentStep > model.index ? "✓" : modelData
                            font.pixelSize: currentStep > model.index ? 12 : 14
                            font.bold: true
                            color: "#ffffff"
                        }

                        // Pulse animation for current step
                        SequentialAnimation on scale {
                            running: currentStep === model.index && !isComplete
                            loops: Animation.Infinite
                            NumberAnimation { to: 1.1; duration: 800; easing.type: Easing.OutQuad }
                            NumberAnimation { to: 1.0; duration: 800; easing.type: Easing.OutQuad }

                            // Pause at beginning
                            PauseAnimation { duration: 400 }
                        }
                    }
                }
            }
        }
    }
}
