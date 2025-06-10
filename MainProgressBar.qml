// version.2
// import QtQuick 2.15

// Item {
//     id: root

//     property int currentStep: 0
//     property bool isComplete: false

//     Item {
//         width: parent.width
//         height: parent.height

//         // Progress line background
//         Rectangle {
//             width: parent.width - 60
//             height: 4
//             anchors.centerIn: parent
//             color: "#444444"
//             radius: 2
//         }

//         // Progress line filled
//         Rectangle {
//             width: (parent.width - 60) * (currentStep / 3)
//             height: 4
//             anchors.left: parent.left
//             anchors.leftMargin: 30
//             anchors.verticalCenter: parent.verticalCenter
//             color: "#6200ee"
//             radius: 2

//             Behavior on width {
//                 NumberAnimation { duration: 500; easing.type: Easing.OutCubic }
//             }
//         }

//         // Step indicators (square, no glow effects)
//         Row {
//             anchors.centerIn: parent
//             spacing: (parent.width - 120) / 3

//             Repeater {
//                 model: ["A", "B", "C", "D"]
//                 delegate: Rectangle {
//                     width: 30
//                     height: 20
//                     color: currentStep > model.index ?
//                            "#6200ee" : (currentStep === model.index ? "#6200ee" : "#3a3a3a")
//                     border.color: "#ffffff"
//                     border.width: 1

//                     Text {
//                         anchors.centerIn: parent
//                         text: currentStep > model.index ? "✓" : modelData
//                         font.pixelSize: currentStep > model.index ? 10 : 12
//                         font.bold: true
//                         color: "#ffffff"
//                     }
//                 }
//             }
//         }
//     }
// }


// //version.3

// import QtQuick 2.15

// Item {
//     id: root

//     property int currentStep: 0
//     property bool isComplete: false

//     Row {
//         anchors.centerIn: parent
//         spacing: (parent.width - 120) / 3 // Dynamic spacing

//         Repeater {
//             model: ["A", "B", "C", "D"]
//             delegate: Item {
//                 width: 30
//                 height: 20

//                 Rectangle {
//                     width:30
//                     height:20
//                     color: (index <= currentStep) ? "#6200ee" : "#3a3a3a"
//                     border.color: "#ffffff"
//                     border.width: 2

//                     Text {
//                         anchors.centerIn: parent
//                         text: (index < currentStep || (index === currentStep && isComplete)) ? "✓" : modelData
//                         font.pixelSize: 16
//                         font.bold: true
//                         color: "#ffffff"
//                     }

//                     Behavior on color {
//                         ColorAnimation { duration: 300 }
//                     }
//                 }

//                 // Connecting line (except for last item)
//                 Rectangle {
//                     visible: index < 3
//                     width: (parent.parent.width - 120) / 3
//                     height: 2
//                     color: (index < currentStep) ? "#6200ee" : "#555555"
//                     anchors.left: parent.right
//                     anchors.verticalCenter: parent.verticalCenter

//                     Behavior on color {
//                         ColorAnimation { duration: 300 }
//                     }
//                 }
//             }
//         }
//     }
// }



// version v4. updated with state management
import QtQuick 2.15

Item {
    id: root

    property int currentStep: 0
    property bool isComplete: false
    // NEW: Property to control if a main step is clickable
    property bool currentStepClickable: false

    // NEW: Signal to emit when a main step is clicked
    signal mainStepClicked(int index)

    Row {
        anchors.centerIn: parent
        spacing: (parent.width - 120) / 3 // Dynamic spacing

        Repeater {
            model: ["A", "B", "C", "D"]
            delegate: Item {
                width: 30
                height: 20

                Rectangle {
                    width:30
                    height:20
                    color: (index <= root.currentStep) ? "#6200ee" : "#3a3a3a"
                    border.color: "#ffffff"
                    border.width: 2

                    Text {
                        anchors.centerIn: parent
                        text: (index < root.currentStep || (index === root.currentStep && root.isComplete)) ? "✓" : modelData
                        font.pixelSize: 16
                        font.bold: true
                        color: "#ffffff"
                    }

                    Behavior on color {
                        ColorAnimation { duration: 300 }
                    }

                    // NEW: MouseArea to make the step clickable
                    MouseArea {
                        anchors.fill: parent
                        // Only enable click for the current step if it's explicitly allowed
                        enabled: index === root.currentStep && root.currentStepClickable && !root.isComplete
                        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                        onClicked: {
                            root.mainStepClicked(index)
                        }
                    }
                }

                // Connecting line (except for last item)
                Rectangle {
                    visible: index < 3
                    width: (parent.parent.width - 120) / 3
                    height: 2
                    color: (index < root.currentStep) ? "#6200ee" : "#555555"
                    anchors.left: parent.right
                    anchors.verticalCenter: parent.verticalCenter

                    Behavior on color {
                        ColorAnimation { duration: 300 }
                    }
                }
            }
        }
    }
}
