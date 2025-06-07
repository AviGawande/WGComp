// import QtQuick 2.15
// import QtQuick.Controls 2.15

// Item {
//     id: root
//     height: isOpen ? (37 + 400) : 37

//     // Properties
//     property int machineIndex: 0
//     property bool isOpen: false
//     property string machineName: "Machine"
//     property string currentStepName: "A"
//     property int completedSubSteps: 0
//     property bool isComplete: false
//     property bool isAutoRunning: false
//     property int currentMainStep: 0
//     property var subStepsCompleted: [false, false, false, false, false]
//     property var operationStatus: [false, false, false, false]
//     property var parameters: [false, false, false, false, false, false]

//     // Signals
//     signal toggleOpen()
//     signal advanceNext()
//     signal goBack()
//     signal reset()
//     signal toggleAuto()
//     signal subStepToggled(int subIndex)
//     signal parameterToggled(int paramIndex)

//     // Function to get current image based on main step and sub-progress
//     function getCurrentImageIndex() {
//         // Calculate image index based on main step and completed sub-steps
//         var baseIndex = currentMainStep * 5; // 5 images per main step (A, B, C, D)
//         var subIndex = completedSubSteps;
//         return baseIndex + subIndex;
//     }

//     // Auto progress timer
//     Timer {
//         id: autoProgressTimer
//         interval: 3000 // 3 seconds
//         repeat: true
//         running: isAutoRunning && !isComplete
//         onTriggered: {
//             advanceNext()
//         }
//     }

//     // Smooth height transition
//     Behavior on height {
//         NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
//     }

//     Rectangle {
//         id: machineTab
//         width: parent.width
//         height: 37
//         color: isOpen ? "#2a2a2a" : "#1e1e1e"
//         border.color: "#444444"
//         border.width: 1
//         radius: 3

//         Row {
//             anchors.left: parent.left
//             anchors.leftMargin: 10
//             anchors.verticalCenter: parent.verticalCenter
//             spacing: 10

//             Text {
//                 text: machineName
//                 font.pixelSize: 14
//                 font.bold: true
//                 color: "#ffffff"
//             }

//             // Progress indicator in tab
//             Text {
//                 text: "(" + currentStepName + " - " + completedSubSteps + "/5)"
//                 font.pixelSize: 10
//                 color: "#aaaaaa"
//             }

//             // Auto progress indicator
//             Rectangle {
//                 visible: isAutoRunning
//                 width: 8
//                 height: 8
//                 radius: 4
//                 color: "#4CAF50"
//                 anchors.verticalCenter: parent.verticalCenter

//                 // Pulsing animation
//                 SequentialAnimation on opacity {
//                     running: isAutoRunning
//                     loops: Animation.Infinite
//                     NumberAnimation { to: 0.3; duration: 800 }
//                     NumberAnimation { to: 1.0; duration: 800 }
//                 }
//             }
//         }

//         // Dropdown arrow
//         Text {
//             anchors.right: parent.right
//             anchors.rightMargin: 15
//             anchors.verticalCenter: parent.verticalCenter
//             text: "˅"
//             font.pixelSize: 12
//             color: "#ffffff"
//             rotation: isOpen ? 180 : 0
//             Behavior on rotation {
//                 NumberAnimation { duration: 300 }
//             }
//         }

//         MouseArea {
//             anchors.fill: parent
//             onClicked: toggleOpen()
//         }
//     }

//     // Dropdown content
//     Rectangle {
//         id: dropdownContent
//         width: parent.width
//         height: 400
//         y: 37
//         color: "#2a2a2a"
//         border.color: "#444444"
//         border.width: 1
//         radius: 3
//         visible: isOpen
//         opacity: isOpen ? 1 : 0
//         clip: true

//         Behavior on opacity {
//             NumberAnimation { duration: 300 }
//         }

//         Column {
//             anchors.fill: parent
//             anchors.margins: 15
//             spacing: 15

//             // Name section
//             Row {
//                 width: parent.width
//                 spacing: 10
//                 Text {
//                     text: "Name:"
//                     font.pixelSize: 12
//                     color: "#ffffff"
//                     anchors.verticalCenter: parent.verticalCenter
//                 }
//                 Rectangle {
//                     width: 120
//                     height: 24
//                     border.color: "#444444"
//                     border.width: 1
//                     color: "#3a3a3a"
//                     radius: 2

//                     TextInput {
//                         anchors.fill: parent
//                         anchors.margins: 3
//                         font.pixelSize: 12
//                         color: "#ffffff"
//                         verticalAlignment: TextInput.AlignVCenter
//                         text: machineName
//                         selectByMouse: true
//                     }
//                 }
//             }

//             // Image section with dynamic content
//             Rectangle {
//                 width: parent.width
//                 height: 100
//                 border.color: "#444444"
//                 border.width: 1
//                 color: "#3a3a3a"
//                 radius: 2

//                 Column {
//                     anchors.centerIn: parent
//                     spacing: 5

//                     // Dynamic image based on progress
//                     Image {
//                         anchors.horizontalCenter: parent.horizontalCenter
//                         width: 80
//                         height: 60
//                         source: "/placeholder.svg?height=60&width=80&text=" + currentStepName + (completedSubSteps + 1)
//                         fillMode: Image.PreserveAspectFit

//                         // Fallback text when image is not available
//                         Text {
//                             anchors.centerIn: parent
//                             text: "Image"
//                             font.pixelSize: 12
//                             color: "#888888"
//                             visible: parent.status !== Image.Ready
//                         }
//                     }

//                     Text {
//                         anchors.horizontalCenter: parent.horizontalCenter
//                         text: "Step: " + currentStepName + (completedSubSteps + 1)
//                         font.pixelSize: 10
//                         color: "#6200ee"
//                         font.bold: true
//                     }
//                 }
//             }

//             // Main Progress Bar (simplified)
//             MainProgressBar {
//                 width: parent.width
//                 height: 50
//                 currentStep: currentMainStep
//                 isComplete: root.isComplete
//             }

//             // Sub-Progress Indicators (simplified, no glow)
//             SubProgressBar {
//                 width: parent.width
//                 height: 60
//                 subStepsCompleted: root.subStepsCompleted
//                 isAutoRunning: root.isAutoRunning
//                 onSubStepClicked: {
//                     if (!isComplete && !isAutoRunning) {
//                         subStepToggled(index)
//                     }
//                 }
//             }

//             Rectangle {
//                 width: parent.width
//                 height: 1
//                 color: "#444444"
//             }

//             // Parameters section
//             ParameterSection {
//                 width: parent.width
//                 height: 80
//                 parameters: root.parameters
//                 onParameterClicked: {
//                     parameterToggled(index)
//                 }
//             }

//             // Control buttons
//             Row {
//                 spacing: 10
//                 anchors.horizontalCenter: parent.horizontalCenter

//                 Rectangle {
//                     width: 60
//                     height: 30
//                     color: "#ffffff"
//                     radius: 4
//                     opacity: completedSubSteps > 0 ? 1.0 : 0.5

//                     Text {
//                         anchors.centerIn: parent
//                         text: "Back"
//                         font.pixelSize: 12
//                         color: "#6200ee"
//                     }

//                     MouseArea {
//                         anchors.fill: parent
//                         enabled: completedSubSteps > 0 || currentMainStep > 0
//                         onClicked: goBack()
//                     }
//                 }

//                 Rectangle {
//                     width: 60
//                     height: 30
//                     color: isComplete ? "#4CAF50" : "#6200ee"
//                     radius: 4

//                     Text {
//                         anchors.centerIn: parent
//                         text: isComplete ? "Done" : "Next"
//                         font.pixelSize: 12
//                         color: "#ffffff"
//                     }

//                     MouseArea {
//                         anchors.fill: parent
//                         enabled: !isComplete
//                         onClicked: advanceNext()
//                     }
//                 }

//                 Rectangle {
//                     width: 60
//                     height: 30
//                     color: isAutoRunning ? "#FF9800" : "#03A9F4"
//                     radius: 4

//                     Text {
//                         anchors.centerIn: parent
//                         text: isAutoRunning ? "Stop" : "Auto"
//                         font.pixelSize: 12
//                         color: "#ffffff"
//                     }

//                     MouseArea {
//                         anchors.fill: parent
//                         onClicked: toggleAuto()
//                     }
//                 }

//                 Rectangle {
//                     width: 60
//                     height: 30
//                     color: "#f44336"
//                     radius: 4

//                     Text {
//                         anchors.centerIn: parent
//                         text: "Reset"
//                         font.pixelSize: 12
//                         color: "#ffffff"
//                     }

//                     MouseArea {
//                         anchors.fill: parent
//                         onClicked: reset()
//                     }
//                 }
//             }
//         }
//     }
// }



// version 2 functional states of subProgressBar

// import QtQuick 2.15
// import QtQuick.Controls 2.15

// Item {
//     id: root
//     height: isOpen ? (37 + 400) : 37

//     // Properties
//     property int machineIndex: 0
//     property bool isOpen: false
//     property string machineName: "Tube"
//     property string currentStepName: "A"
//     property int completedSubSteps: 0
//     property int maxSubSteps: 4 // Dynamic based on current main step
//     property bool isComplete: false
//     property bool isAutoRunning: false
//     property int currentMainStep: 0
//     property var subStepsCompleted: [false, false, false, false, false]
//     property var operationStatus: [false, false, false, false]
//     property var parameters: [false, false, false, false, false, false]

//     // Signals
//     signal toggleOpen()
//     signal advanceNext()
//     signal goBack()
//     signal reset()
//     signal toggleAuto()
//     signal subStepToggled(int subIndex)
//     signal parameterToggled(int paramIndex)

//     // Function to get current image path based on main step and sub-progress
//     function getCurrentImagePath() {
//         var mainStepNames = ["A", "B", "C", "D"];
//         var currentMainStepName = mainStepNames[currentMainStep];
//         var currentSubStep = completedSubSteps + 1; // Show next step to be completed

//         // If all sub-steps are completed, show the last image of current main step
//         if (completedSubSteps >= maxSubSteps) {
//             currentSubStep = maxSubSteps;
//         }

//         // Build the image path
//         var imagePath = "qrc:/images/" + currentMainStepName + currentSubStep + ".png";
//         console.log("Loading image: " + imagePath + " (Step: " + currentMainStepName + ", Sub: " + currentSubStep + "/" + maxSubSteps + ")");
//         return imagePath;
//     }

//     // Auto progress timer
//     Timer {
//         id: autoProgressTimer
//         interval: 3000 // 3 seconds
//         repeat: true
//         running: isAutoRunning && !isComplete
//         onTriggered: {
//             advanceNext()
//         }
//     }

//     // Smooth height transition
//     Behavior on height {
//         NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
//     }

//     Rectangle {
//         id: machineTab
//         width: parent.width
//         height: 37
//         color: isOpen ? "#2a2a2a" : "#1e1e1e"
//         border.color: "#444444"
//         border.width: 1
//         radius: 3

//         Row {
//             anchors.left: parent.left
//             anchors.leftMargin: 10
//             anchors.verticalCenter: parent.verticalCenter
//             spacing: 10

//             Text {
//                 id:machineText
//                 text: machineName
//                 font.pixelSize: 14
//                 font.bold: true
//                 color: "#ffffff"
//                 anchors.verticalCenter:parent.verticalCenter
//             }

//             Rectangle{
//                 // width:45
//                 width:label.implicitWidth + 10
//                 height:20
//                 anchors.verticalCenter:parent.verticalCenter
//                 color:"transparent"
//                 border.color:(index === 0 ) ? "white" :(index===1) ? "red" : "#4ACF50"
//                 border.width:1

//                 Rectangle{
//                     anchors.fill:parent
//                     opacity:0.20
//                     color:(index === 0 ) ? "white" :(index===1) ? "red" : "#4ACF50"
//                 }

//                 Text {
//                     id:label
//                     anchors.centerIn:parent
//                     text: (index === 0) ? "EMPTY" : (index === 1) ? "WARNING" : "READY"
//                     font.pixelSize: 10
//                     color: (index === 0 ) ? "white" :(index===1) ? "red" : "#4ACF50"
//                 }

//             }



//             // Auto progress indicator
//             Rectangle {
//                 visible: isAutoRunning
//                 width: 8
//                 height: 8
//                 radius: 4
//                 color: "#4CAF50"
//                 anchors.verticalCenter: parent.verticalCenter

//                 // Pulsing animation
//                 SequentialAnimation on opacity {
//                     running: isAutoRunning
//                     loops: Animation.Infinite
//                     NumberAnimation { to: 0.3; duration: 800 }
//                     NumberAnimation { to: 1.0; duration: 800 }
//                 }
//             }
//         }

//         // Dropdown arrow
//         Text {
//             anchors.right: parent.right
//             anchors.rightMargin: 15
//             anchors.verticalCenter: parent.verticalCenter
//             text: "˅"
//             font.pixelSize: 12
//             color: "#ffffff"
//             rotation: isOpen ? 180 : 0
//             Behavior on rotation {
//                 NumberAnimation { duration: 300 }
//             }
//         }

//         MouseArea {
//             anchors.fill: parent
//             onClicked: toggleOpen()
//         }
//     }

//     // Dropdown content
//     Rectangle {
//         id: dropdownContent
//         width: parent.width
//         height: 400
//         y: 37
//         color: "#2a2a2a"
//         border.color: "#444444"
//         border.width: 1
//         radius: 3
//         visible: isOpen
//         opacity: isOpen ? 1 : 0
//         clip: true

//         Behavior on opacity {
//             NumberAnimation { duration: 300 }
//         }

//         Column {
//             anchors.fill: parent
//             anchors.margins: 10
//             spacing: 10

//             // Name section
//             Row {
//                 width: parent.width
//                 spacing: 10
//                 Text {
//                     text: "Tube " + (index + 1)
//                     font.pixelSize: 12
//                     color: "#ffffff"
//                     anchors.verticalCenter: parent.verticalCenter
//                 }
//                 Rectangle {
//                     width: 120
//                     height: 24
//                     border.color: "#444444"
//                     border.width: 1
//                     color: "#3a3a3a"
//                     radius: 2

//                     TextInput {
//                         anchors.fill: parent
//                         anchors.margins: 3
//                         font.pixelSize: 12
//                         color: "#ffffff"
//                         verticalAlignment: TextInput.AlignVCenter
//                         text: machineName
//                         selectByMouse: true
//                     }
//                 }
//             }

//             // Image section with dynamic content
//             Rectangle {
//                 width: 290
//                 height: 68
//                 border.color: "#444444"
//                 border.width: 1
//                 color: "#3a3a3a"
//                 radius: 2

//                 Image {
//                     id: stepImage
//                     // anchors.centerIn: parent
//                     width: parent.width - 10
//                     height: parent.height - 10
//                     source: getCurrentImagePath()
//                     fillMode: Image.PreserveAspectFit
//                     cache: true
//                     asynchronous: true

//                     // Debug image loading
//                     onStatusChanged: {
//                         if (status === Image.Ready) {
//                             console.log("✓ Image loaded: " + source)
//                         } else if (status === Image.Error) {
//                             console.log("✗ Error loading: " + source)
//                         }
//                     }

//                     // Smooth transition when image changes
//                     Behavior on opacity {
//                         NumberAnimation { duration: 300 }
//                     }

//                     // Fallback when image is not available
//                     Rectangle {
//                         anchors.centerIn: parent
//                         width: parent.width
//                         height: parent.height
//                         color: "transparent"
//                         visible: parent.status !== Image.Ready

//                         Column {
//                             anchors.centerIn: parent
//                             spacing: 5

//                             Text {
//                                 anchors.horizontalCenter: parent.horizontalCenter
//                                 text: "Image"
//                                 font.pixelSize: 16
//                                 color: "#888888"
//                             }

//                             Text {
//                                 anchors.horizontalCenter: parent.horizontalCenter
//                                 text: currentStepName + (completedSubSteps + 1) + "/" + maxSubSteps
//                                 font.pixelSize: 12
//                                 color: "#6200ee"
//                                 font.bold: true
//                             }
//                         }
//                     }
//                 }
//             }

//             // Main Progress Bar (simplified)
//             MainProgressBar {
//                 width: parent.width
//                 height: 40
//                 currentStep: currentMainStep
//                 isComplete: root.isComplete
//             }

//             // Sub-Progress Indicators (dynamic based on current step)
//             SubProgressBar {
//                 width: parent.width
//                 height: 40
//                 subStepsCompleted: root.subStepsCompleted
//                 maxSubSteps: root.maxSubSteps
//                 isAutoRunning: root.isAutoRunning
//                 onSubStepClicked: {
//                     if (!isComplete && !isAutoRunning) {
//                         subStepToggled(index)
//                     }
//                 }
//             }

//             Rectangle {
//                 width: parent.width
//                 height: 1
//                 color: "#444444"
//             }

//             // Parameters section
//             ParameterSection {
//                 width: parent.width
//                 height: 80
//                 parameters: root.parameters
//                 onParameterClicked: {
//                     parameterToggled(index)
//                 }
//             }

//             // Control buttons
//             Row {
//                 spacing: 10
//                 anchors.horizontalCenter: parent.horizontalCenter

//                 Rectangle {
//                     width: 60
//                     height: 30
//                     color: "#ffffff"
//                     radius: 4
//                     opacity: completedSubSteps > 0 ? 1.0 : 0.5

//                     Text {
//                         anchors.centerIn: parent
//                         text: "Back"
//                         font.pixelSize: 12
//                         color: "#6200ee"
//                     }

//                     MouseArea {
//                         anchors.fill: parent
//                         enabled: completedSubSteps > 0 || currentMainStep > 0
//                         onClicked: goBack()
//                     }
//                 }

//                 Rectangle {
//                     width: 60
//                     height: 30
//                     color: isComplete ? "#4CAF50" : "#6200ee"
//                     radius: 4

//                     Text {
//                         anchors.centerIn: parent
//                         text: isComplete ? "Done" : "Next"
//                         font.pixelSize: 12
//                         color: "#ffffff"
//                     }

//                     MouseArea {
//                         anchors.fill: parent
//                         enabled: !isComplete
//                         onClicked: advanceNext()
//                     }
//                 }

//                 Rectangle {
//                     width: 60
//                     height: 30
//                     color: isAutoRunning ? "#FF9800" : "#03A9F4"
//                     radius: 4

//                     Text {
//                         anchors.centerIn: parent
//                         text: isAutoRunning ? "Stop" : "Auto"
//                         font.pixelSize: 12
//                         color: "#ffffff"
//                     }

//                     MouseArea {
//                         anchors.fill: parent
//                         onClicked: toggleAuto()
//                     }
//                 }

//                 Rectangle {
//                     width: 60
//                     height: 30
//                     color: "#f44336"
//                     radius: 4

//                     Text {
//                         anchors.centerIn: parent
//                         text: "Reset"
//                         font.pixelSize: 12
//                         color: "#ffffff"
//                     }

//                     MouseArea {
//                         anchors.fill: parent
//                         onClicked: reset()
//                     }
//                 }
//             }
//         }
//     }
// }


import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: root
    height: isOpen ? (37 + 450) : 37 // Increased height to accommodate new status section

    // Properties
    property int machineIndex: 0
    property bool isOpen: false
    property string machineName: "Machine"
    property string currentStepName: "A"
    property int completedSubSteps: 0
    property int maxSubSteps: 4 // Dynamic based on current main step
    property bool isComplete: false
    property bool isAutoRunning: false
    property int currentMainStep: 0
    property var subStepsCompleted: [false, false, false, false, false]
    property var operationStatus: [false, false, false, false]
    property var parameters: [false, false, false, false, false, false]

    // NEW: Properties for tracking SubProgressBar changes
    property string launchStateText: "A in Progress"
    property string tubeStateText: "A in Progress"
    property string weaponStateText: "No Sequence"
    property int lastToggledSubStep: -1

    // Signals
    signal toggleOpen()
    signal advanceNext()
    signal goBack()
    signal reset()
    signal toggleAuto()
    signal subStepToggled(int subIndex)
    signal parameterToggled(int paramIndex)

    // Function to get current image path based on main step and sub-progress
    function getCurrentImagePath() {
        var mainStepNames = ["A", "B", "C", "D"];
        var currentMainStepName = mainStepNames[currentMainStep];
        var currentSubStep = completedSubSteps + 1; // Show next step to be completed

        // If all sub-steps are completed, show the last image of current main step
        if (completedSubSteps >= maxSubSteps) {
            currentSubStep = maxSubSteps;
        }

        // Build the image path
        var imagePath = "qrc:/images/" + currentMainStepName + currentSubStep + ".png";
        console.log("Loading image: " + imagePath + " (Step: " + currentMainStepName + ", Sub: " + currentSubStep + "/" + maxSubSteps + ")");
        return imagePath;
    }

    // NEW: Function to update status based on sub-step changes
    function updateStatusFromSubStep(subIndex, isCompleted) {
        var mainStepNames = ["A", "B", "C", "D"];
        var currentMainStepName = mainStepNames[currentMainStep];

        // Update last toggled sub-step
        lastToggledSubStep = subIndex;

        // Update launch state text
        if (isCompleted) {
            launchStateText = currentMainStepName + " P" + (subIndex + 1) + " Completed";
        } else {
            launchStateText = currentMainStepName + " P" + (subIndex + 1) + " In Progress";
        }

        // Update tube state text
        tubeStateText = currentMainStepName + " Step " + (subIndex + 1) + "/" + maxSubSteps;

        // Update weapon state text based on main step
        if (currentMainStep < 2) { // A or B
            weaponStateText = "No Sequence";
        } else if (currentMainStep === 2) { // C
            weaponStateText = "Sequence Initiated - P" + (subIndex + 1);
        } else if (currentMainStep === 3) { // D
            weaponStateText = "Sequence Active - P" + (subIndex + 1);
        }

        if (isComplete) {
            launchStateText = "Complete";
            tubeStateText = "Ready";
            weaponStateText = "Sequence Complete";
        }
    }

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
                       id:machineText
                       text: machineName
                       font.pixelSize: 14
                       font.bold: true
                       color: "#ffffff"
                       anchors.verticalCenter:parent.verticalCenter
                   }

                   Rectangle{
                       // width:45
                       width:label.implicitWidth + 10
                       height:20
                       anchors.verticalCenter:parent.verticalCenter
                       color:"transparent"
                       border.color:(index === 0 ) ? "white" :(index===1) ? "red" : "#4ACF50"
                       border.width:1

                       Rectangle{
                           anchors.fill:parent
                           opacity:0.20
                           color:(index === 0 ) ? "white" :(index===1) ? "red" : "#4ACF50"
                       }

                       Text {
                           id:label
                           anchors.centerIn:parent
                           text: (index === 0) ? "EMPTY" : (index === 1) ? "WARNING" : "READY"
                           font.pixelSize: 10
                           color: (index === 0 ) ? "white" :(index===1) ? "red" : "#4ACF50"
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
        height: 450 // Increased height
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
                    text: "Tube "
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

            // Image section with dynamic content
            Rectangle {
                width: parent.width
                height: 68
                border.color: "#444444"
                border.width: 1
                color: "#3a3a3a"
                radius: 2

                Image {
                    id: stepImage
                    anchors.centerIn: parent
                    width: parent.width - 10
                    height: parent.height - 10
                    source: getCurrentImagePath()
                    fillMode: Image.PreserveAspectFit
                    cache: true
                    asynchronous: true

                    // Debug image loading
                    onStatusChanged: {
                        if (status === Image.Ready) {
                            console.log("✓ Image loaded: " + source)
                        } else if (status === Image.Error) {
                            console.log("✗ Error loading: " + source)
                        }
                    }

                    // Smooth transition when image changes
                    Behavior on opacity {
                        NumberAnimation { duration: 300 }
                    }

                    // Fallback when image is not available
                    Rectangle {
                        anchors.centerIn: parent
                        width: parent.width
                        height: parent.height
                        color: "transparent"
                        visible: parent.status !== Image.Ready

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
                                text: currentStepName + (completedSubSteps + 1) + "/" + maxSubSteps
                                font.pixelSize: 12
                                color: "#6200ee"
                                font.bold: true
                            }
                        }
                    }
                }
            }

            // Main Progress Bar (simplified)
            MainProgressBar {
                width: parent.width
                height: 40
                currentStep: currentMainStep
                isComplete: root.isComplete
            }

            // Sub-Progress Indicators (dynamic based on current step)
            SubProgressBar {
                width: parent.width
                height: 40
                subStepsCompleted: root.subStepsCompleted
                maxSubSteps: root.maxSubSteps
                isAutoRunning: root.isAutoRunning
                onSubStepClicked: {
                    if (!isComplete && !isAutoRunning) {
                        // Update status before toggling the step
                        updateStatusFromSubStep(index, !subStepsCompleted[index]);
                        subStepToggled(index);
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: "#444444"
            }

            // Status Display Section - Shows SubProgressBar changes
            Rectangle {
                width: parent.width
                height: 40
                color: "transparent"
                anchors.margins:5

                Column {
                    anchors.fill: parent
                    spacing: 4

                    // Status header
                    Text {
                        text: "STATUS"
                        font.pointSize: 10
                        font.bold: true
                        color: "#ffffff"
                    }

                    // Launch State - Shows which step was just completed
                    Row {
                        width: parent.width
                        spacing: 5

                        Text {
                            width: parent.width * 0.4
                            text: "Launch State:"
                            font.pointSize: 8
                            color: "#aaaaaa"
                            elide: Text.ElideRight
                        }

                        Text {
                            width: parent.width * 0.6
                            text: launchStateText
                            font.pointSize: 8
                            color: "#ffffff"
                            elide: Text.ElideRight

                            // Highlight animation when text changes
                            SequentialAnimation on color {
                                id: launchTextAnimation
                                running: false
                                ColorAnimation { to: "#6200ee"; duration: 200 }
                                ColorAnimation { to: "#ffffff"; duration: 800 }
                            }

                            // Trigger animation when text changes
                            onTextChanged: launchTextAnimation.restart()
                        }
                    }

                    // Tube State - Shows current progress
                    Row {
                        width: parent.width
                        spacing: 5

                        Text {
                            width: parent.width * 0.4
                            text: "Tube State:"
                            font.pointSize: 8
                            color: "#aaaaaa"
                            elide: Text.ElideRight
                        }

                        Text {
                            width: parent.width * 0.6
                            text: tubeStateText
                            font.pointSize: 8
                            color: "#ffffff"
                            elide: Text.ElideRight

                            // Highlight animation when text changes
                            SequentialAnimation on color {
                                id: tubeTextAnimation
                                running: false
                                ColorAnimation { to: "#6200ee"; duration: 200 }
                                ColorAnimation { to: "#ffffff"; duration: 800 }
                            }

                            // Trigger animation when text changes
                            onTextChanged: tubeTextAnimation.restart()
                        }
                    }

                    // Weapon State - Shows sequence status
                    Row {
                        width: parent.width
                        spacing: 5

                        Text {
                            width: parent.width * 0.4
                            text: "Weapon:"
                            font.pointSize: 8
                            color: "#aaaaaa"
                            elide: Text.ElideRight
                        }

                        Text {
                            width: parent.width * 0.6
                            text: weaponStateText
                            font.pointSize: 8
                            color: "#ffffff"
                            elide: Text.ElideRight

                            // Highlight animation when text changes
                            SequentialAnimation on color {
                                id: weaponTextAnimation
                                running: false
                                ColorAnimation { to: "#6200ee"; duration: 200 }
                                ColorAnimation { to: "#ffffff"; duration: 800 }
                            }

                            // Trigger animation when text changes
                            onTextChanged: weaponTextAnimation.restart()
                        }
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: "#444444"
            }

            ParameterSection {
                width: parent.width
                anchors.topMargin: 10
                height: 60
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
                        onClicked: {
                            // Update status before going back
                            var prevStep = -1;
                            for (var i = maxSubSteps - 1; i >= 0; i--) {
                                if (subStepsCompleted[i]) {
                                    prevStep = i;
                                    break;
                                }
                            }
                            if (prevStep >= 0) {
                                updateStatusFromSubStep(prevStep, false);
                            }
                            goBack();
                        }
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
                        onClicked: {
                            // Find next incomplete step
                            var nextStep = -1;
                            for (var i = 0; i < maxSubSteps; i++) {
                                if (!subStepsCompleted[i]) {
                                    nextStep = i;
                                    break;
                                }
                            }
                            if (nextStep >= 0) {
                                updateStatusFromSubStep(nextStep, true);
                            }
                            advanceNext();
                        }
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
                        onClicked: {
                            // Reset status texts
                            launchStateText = "A in Progress";
                            tubeStateText = "A in Progress";
                            weaponStateText = "No Sequence";
                            lastToggledSubStep = -1;
                            reset();
                        }
                    }
                }
            }
        }
    }
}
