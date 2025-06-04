// import QtQuick 2.15

// Item {
//     id: root

//     property var subStepsCompleted: [false, false, false, false, false]
//     property bool isAutoRunning: false

//     signal subStepClicked(int index)

//     // Function to get next incomplete step for glow effect
//     function getNextIncompleteStep() {
//         for (var i = 0; i < subStepsCompleted.length; i++) {
//             if (!subStepsCompleted[i]) {
//                 return i;
//             }
//         }
//         return -1; // All completed
//     }

//     // Function to determine line state
//     function getLineState(lineIndex) {
//         // lineIndex represents the line between step[lineIndex] and step[lineIndex + 1]
//         var currentStep = subStepsCompleted[lineIndex];
//         var nextStep = subStepsCompleted[lineIndex + 1];

//         if (currentStep && nextStep) {
//             return "solid"; // Both steps completed - solid line
//         } else {
//             return "dotted"; // All other cases - dotted line
//         }
//     }

//     Column {
//         width: parent.width
//         spacing: 8

//         // P1-P5 labels with enhanced glow effect
//         Row {
//             width: parent.width
//             spacing: (parent.width - 100) / 4

//             Repeater {
//                 model: ["P1", "P2", "P3", "P4", "P5"]
//                 delegate: Item {
//                     width: 20
//                     height: 15

//                     // Glow background for label - active when this is the next step OR when auto-running
//                     Rectangle {
//                         width: parent.width + 6
//                         height: parent.height + 4
//                         radius: 3
//                         anchors.centerIn: parent
//                         color: "#6200ee"
//                         opacity: (isAutoRunning && getNextIncompleteStep() === model.index) ||
//                                  (!isAutoRunning && getNextIncompleteStep() === model.index) ? 0.4 : 0

//                         Behavior on opacity {
//                             NumberAnimation { duration: 300 }
//                         }

//                         // Pulsing animation for glow background
//                         SequentialAnimation on opacity {
//                             running: (isAutoRunning && getNextIncompleteStep() === model.index) ||
//                                      (!isAutoRunning && getNextIncompleteStep() === model.index)
//                             loops: Animation.Infinite
//                             NumberAnimation { to: 0.2; duration: 800 }
//                             NumberAnimation { to: 0.6; duration: 800 }
//                         }
//                     }

//                     Text {
//                         anchors.centerIn: parent
//                         text: modelData
//                         font.pixelSize: 10
//                         color: (isAutoRunning && getNextIncompleteStep() === model.index) ||
//                                (!isAutoRunning && getNextIncompleteStep() === model.index) ? "#6200ee" : "#aaaaaa"
//                         font.bold: (isAutoRunning && getNextIncompleteStep() === model.index) ||
//                                    (!isAutoRunning && getNextIncompleteStep() === model.index)
//                         horizontalAlignment: Text.AlignHCenter

//                         // Pulsing animation for text
//                         SequentialAnimation on opacity {
//                             running: (isAutoRunning && getNextIncompleteStep() === model.index) ||
//                                      (!isAutoRunning && getNextIncompleteStep() === model.index)
//                             loops: Animation.Infinite
//                             NumberAnimation { to: 0.6; duration: 800 }
//                             NumberAnimation { to: 1.0; duration: 800 }
//                         }

//                         // Color transition
//                         Behavior on color {
//                             ColorAnimation { duration: 300 }
//                         }
//                     }
//                 }
//             }
//         }

//         // Progress circles with connecting lines
//         Item {
//             width: parent.width
//             height: 30

//             // Connecting lines
//             Row {
//                 anchors.centerIn: parent
//                 spacing: (parent.width - 100) / 4

//                 Repeater {
//                     model: 4 // 4 lines between 5 circles
//                     delegate: Item {
//                         width: 20
//                         height: 30

//                         property string lineState: getLineState(model.index)
//                         property real lineWidth: (parent.parent.width - 100) / 4

//                         // Solid line (for completed connections)
//                         Rectangle {
//                             width: lineWidth
//                             height: 2
//                             anchors.centerIn: parent
//                             color: "#6200ee"
//                             visible: lineState === "solid"

//                             Behavior on color {
//                                 ColorAnimation { duration: 300 }
//                             }
//                         }

//                         // Dotted line (for all other states)
//                         Row {
//                             anchors.centerIn: parent
//                             spacing: 2
//                             visible: lineState === "dotted"

//                             Repeater {
//                                 model: Math.floor(parent.parent.lineWidth / 6) // Number of dashes
//                                 delegate: Rectangle {
//                                     width: 4
//                                     height: 2
//                                     color: (isAutoRunning && getNextIncompleteStep() === (parent.parent.parent.model.index + 1)) ?
//                                            "#6200ee" : "#555555"

//                                     // Animated dashes when auto-running and this is the active line
//                                     SequentialAnimation on opacity {
//                                         running: isAutoRunning &&
//                                                 getNextIncompleteStep() === (parent.parent.parent.model.index + 1)
//                                         loops: Animation.Infinite
//                                         NumberAnimation {
//                                             to: 0.3
//                                             duration: 300 + (model.index * 100) // Staggered animation
//                                         }
//                                         NumberAnimation {
//                                             to: 1.0
//                                             duration: 300 + (model.index * 100)
//                                         }
//                                     }

//                                     // Color transition
//                                     Behavior on color {
//                                         ColorAnimation { duration: 300 }
//                                     }
//                                 }
//                             }
//                         }
//                     }
//                 }
//             }

//             // Progress circles with enhanced glow effect
//             Row {
//                 anchors.centerIn: parent
//                 spacing: (parent.width - 100) / 4

//                 Repeater {
//                     model: 5
//                     delegate: Item {
//                         width: 20
//                         height: 20

//                         // Outer glow ring for next step (both auto-running and manual)
//                         Rectangle {
//                             width: parent.width + 12
//                             height: parent.height + 12
//                             radius: (parent.width + 12) / 2
//                             anchors.centerIn: parent
//                             color: "transparent"
//                             border.color: "#6200ee"
//                             border.width: 2
//                             opacity: (isAutoRunning && getNextIncompleteStep() === model.index) ||
//                                      (!isAutoRunning && getNextIncompleteStep() === model.index) ? 0.6 : 0

//                             Behavior on opacity {
//                                 NumberAnimation { duration: 300 }
//                             }

//                             // Pulsing animation for outer ring
//                             SequentialAnimation on scale {
//                                 running: (isAutoRunning && getNextIncompleteStep() === model.index) ||
//                                          (!isAutoRunning && getNextIncompleteStep() === model.index)
//                                 loops: Animation.Infinite
//                                 NumberAnimation { to: 1.2; duration: 800; easing.type: Easing.OutQuad }
//                                 NumberAnimation { to: 1.0; duration: 800; easing.type: Easing.OutQuad }
//                             }
//                         }

//                         // Middle glow effect for next step (both auto-running and manual)
//                         Rectangle {
//                             width: parent.width + 8
//                             height: parent.height + 8
//                             radius: (parent.width + 8) / 2
//                             anchors.centerIn: parent
//                             color: "#6200ee"
//                             opacity: (isAutoRunning && getNextIncompleteStep() === model.index) ||
//                                      (!isAutoRunning && getNextIncompleteStep() === model.index) ? 0.3 : 0

//                             Behavior on opacity {
//                                 NumberAnimation { duration: 300 }
//                             }

//                             // Pulsing animation for middle glow
//                             SequentialAnimation on opacity {
//                                 running: (isAutoRunning && getNextIncompleteStep() === model.index) ||
//                                          (!isAutoRunning && getNextIncompleteStep() === model.index)
//                                 loops: Animation.Infinite
//                                 NumberAnimation { to: 0.1; duration: 800 }
//                                 NumberAnimation { to: 0.5; duration: 800 }
//                             }
//                         }

//                         // Main circle
//                         Rectangle {
//                             width: 20
//                             height: 20
//                             radius: 10
//                             anchors.centerIn: parent
//                             color: subStepsCompleted[model.index] ?
//                                    "#6200ee" : "#3a3a3a"
//                             border.color: (isAutoRunning && getNextIncompleteStep() === model.index) ||
//                                           (!isAutoRunning && getNextIncompleteStep() === model.index) ? "#6200ee" : "#ffffff"
//                             border.width: (isAutoRunning && getNextIncompleteStep() === model.index) ||
//                                           (!isAutoRunning && getNextIncompleteStep() === model.index) ? 3 : 1

//                             // Pulsing animation for next step
//                             SequentialAnimation on scale {
//                                 running: (isAutoRunning && getNextIncompleteStep() === model.index) ||
//                                          (!isAutoRunning && getNextIncompleteStep() === model.index)
//                                 loops: Animation.Infinite
//                                 NumberAnimation { to: 1.15; duration: 800; easing.type: Easing.OutQuad }
//                                 NumberAnimation { to: 1.0; duration: 800; easing.type: Easing.OutQuad }
//                             }

//                             // Small inner circle instead of numbers
//                             Rectangle {
//                                 width: 8
//                                 height: 8
//                                 radius: 4
//                                 anchors.centerIn: parent
//                                 color: subStepsCompleted[model.index] ? "#ffffff" : "#666666"

//                                 // Glow effect for inner circle when active
//                                 border.color: (isAutoRunning && getNextIncompleteStep() === model.index) ||
//                                               (!isAutoRunning && getNextIncompleteStep() === model.index) ? "#ffffff" : "transparent"
//                                 border.width: (isAutoRunning && getNextIncompleteStep() === model.index) ||
//                                               (!isAutoRunning && getNextIncompleteStep() === model.index) ? 1 : 0

//                                 Behavior on color {
//                                     ColorAnimation { duration: 200 }
//                                 }

//                                 Behavior on border.color {
//                                     ColorAnimation { duration: 300 }
//                                 }
//                             }

//                             // Hover effect (only when not auto running)
//                             scale: !isAutoRunning && mouseArea.containsMouse ? 1.1 :
//                                    ((isAutoRunning && getNextIncompleteStep() === model.index) ||
//                                     (!isAutoRunning && getNextIncompleteStep() === model.index) ? scale : 1.0)
//                             Behavior on scale {
//                                 NumberAnimation { duration: 150 }
//                             }

//                             // Border color transition
//                             Behavior on border.color {
//                                 ColorAnimation { duration: 300 }
//                             }

//                             // Border width transition
//                             Behavior on border.width {
//                                 NumberAnimation { duration: 300 }
//                             }

//                             MouseArea {
//                                 id: mouseArea
//                                 anchors.fill: parent
//                                 hoverEnabled: !isAutoRunning
//                                 onClicked: root.subStepClicked(model.index)
//                             }
//                         }
//                     }
//                 }
//             }
//         }
//     }
// }

import QtQuick 2.15

Item {
    id: root

    property var subStepsCompleted: [false, false, false, false, false]
    property int maxSubSteps: 4 // Dynamic based on current main step
    property bool isAutoRunning: false

    signal subStepClicked(int index)

    // Function to get next incomplete step
    function getNextIncompleteStep() {
        for (var i = 0; i < maxSubSteps; i++) {
            if (!subStepsCompleted[i]) {
                return i;
            }
        }
        return -1; // All completed
    }

    // Function to determine line state
    function getLineState(lineIndex) {
        // Only show lines that are within the current step's range
        if (lineIndex >= maxSubSteps - 1) return "hidden";

        var currentStep = subStepsCompleted[lineIndex];
        var nextStep = subStepsCompleted[lineIndex + 1];

        if (currentStep && nextStep) {
            return "solid"; // Both steps completed - solid line
        } else {
            return "dotted"; // All other cases - dotted line
        }
    }

    // Generate dynamic labels based on maxSubSteps
    function getStepLabels() {
        var labels = [];
        for (var i = 1; i <= maxSubSteps; i++) {
            labels.push("P" + i);
        }
        return labels;
    }

    Column {
        width: parent.width
        spacing: 8

        // Dynamic labels based on maxSubSteps
        Row {
            width: parent.width
            spacing: maxSubSteps > 1 ? (parent.width - (maxSubSteps * 20)) / (maxSubSteps - 1) : 0

            Repeater {
                model: getStepLabels()
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

            // Connecting lines (only show lines between existing steps)
            Row {
                anchors.centerIn: parent
                spacing: maxSubSteps > 1 ? (parent.width - (maxSubSteps * 20)) / (maxSubSteps - 1) : 0

                Repeater {
                    model: Math.max(0, maxSubSteps - 1) // Lines between circles
                    delegate: Item {
                        width: 20
                        height: 30

                        property string lineState: getLineState(model.index)
                        property real lineWidth: maxSubSteps > 1 ? (parent.parent.width - (maxSubSteps * 20)) / (maxSubSteps - 1) : 0

                        // Solid line (for completed connections)
                        Rectangle {
                            width: lineWidth
                            height: 2
                            anchors.centerIn: parent
                            color: "#6200ee"
                            visible: lineState === "solid"

                            Behavior on color {
                                ColorAnimation { duration: 300 }
                            }
                        }

                        // Dotted line (for all other states)
                        Row {
                            anchors.centerIn: parent
                            spacing: 2
                            visible: lineState === "dotted"

                            Repeater {
                                model: Math.floor(parent.parent.lineWidth / 6) // Number of dashes
                                delegate: Rectangle {
                                    width: 4
                                    height: 2
                                    color: (isAutoRunning && getNextIncompleteStep() === (parent.parent.parent.model.index + 1)) ?
                                           "#6200ee" : "#555555"

                                    // Animated dashes when auto-running and this is the active line
                                    SequentialAnimation on opacity {
                                        running: isAutoRunning &&
                                                getNextIncompleteStep() === (parent.parent.parent.model.index + 1)
                                        loops: Animation.Infinite
                                        NumberAnimation {
                                            to: 0.3
                                            duration: 300 + (model.index * 100) // Staggered animation
                                        }
                                        NumberAnimation {
                                            to: 1.0
                                            duration: 300 + (model.index * 100)
                                        }
                                    }

                                    // Color transition
                                    Behavior on color {
                                        ColorAnimation { duration: 300 }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // Progress circles (only show circles for current step count)
            Row {
                anchors.centerIn: parent
                spacing: maxSubSteps > 1 ? (parent.width - (maxSubSteps * 20)) / (maxSubSteps - 1) : 0

                Repeater {
                    model: maxSubSteps
                    delegate: Rectangle {
                        width: 20
                        height: 20
                        radius: 10
                        color: subStepsCompleted[model.index] ?
                               "#6200ee" : "#3a3a3a"
                        border.color: "#ffffff"
                        border.width: 1

                        // Checkmark for completed steps (instead of small circle)
                        Text {
                            anchors.centerIn: parent
                            text: "✓"
                            font.pixelSize: 12
                            font.bold: true
                            color: "#ffffff"
                            visible: subStepsCompleted[model.index]

                            // Scale animation when appearing
                            scale: subStepsCompleted[model.index] ? 1.0 : 0.5
                            opacity: subStepsCompleted[model.index] ? 1.0 : 0.0

                            Behavior on scale {
                                NumberAnimation { duration: 200 }
                            }

                            Behavior on opacity {
                                NumberAnimation { duration: 200 }
                            }
                        }

                        // Empty circle indicator for incomplete steps
                        Rectangle {
                            width: 8
                            height: 8
                            radius: 4
                            anchors.centerIn: parent
                            color: "#666666"
                            visible: !subStepsCompleted[model.index]

                            Behavior on opacity {
                                NumberAnimation { duration: 200 }
                            }
                        }

                        // Hover effect
                        scale: mouseArea.containsMouse ? 1.1 : 1.0
                        Behavior on scale {
                            NumberAnimation { duration: 150 }
                        }

                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            hoverEnabled: !isAutoRunning
                            onClicked: root.subStepClicked(model.index)
                        }
                    }
                }
            }
        }
    }
}
