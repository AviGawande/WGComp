import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: root
    height: isOpen ? (37 + 500) : 37

    // Properties
    property int machineIndex: 0
    property bool isOpen: false
    property string machineName: "Machine"
    property string currentStepName: "A"
    property int completedSubSteps: 0
    property bool isComplete: false
    property bool isAutoRunning: false
    property int currentMainStep: 0
    property var subStepsCompleted: [false, false, false, false, false]
    property var operationStatus: [false, false, false, false]
    property var parameters: [false, false, false, false, false, false]

    // Signals
    signal toggleOpen()
    signal advanceNext()
    signal goBack()
    signal reset()
    signal toggleAuto()
    signal subStepToggled(int subIndex)
    signal parameterToggled(int paramIndex)

    // Auto progress timer
    Timer {
        id: autoProgressTimer
        interval: 3000 // 3 seconds
        repeat: true
        running: isAutoRunning && !isComplete
        onTriggered: {
            advanceNext()
        }
    }

    // Smooth height transition
    Behavior on height {
        NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
    }

    Rectangle {
        id: machineTab
        width: parent.width
        height: 37
        color: isOpen ? "#2a2a2a" : "#1e1e1e"
        border.color: "#444444"
        border.width: 1
        radius: 3

        Row {
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            spacing: 10

            Text {
                text: machineName
                font.pixelSize: 14
                font.bold: true
                color: "#ffffff"
            }

            // Progress indicator in tab
            Text {
                text: "(" + currentStepName + " - " + completedSubSteps + "/5)"
                font.pixelSize: 10
                color: "#aaaaaa"
            }

            // Auto progress indicator
            Rectangle {
                visible: isAutoRunning
                width: 8
                height: 8
                radius: 4
                color: "#4CAF50"
                anchors.verticalCenter: parent.verticalCenter

                // Pulsing animation
                SequentialAnimation on opacity {
                    running: isAutoRunning
                    loops: Animation.Infinite
                    NumberAnimation { to: 0.3; duration: 800 }
                    NumberAnimation { to: 1.0; duration: 800 }
                }
            }
        }

        // Dropdown arrow
        Text {
            anchors.right: parent.right
            anchors.rightMargin: 15
            anchors.verticalCenter: parent.verticalCenter
            text: "˅"
            font.pixelSize: 12
            color: "#ffffff"
            rotation: isOpen ? 180 : 0
            Behavior on rotation {
                NumberAnimation { duration: 300 }
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: toggleOpen()
        }
    }

    // Dropdown content
    Rectangle {
        id: dropdownContent
        width: parent.width
        height: 500
        y: 37
        color: "#2a2a2a"
        border.color: "#444444"
        border.width: 1
        radius: 3
        visible: isOpen
        opacity: isOpen ? 1 : 0
        clip: true

        Behavior on opacity {
            NumberAnimation { duration: 300 }
        }

        Column {
            anchors.fill: parent
            anchors.margins: 15
            spacing: 15

            // Name section
            Row {
                width: parent.width
                spacing: 10
                Text {
                    text: "Name:"
                    font.pixelSize: 12
                    color: "#ffffff"
                    anchors.verticalCenter: parent.verticalCenter
                }
                Rectangle {
                    width: 120
                    height: 24
                    border.color: "#444444"
                    border.width: 1
                    color: "#3a3a3a"
                    radius: 2

                    TextInput {
                        anchors.fill: parent
                        anchors.margins: 3
                        font.pixelSize: 12
                        color: "#ffffff"
                        verticalAlignment: TextInput.AlignVCenter
                        text: machineName
                        selectByMouse: true
                    }
                }
            }

            // Image section
            Rectangle {
                width: parent.width
                height: 100
                border.color: "#444444"
                border.width: 1
                color: "#3a3a3a"
                radius: 2

                Column {
                    anchors.centerIn: parent
                    spacing: 5

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "Image"
                        font.pixelSize: 16
                        color: "#888888"
                    }

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "Step: " + currentStepName
                        font.pixelSize: 12
                        color: "#6200ee"
                        font.bold: true
                    }
                }
            }

            // Main Progress Bar
            MainProgressBar {
                width: parent.width
                height: 80
                currentStep: currentMainStep
                isComplete: root.isComplete
            }

            // Current Step Info
            Rectangle {
                width: parent.width
                height: 40
                color: "#3a3a3a"
                border.color: "#444444"
                border.width: 1
                radius: 3

                Row {
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 15

                    Text {
                        text: "Current Step: " + currentStepName
                        font.pixelSize: 12
                        font.bold: true
                        color: "#6200ee"
                    }

                    Text {
                        text: "Sub-Progress: " + completedSubSteps + "/5"
                        font.pixelSize: 12
                        color: "#ffffff"
                    }

                    // Auto progress indicator
                    Row {
                        visible: isAutoRunning
                        spacing: 5
                        anchors.verticalCenter: parent.verticalCenter

                        Rectangle {
                            width: 8
                            height: 8
                            radius: 4
                            color: "#4CAF50"

                            // Pulsing animation
                            SequentialAnimation on opacity {
                                running: isAutoRunning
                                loops: Animation.Infinite
                                NumberAnimation { to: 0.3; duration: 800 }
                                NumberAnimation { to: 1.0; duration: 800 }
                            }
                        }

                        Text {
                            text: "Auto"
                            font.pixelSize: 10
                            color: "#4CAF50"
                        }
                    }
                }
            }

            // Sub-Progress Indicators
            SubProgressBar {
                width: parent.width
                height: 80
                subStepsCompleted: root.subStepsCompleted
                onSubStepClicked: {
                    if (!isComplete && !isAutoRunning) {
                        subStepToggled(index)
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: "#444444"
            }

            // Operation Status
            OperationStatus {
                width: parent.width
                height: 50
                operationStatus: root.operationStatus
            }

            Rectangle {
                width: parent.width
                height: 1
                color: "#444444"
            }

            // Parameters section
            ParameterSection {
                width: parent.width
                height: 80
                parameters: root.parameters
                onParameterClicked: {
                    parameterToggled(index)
                }
            }

            // Control buttons
            Row {
                spacing: 10
                anchors.horizontalCenter: parent.horizontalCenter

                Rectangle {
                    width: 60
                    height: 30
                    color: "#ffffff"
                    radius: 4
                    opacity: completedSubSteps > 0 ? 1.0 : 0.5

                    Text {
                        anchors.centerIn: parent
                        text: "Back"
                        font.pixelSize: 12
                        color: "#6200ee"
                    }

                    MouseArea {
                        anchors.fill: parent
                        enabled: completedSubSteps > 0 || currentMainStep > 0
                        onClicked: goBack()
                    }
                }

                Rectangle {
                    width: 60
                    height: 30
                    color: isComplete ? "#4CAF50" : "#6200ee"
                    radius: 4

                    Text {
                        anchors.centerIn: parent
                        text: isComplete ? "Done" : "Next"
                        font.pixelSize: 12
                        color: "#ffffff"
                    }

                    MouseArea {
                        anchors.fill: parent
                        enabled: !isComplete
                        onClicked: advanceNext()
                    }
                }

                Rectangle {
                    width: 60
                    height: 30
                    color: isAutoRunning ? "#FF9800" : "#03A9F4"
                    radius: 4

                    Text {
                        anchors.centerIn: parent
                        text: isAutoRunning ? "Stop" : "Auto"
                        font.pixelSize: 12
                        color: "#ffffff"
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: toggleAuto()
                    }
                }

                Rectangle {
                    width: 60
                    height: 30
                    color: "#f44336"
                    radius: 4

                    Text {
                        anchors.centerIn: parent
                        text: "Reset"
                        font.pixelSize: 12
                        color: "#ffffff"
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: reset()
                    }
                }
            }
        }
    }
}
