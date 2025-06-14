/*
// import QtQuick 2.15
// import QtQuick.Controls 2.15

// Rectangle {
//     id: mainContainer
//     width: 348
//     height: implicitHeight
//     implicitHeight: contentColumn.implicitHeight + 30

//     color: "#1e1e1e"
//     border.color: "#333333"
//     border.width: 1

//     property int currentOpenMachine: -1

//     // Signal for close button
//     signal closeRequested()

//     // Define sub-steps for each main step
//     property var subStepsConfig: {
//         "A": 4,  // Step A has 4 sub-steps
//         "B": 5,  // Step B has 5 sub-steps
//         "C": 2,  // Step C has 2 sub-steps
//         "D": 2   // Step D has 2 sub-steps
//     }

//     // Progress data structure for each machine
//     property var machineProgressData: {
//         var data = {};
//         for (var i = 0; i < 6; i++) {
//             data[i] = {
//                 currentMainStep: 0,  // 0=A, 1=B, 2=C, 3=D
//                 subStepsCompleted: [false, false, false, false, false], // Max 5 sub-steps
//                 operationStatus: [false, false, false, false],
//                 parameters: [false, false, false, false, false, false],
//                 isComplete: false,
//                 isAutoProgressRunning: false
//             };
//         }
//         return data;
//     }

//     // Function to get current sub-steps count for a main step
//     function getCurrentSubStepsCount(mainStep) {
//         var stepNames = ["A", "B", "C", "D"];
//         var stepName = stepNames[mainStep];
//         return subStepsConfig[stepName] || 5; // Default to 5 if not found
//     }

//     // Function to get completed sub-steps count
//     function getCompletedSubSteps(machineIndex) {
//         var machine = machineProgressData[machineIndex];
//         var maxSteps = getCurrentSubStepsCount(machine.currentMainStep);
//         var count = 0;
//         for (var i = 0; i < maxSteps; i++) {
//             if (machine.subStepsCompleted[i]) count++;
//         }
//         return count;
//     }

//     // Function to check if all sub-steps are completed for current main step
//     function areAllSubStepsCompleted(machineIndex) {
//         var machine = machineProgressData[machineIndex];
//         var maxSteps = getCurrentSubStepsCount(machine.currentMainStep);
//         for (var i = 0; i < maxSteps; i++) {
//             if (!machine.subStepsCompleted[i]) return false;
//         }
//         return true;
//     }

//     // Function to advance sub-progress
//     function toggleSubStep(machineIndex, subIndex) {
//         var machine = machineProgressData[machineIndex];
//         var maxSteps = getCurrentSubStepsCount(machine.currentMainStep);

//         // Only allow toggling within the current step's range
//         if (subIndex >= maxSteps) return;

//         // Toggle the sub-step
//         machine.subStepsCompleted[subIndex] = !machine.subStepsCompleted[subIndex];

//         // Check if all sub-steps are now completed
//         if (areAllSubStepsCompleted(machineIndex)) {
//             // Advance main progress
//             if (machine.currentMainStep < 3) { // 0,1,2,3 = A,B,C,D
//                 machine.currentMainStep++;
//                 // Reset sub-steps for next main step
//                 machine.subStepsCompleted = [false, false, false, false, false];

//                 // Update operation status
//                 machine.operationStatus[machine.currentMainStep - 1] = true;
//             } else {
//                 // All main steps completed
//                 machine.isComplete = true;
//                 machine.operationStatus[3] = true; // Mark OP-4 as complete
//                 machine.isAutoProgressRunning = false; // Stop auto progress
//             }
//         }

//         // Trigger UI update
//         machineProgressData = machineProgressData;
//     }

//     // Function to advance to next incomplete sub-step
//     function advanceNextSubStep(machineIndex) {
//         var machine = machineProgressData[machineIndex];

//         if (machine.isComplete) return;

//         var maxSteps = getCurrentSubStepsCount(machine.currentMainStep);

//         // Find next incomplete sub-step
//         for (var i = 0; i < maxSteps; i++) {
//             if (!machine.subStepsCompleted[i]) {
//                 toggleSubStep(machineIndex, i);
//                 break;
//             }
//         }
//     }

//     // Function to go back one sub-step
//     function goBackSubStep(machineIndex) {
//         var machine = machineProgressData[machineIndex];

//         // If we're at the beginning of a main step and there's a previous main step
//         if (getCompletedSubSteps(machineIndex) === 0 && machine.currentMainStep > 0) {
//             machine.currentMainStep--;
//             var prevMaxSteps = getCurrentSubStepsCount(machine.currentMainStep);
//             // Set all sub-steps as completed for previous step
//             for (var i = 0; i < 5; i++) {
//                 machine.subStepsCompleted[i] = i < prevMaxSteps;
//             }
//             machine.operationStatus[machine.currentMainStep] = false;
//             machine.isComplete = false;
//         } else {
//             // Find last completed sub-step and uncomplete it
//             var maxSteps = getCurrentSubStepsCount(machine.currentMainStep);
//             for (var i = maxSteps - 1; i >= 0; i--) {
//                 if (machine.subStepsCompleted[i]) {
//                     machine.subStepsCompleted[i] = false;
//                     break;
//                 }
//             }
//         }

//         machineProgressData = machineProgressData;
//     }

//     // Function to reset progress
//     function resetProgress(machineIndex) {
//         var machine = machineProgressData[machineIndex];
//         machine.currentMainStep = 0;
//         machine.subStepsCompleted = [false, false, false, false, false];
//         machine.operationStatus = [false, false, false, false];
//         machine.parameters = [false, false, false, false, false, false];
//         machine.isComplete = false;
//         machine.isAutoProgressRunning = false;
//         machineProgressData = machineProgressData;
//     }

//     // Function to start/stop auto progress
//     function toggleAutoProgress(machineIndex) {
//         var machine = machineProgressData[machineIndex];
//         machine.isAutoProgressRunning = !machine.isAutoProgressRunning;
//         machineProgressData = machineProgressData;
//     }

//     // Get current step name
//     function getCurrentStepName(machineIndex) {
//         var machine = machineProgressData[machineIndex];
//         var stepNames = ["A", "B", "C", "D"];
//         if (machine.isComplete) return "Complete";
//         return stepNames[machine.currentMainStep];
//     }

//     // Smooth height transition
//     Behavior on implicitHeight {
//         NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
//     }

//     Column {
//         id: contentColumn
//         anchors.left: parent.left
//         anchors.right: parent.right
//         anchors.top: parent.top
//         anchors.margins: 15
//         spacing: 10

//         // Header with title and close button
//         Rectangle {
//             width: parent.width
//             height: 40
//             color: "#2a2a2a"
//             border.color: "#444444"
//             border.width: 1
//             radius: 3

//             Row {
//                 anchors.left: parent.left
//                 anchors.leftMargin: 15
//                 anchors.verticalCenter: parent.verticalCenter
//                 spacing: 10

//                 Text {
//                     text: "Machine Tubes"
//                     font.pixelSize: 16
//                     font.bold: true
//                     color: "#ffffff"
//                     anchors.verticalCenter: parent.verticalCenter
//                 }
//             }

//             // Close button
//             Rectangle {
//                 width: 30
//                 height: 30
//                 anchors.right: parent.right
//                 anchors.rightMargin: 5
//                 anchors.verticalCenter: parent.verticalCenter
//                 color: closeMouseArea.containsMouse ? "#f44336" : "transparent"
//                 radius: 3

//                 Text {
//                     anchors.centerIn: parent
//                     text: "✕"
//                     font.pixelSize: 16
//                     color: "#ffffff"
//                     font.bold: true
//                 }

//                 MouseArea {
//                     id: closeMouseArea
//                     anchors.fill: parent
//                     hoverEnabled: true
//                     onClicked: closeRequested()
//                 }
//             }
//         }

//         // Machine tabs
//         Repeater {
//             model: 6
//             delegate: MachineTab {
//                 width: parent.width
//                 machineIndex: index
//                 isOpen: currentOpenMachine === index
//                 onToggleOpen: {
//                     if (currentOpenMachine === index) {
//                         currentOpenMachine = -1
//                     } else {
//                         currentOpenMachine = index
//                     }
//                 }
//                 onAdvanceNext: advanceNextSubStep(index)
//                 onGoBack: goBackSubStep(index)
//                 onReset: resetProgress(index)
//                 onToggleAuto: toggleAutoProgress(index)

//                 // Data bindings
//                 machineName: "Machine " + (index + 1)
//                 currentStepName: getCurrentStepName(index)
//                 completedSubSteps: getCompletedSubSteps(index)
//                 maxSubSteps: getCurrentSubStepsCount(machineProgressData[index] ? machineProgressData[index].currentMainStep : 0)
//                 isComplete: machineProgressData[index] ? machineProgressData[index].isComplete : false
//                 isAutoRunning: machineProgressData[index] ? machineProgressData[index].isAutoProgressRunning : false
//                 currentMainStep: machineProgressData[index] ? machineProgressData[index].currentMainStep : 0
//                 subStepsCompleted: machineProgressData[index] ? machineProgressData[index].subStepsCompleted : [false, false, false, false, false]
//                 operationStatus: machineProgressData[index] ? machineProgressData[index].operationStatus : [false, false, false, false]
//                 parameters: machineProgressData[index] ? machineProgressData[index].parameters : [false, false, false, false, false, false]

//                 // Event handlers
//                 onSubStepToggled: toggleSubStep(index, subIndex)
//                 onParameterToggled: {
//                     machineProgressData[index].parameters[paramIndex] = !machineProgressData[index].parameters[paramIndex];
//                     machineProgressData = machineProgressData;
//                 }
//             }
//         }
//     }
// }


//version.2 working till functional states of subProgressBar
// import QtQuick 2.15
// import QtQuick.Controls 2.15

// Rectangle {
//     id: mainContainer
//     width: 348
//     height: implicitHeight
//     implicitHeight: contentColumn.implicitHeight + 30

//     color: "#1e1e1e"
//     border.color: "#333333"
//     border.width: 1

//     property int currentOpenMachine: -1

//     // Signal for close button
//     signal closeRequested()

//     // Define sub-steps for each main step
//     property var subStepsConfig: {
//         "A": 4,  // Step A has 4 sub-steps
//         "B": 5,  // Step B has 5 sub-steps
//         "C": 2,  // Step C has 2 sub-steps
//         "D": 2   // Step D has 2 sub-steps
//     }

//     // Progress data structure for each machine
//     property var machineProgressData: {
//         var data = {};
//         for (var i = 0; i < 6; i++) {
//             data[i] = {
//                 currentMainStep: 0,  // 0=A, 1=B, 2=C, 3=D
//                 subStepsCompleted: [false, false, false, false, false], // Max 5 sub-steps
//                 operationStatus: [false, false, false, false],
//                 parameters: [false, false, false, false, false, false],
//                 isComplete: false,
//                 isAutoProgressRunning: false
//             };
//         }
//         return data;
//     }

//     // Function to get current sub-steps count for a main step
//     function getCurrentSubStepsCount(mainStep) {
//         var stepNames = ["A", "B", "C", "D"];
//         var stepName = stepNames[mainStep];
//         return subStepsConfig[stepName] || 5; // Default to 5 if not found
//     }

//     // Function to get completed sub-steps count
//     function getCompletedSubSteps(machineIndex) {
//         var machine = machineProgressData[machineIndex];
//         var maxSteps = getCurrentSubStepsCount(machine.currentMainStep);
//         var count = 0;
//         for (var i = 0; i < maxSteps; i++) {
//             if (machine.subStepsCompleted[i]) count++;
//         }
//         return count;
//     }

//     // Function to check if all sub-steps are completed for current main step
//     function areAllSubStepsCompleted(machineIndex) {
//         var machine = machineProgressData[machineIndex];
//         var maxSteps = getCurrentSubStepsCount(machine.currentMainStep);
//         for (var i = 0; i < maxSteps; i++) {
//             if (!machine.subStepsCompleted[i]) return false;
//         }
//         return true;
//     }

//     // Helper function to advance main step (used as fallback)
//     function advanceMainStep(machineIndex) {
//         var machine = machineProgressData[machineIndex];

//         if (machine.currentMainStep < 3) { // 0,1,2,3 = A,B,C,D
//             machine.currentMainStep++;
//             // Reset sub-steps for next main step
//             machine.subStepsCompleted = [false, false, false, false, false];

//             // Update operation status
//             machine.operationStatus[machine.currentMainStep - 1] = true;
//         } else {
//             // All main steps completed
//             machine.isComplete = true;
//             machine.operationStatus[3] = true; // Mark OP-4 as complete
//             machine.isAutoProgressRunning = false; // Stop auto progress
//         }

//         // Trigger UI update
//         machineProgressData = machineProgressData;
//     }

//     // Function to advance sub-progress
//     function toggleSubStep(machineIndex, subIndex) {
//         var machine = machineProgressData[machineIndex];
//         var maxSteps = getCurrentSubStepsCount(machine.currentMainStep);

//         // Only allow toggling within the current step's range
//         if (subIndex >= maxSteps) return;

//         // Toggle the sub-step
//         machine.subStepsCompleted[subIndex] = !machine.subStepsCompleted[subIndex];

//         // Trigger UI update first to show the checkmark
//         machineProgressData = machineProgressData;

//         // Check if all sub-steps are now completed
//         if (areAllSubStepsCompleted(machineIndex)) {
//             // Create a timer to delay advancing to the next step
//             // This gives time for the UI to show the last checkmark
//             var timerComponent = Qt.createQmlObject('
//                 import QtQuick 2.15
//                 Timer {
//                     interval: 800
//                     repeat: false
//                     running: true
//                     onTriggered: {
//                         parent.advanceAfterDelay(' + machineIndex + ')
//                         destroy()
//                     }
//                 }', mainContainer, "delayTimer");
//         }
//     }

//     // Function called after delay to advance main step
//     function advanceAfterDelay(machineIndex) {
//         var machine = machineProgressData[machineIndex];

//         // Advance main progress after delay
//         if (machine.currentMainStep < 3) { // 0,1,2,3 = A,B,C,D
//             machine.currentMainStep++;
//             // Reset sub-steps for next main step
//             machine.subStepsCompleted = [false, false, false, false, false];

//             // Update operation status
//             machine.operationStatus[machine.currentMainStep - 1] = true;
//         } else {
//             // All main steps completed
//             machine.isComplete = true;
//             machine.operationStatus[3] = true; // Mark OP-4 as complete
//             machine.isAutoProgressRunning = false; // Stop auto progress
//         }

//         // Trigger UI update
//         machineProgressData = machineProgressData;
//     }

//     // Function to advance to next incomplete sub-step
//     function advanceNextSubStep(machineIndex) {
//         var machine = machineProgressData[machineIndex];

//         if (machine.isComplete) return;

//         var maxSteps = getCurrentSubStepsCount(machine.currentMainStep);

//         // Find next incomplete sub-step
//         for (var i = 0; i < maxSteps; i++) {
//             if (!machine.subStepsCompleted[i]) {
//                 toggleSubStep(machineIndex, i);
//                 break;
//             }
//         }
//     }

//     // Function to go back one sub-step
//     function goBackSubStep(machineIndex) {
//         var machine = machineProgressData[machineIndex];

//         // If we're at the beginning of a main step and there's a previous main step
//         if (getCompletedSubSteps(machineIndex) === 0 && machine.currentMainStep > 0) {
//             machine.currentMainStep--;
//             var prevMaxSteps = getCurrentSubStepsCount(machine.currentMainStep);
//             // Set all sub-steps as completed for previous step
//             for (var i = 0; i < 5; i++) {
//                 machine.subStepsCompleted[i] = i < prevMaxSteps;
//             }
//             machine.operationStatus[machine.currentMainStep] = false;
//             machine.isComplete = false;
//         } else {
//             // Find last completed sub-step and uncomplete it
//             var maxSteps = getCurrentSubStepsCount(machine.currentMainStep);
//             for (var i = maxSteps - 1; i >= 0; i--) {
//                 if (machine.subStepsCompleted[i]) {
//                     machine.subStepsCompleted[i] = false;
//                     break;
//                 }
//             }
//         }

//         machineProgressData = machineProgressData;
//     }

//     // Function to reset progress
//     function resetProgress(machineIndex) {
//         var machine = machineProgressData[machineIndex];
//         machine.currentMainStep = 0;
//         machine.subStepsCompleted = [false, false, false, false, false];
//         machine.operationStatus = [false, false, false, false];
//         machine.parameters = [false, false, false, false, false, false];
//         machine.isComplete = false;
//         machine.isAutoProgressRunning = false;
//         machineProgressData = machineProgressData;
//     }

//     // Function to start/stop auto progress
//     function toggleAutoProgress(machineIndex) {
//         var machine = machineProgressData[machineIndex];
//         machine.isAutoProgressRunning = !machine.isAutoProgressRunning;
//         machineProgressData = machineProgressData;
//     }

//     // Get current step name
//     function getCurrentStepName(machineIndex) {
//         var machine = machineProgressData[machineIndex];
//         var stepNames = ["A", "B", "C", "D"];
//         if (machine.isComplete) return "Complete";
//         return stepNames[machine.currentMainStep];
//     }

//     // Smooth height transition
//     Behavior on implicitHeight {
//         NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
//     }

//     Column {
//         id: contentColumn
//         anchors.left: parent.left
//         anchors.right: parent.right
//         anchors.top: parent.top
//         anchors.margins: 15
//         spacing: 10

//         // Header with title and close button
//         Rectangle {
//             width: parent.width
//             height: 40
//             color: "#2a2a2a"

//             Row {
//                 anchors.left: parent.left
//                 anchors.leftMargin: 15
//                 anchors.verticalCenter: parent.verticalCenter
//                 spacing: 10

//                 Text {
//                     text: "Machine Tubes"
//                     font.pixelSize: 16
//                     font.bold: true
//                     color: "#ffffff"
//                     anchors.verticalCenter: parent.verticalCenter
//                 }
//             }

//             // Close button
//             Rectangle {
//                 width: 30
//                 height: 30
//                 anchors.right: parent.right
//                 anchors.rightMargin: 5
//                 anchors.verticalCenter: parent.verticalCenter
//                 color: closeMouseArea.containsMouse ? "#f44336" : "transparent"
//                 radius: 3

//                 Text {
//                     anchors.centerIn: parent
//                     text: "✕"
//                     font.pixelSize: 16
//                     color: "#ffffff"
//                     font.bold: true
//                 }

//                 MouseArea {
//                     id: closeMouseArea
//                     anchors.fill: parent
//                     hoverEnabled: true
//                     onClicked: closeRequested()
//                 }
//             }
//         }

//         // Machine tabs
//         Repeater {
//             model: 6
//             delegate: MachineTab {
//                 width: parent.width
//                 machineIndex: index
//                 isOpen: currentOpenMachine === index
//                 onToggleOpen: {
//                     if (currentOpenMachine === index) {
//                         currentOpenMachine = -1
//                     } else {
//                         currentOpenMachine = index
//                     }
//                 }
//                 onAdvanceNext: advanceNextSubStep(index)
//                 onGoBack: goBackSubStep(index)
//                 onReset: resetProgress(index)
//                 onToggleAuto: toggleAutoProgress(index)

//                 // Data bindings
//                 machineName: "Machine " + (index + 1)
//                 currentStepName: getCurrentStepName(index)
//                 completedSubSteps: getCompletedSubSteps(index)
//                 maxSubSteps: getCurrentSubStepsCount(machineProgressData[index] ? machineProgressData[index].currentMainStep : 0)
//                 isComplete: machineProgressData[index] ? machineProgressData[index].isComplete : false
//                 isAutoRunning: machineProgressData[index] ? machineProgressData[index].isAutoProgressRunning : false
//                 currentMainStep: machineProgressData[index] ? machineProgressData[index].currentMainStep : 0
//                 subStepsCompleted: machineProgressData[index] ? machineProgressData[index].subStepsCompleted : [false, false, false, false, false]
//                 operationStatus: machineProgressData[index] ? machineProgressData[index].operationStatus : [false, false, false, false]
//                 parameters: machineProgressData[index] ? machineProgressData[index].parameters : [false, false, false, false, false, false]

//                 // Event handlers
//                 onSubStepToggled: toggleSubStep(index, subIndex)
//                 onParameterToggled: {
//                     machineProgressData[index].parameters[paramIndex] = !machineProgressData[index].parameters[paramIndex];
//                     machineProgressData = machineProgressData;
//                 }
//             }
//         }
//     }
// }

import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: mainContainer
    width: 348
    height: implicitHeight
    implicitHeight: contentColumn.implicitHeight + 30

    color: "#1e1e1e"
    border.color: "#333333"
    border.width: 1

    property int currentOpenMachine: -1

    // Signal for close button
    signal closeRequested()

    // Define sub-steps for each main step
    property var subStepsConfig: {
        "A": 4,  // Step A has 4 sub-steps
        "B": 5,  // Step B has 5 sub-steps
        "C": 2,  // Step C has 2 sub-steps
        "D": 2   // Step D has 2 sub-steps
    }

    // Progress data structure for each machine
    property var machineProgressData: {
        var data = {};
        for (var i = 0; i < 6; i++) {
            data[i] = {
                currentMainStep: 0,  // 0=A, 1=B, 2=C, 3=D
                subStepsCompleted: [false, false, false, false, false], // Max 5 sub-steps
                operationStatus: [false, false, false, false],
                parameters: [false, false, false, false, false, false],
                isComplete: false,
                isAutoProgressRunning: false,
                // NEW: Status tracking properties
                lastToggledSubStep: -1,
                launchStateText: "A in Progress",
                tubeStateText: "A in Progress",
                weaponStateText: "No Sequence"
            };
        }
        return data;
    }

    // Function to get current sub-steps count for a main step
    function getCurrentSubStepsCount(mainStep) {
        var stepNames = ["A", "B", "C", "D"];
        var stepName = stepNames[mainStep];
        return subStepsConfig[stepName] || 5;
    }

    // Function to get completed sub-steps count
    function getCompletedSubSteps(machineIndex) {
        var machine = machineProgressData[machineIndex];
        var maxSteps = getCurrentSubStepsCount(machine.currentMainStep);
        var count = 0;
        for (var i = 0; i < maxSteps; i++) {
            if (machine.subStepsCompleted[i]) count++;
        }
        return count;
    }

    // Function to check if all sub-steps are completed for current main step
    function areAllSubStepsCompleted(machineIndex) {
        var machine = machineProgressData[machineIndex];
        var maxSteps = getCurrentSubStepsCount(machine.currentMainStep);
        for (var i = 0; i < maxSteps; i++) {
            if (!machine.subStepsCompleted[i]) return false;
        }
        return true;
    }

    // NEW: Function to update status based on sub-step changes
    function updateStatusFromSubStep(machineIndex, subIndex, isCompleted) {
        var machine = machineProgressData[machineIndex];
        var stepNames = ["A", "B", "C", "D"];
        var currentMainStepName = stepNames[machine.currentMainStep];
        var maxSteps = getCurrentSubStepsCount(machine.currentMainStep);

        // Update last toggled sub-step
        machine.lastToggledSubStep = subIndex;

        // Update launch state text
        if (isCompleted) {
            machine.launchStateText = currentMainStepName + " P" + (subIndex + 1) + " Completed";
        } else {
            machine.launchStateText = currentMainStepName + " P" + (subIndex + 1) + " In Progress";
        }

        // Update tube state text
        machine.tubeStateText = currentMainStepName + " Step " + (subIndex + 1) + "/" + maxSteps;

        // Update weapon state text based on main step
        if (machine.currentMainStep < 2) { // A or B
            machine.weaponStateText = "No Sequence";
        } else if (machine.currentMainStep === 2) { // C
            machine.weaponStateText = "Sequence Initiated - P" + (subIndex + 1);
        } else if (machine.currentMainStep === 3) { // D
            machine.weaponStateText = "Sequence Active - P" + (subIndex + 1);
        }

        if (machine.isComplete) {
            machine.launchStateText = "Complete";
            machine.tubeStateText = "Ready";
            machine.weaponStateText = "Sequence Complete";
        }

        // Trigger UI update
        machineProgressData = machineProgressData;
    }

    // Helper function to advance main step
    function advanceMainStep(machineIndex) {
        var machine = machineProgressData[machineIndex];

        if (machine.currentMainStep < 3) { // 0,1,2,3 = A,B,C,D
            machine.currentMainStep++;
            // Reset sub-steps for next main step
            machine.subStepsCompleted = [false, false, false, false, false];

            // Update operation status
            machine.operationStatus[machine.currentMainStep - 1] = true;

            // Update status texts for new main step
            var stepNames = ["A", "B", "C", "D"];
            var newStepName = stepNames[machine.currentMainStep];
            machine.launchStateText = newStepName + " in Progress";
            machine.tubeStateText = newStepName + " in Progress";

            if (machine.currentMainStep === 2) { // C
                machine.weaponStateText = "Sequence Initiated";
            } else if (machine.currentMainStep === 3) { // D
                machine.weaponStateText = "Sequence Active";
            }
        } else {
            // All main steps completed
            machine.isComplete = true;
            machine.operationStatus[3] = true; // Mark OP-4 as complete
            machine.isAutoProgressRunning = false; // Stop auto progress

            // Update status texts for completion
            machine.launchStateText = "Complete";
            machine.tubeStateText = "Ready";
            machine.weaponStateText = "Sequence Complete";
        }

        // Trigger UI update
        machineProgressData = machineProgressData;
    }

    // Function to advance sub-progress
    function toggleSubStep(machineIndex, subIndex) {
        var machine = machineProgressData[machineIndex];
        var maxSteps = getCurrentSubStepsCount(machine.currentMainStep);

        // Only allow toggling within the current step's range
        if (subIndex >= maxSteps) return;

        // Toggle the sub-step
        var newState = !machine.subStepsCompleted[subIndex];
        machine.subStepsCompleted[subIndex] = newState;

        // Update status based on the change
        updateStatusFromSubStep(machineIndex, subIndex, newState);

        // Trigger UI update first to show the checkmark
        machineProgressData = machineProgressData;

        // Check if all sub-steps are now completed
        if (areAllSubStepsCompleted(machineIndex)) {
            // Create a timer to delay advancing to the next step
            // This gives time for the UI to show the last checkmark
            var timerComponent = Qt.createQmlObject('
                import QtQuick 2.15
                Timer {
                    interval: 800
                    repeat: false
                    running: true
                    onTriggered: {
                        parent.advanceAfterDelay(' + machineIndex + ')
                        destroy()
                    }
                }', mainContainer, "delayTimer");
        }
    }

    // Function called after delay to advance main step
    function advanceAfterDelay(machineIndex) {
        advanceMainStep(machineIndex);
    }

    // Function to advance to next incomplete sub-step
    function advanceNextSubStep(machineIndex) {
        var machine = machineProgressData[machineIndex];

        if (machine.isComplete) return;

        var maxSteps = getCurrentSubStepsCount(machine.currentMainStep);

        // Find next incomplete sub-step
        for (var i = 0; i < maxSteps; i++) {
            if (!machine.subStepsCompleted[i]) {
                // Update status before toggling
                updateStatusFromSubStep(machineIndex, i, true);
                toggleSubStep(machineIndex, i);
                break;
            }
        }
    }

    // Function to go back one sub-step
    function goBackSubStep(machineIndex) {
        var machine = machineProgressData[machineIndex];

        // If we're at the beginning of a main step and there's a previous main step
        if (getCompletedSubSteps(machineIndex) === 0 && machine.currentMainStep > 0) {
            machine.currentMainStep--;
            var prevMaxSteps = getCurrentSubStepsCount(machine.currentMainStep);
            // Set all sub-steps as completed for previous step
            for (var i = 0; i < 5; i++) {
                machine.subStepsCompleted[i] = i < prevMaxSteps;
            }
            machine.operationStatus[machine.currentMainStep] = false;
            machine.isComplete = false;

            // Update status texts for previous main step
            var stepNames = ["A", "B", "C", "D"];
            var prevStepName = stepNames[machine.currentMainStep];
            machine.launchStateText = prevStepName + " Complete";
            machine.tubeStateText = prevStepName + " Step " + prevMaxSteps + "/" + prevMaxSteps;

            if (machine.currentMainStep < 2) { // A or B
                machine.weaponStateText = "No Sequence";
            } else if (machine.currentMainStep === 2) { // C
                machine.weaponStateText = "Sequence Initiated - Complete";
            }
        } else {
            // Find last completed sub-step and uncomplete it
            var maxSteps = getCurrentSubStepsCount(machine.currentMainStep);
            for (var i = maxSteps - 1; i >= 0; i--) {
                if (machine.subStepsCompleted[i]) {
                    // Update status before uncompleting
                    updateStatusFromSubStep(machineIndex, i, false);
                    machine.subStepsCompleted[i] = false;
                    break;
                }
            }
        }

        machineProgressData = machineProgressData;
    }

    // Function to reset progress
    function resetProgress(machineIndex) {
        var machine = machineProgressData[machineIndex];
        machine.currentMainStep = 0;
        machine.subStepsCompleted = [false, false, false, false, false];
        machine.operationStatus = [false, false, false, false];
        machine.parameters = [false, false, false, false, false, false];
        machine.isComplete = false;
        machine.isAutoProgressRunning = false;

        // Reset status texts
        machine.launchStateText = "A in Progress";
        machine.tubeStateText = "A in Progress";
        machine.weaponStateText = "No Sequence";
        machine.lastToggledSubStep = -1;

        machineProgressData = machineProgressData;
    }

    // Function to start/stop auto progress
    function toggleAutoProgress(machineIndex) {
        var machine = machineProgressData[machineIndex];
        machine.isAutoProgressRunning = !machine.isAutoProgressRunning;
        machineProgressData = machineProgressData;
    }

    // Get current step name
    function getCurrentStepName(machineIndex) {
        var machine = machineProgressData[machineIndex];
        var stepNames = ["A", "B", "C", "D"];
        if (machine.isComplete) return "Complete";
        return stepNames[machine.currentMainStep];
    }

    // Smooth height transition
    Behavior on implicitHeight {
        NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
    }

    Column {
        id: contentColumn
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 15
        spacing: 10

        // Header with title and close button
        Rectangle {
            width: parent.width
            height: 40
            color: "#2a2a2a"
            border.color: "#444444"
            border.width: 1
            radius: 3

            Row {
                anchors.left: parent.left
                anchors.leftMargin: 15
                anchors.verticalCenter: parent.verticalCenter
                spacing: 10

                Text {
                    text: "Machine Tubes"
                    font.pixelSize: 16
                    font.bold: true
                    color: "#ffffff"
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            // Close button
            Rectangle {
                width: 30
                height: 30
                anchors.right: parent.right
                anchors.rightMargin: 5
                anchors.verticalCenter: parent.verticalCenter
                color: closeMouseArea.containsMouse ? "#f44336" : "transparent"
                radius: 3

                Text {
                    anchors.centerIn: parent
                    text: "✕"
                    font.pixelSize: 16
                    color: "#ffffff"
                    font.bold: true
                }

                MouseArea {
                    id: closeMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: closeRequested()
                }
            }
        }

        // Machine tabs
        Repeater {
            model: 6
            delegate: MachineTab {
                width: parent.width
                machineIndex: index
                isOpen: currentOpenMachine === index
                onToggleOpen: {
                    if (currentOpenMachine === index) {
                        currentOpenMachine = -1
                    } else {
                        currentOpenMachine = index
                    }
                }
                onAdvanceNext: advanceNextSubStep(index)
                onGoBack: goBackSubStep(index)
                onReset: resetProgress(index)
                onToggleAuto: toggleAutoProgress(index)

                // Data bindings
                machineName: "Machine " + (index + 1)
                currentStepName: getCurrentStepName(index)
                completedSubSteps: getCompletedSubSteps(index)
                maxSubSteps: getCurrentSubStepsCount(machineProgressData[index] ? machineProgressData[index].currentMainStep : 0)
                isComplete: machineProgressData[index] ? machineProgressData[index].isComplete : false
                isAutoRunning: machineProgressData[index] ? machineProgressData[index].isAutoProgressRunning : false
                currentMainStep: machineProgressData[index] ? machineProgressData[index].currentMainStep : 0
                subStepsCompleted: machineProgressData[index] ? machineProgressData[index].subStepsCompleted : [false, false, false, false, false]
                operationStatus: machineProgressData[index] ? machineProgressData[index].operationStatus : [false, false, false, false]
                parameters: machineProgressData[index] ? machineProgressData[index].parameters : [false, false, false, false, false, false]

                // NEW: Status text bindings
                launchStateText: machineProgressData[index] ? machineProgressData[index].launchStateText : "A in Progress"
                tubeStateText: machineProgressData[index] ? machineProgressData[index].tubeStateText : "A in Progress"
                weaponStateText: machineProgressData[index] ? machineProgressData[index].weaponStateText : "No Sequence"
                lastToggledSubStep: machineProgressData[index] ? machineProgressData[index].lastToggledSubStep : -1

                // Event handlers
                onSubStepToggled: toggleSubStep(index, subIndex)
                onParameterToggled: {
                    machineProgressData[index].parameters[paramIndex] = !machineProgressData[index].parameters[paramIndex];
                    machineProgressData = machineProgressData;
                }
            }
        }
    }
}
  */

// version v4. updated with state management
import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: mainContainer
    width: 348
    height: implicitHeight
    implicitHeight: contentColumn.implicitHeight + 30

    color: "#1e1e1e"
    border.color: "#333333"
    border.width: 1

    property int currentOpenMachine: -1

    // Signal for close button
    signal closeRequested()

    // Define sub-steps for each main step
    property var subStepsConfig: {
        "A": 4,  // Step A has 4 sub-steps
        "B": 5,  // Step B has 5 sub-steps
        "C": 2,  // Step C has 2 sub-steps
        "D": 2   // Step D has 2 sub-steps
    }

    // Progress data structure for each machine
    property var machineProgressData: {
        var data = {};
        for (var i = 0; i < 6; i++) {
            data[i] = {
                currentMainStep: 0,  // 0=A, 1=B, 2=C, 3=D
                subStepsCompleted: [false, false, false, false, false], // Max 5 sub-steps
                operationStatus: [false, false, false, false],
                parameters: [false, false, false, false, false, false],
                isComplete: false,
                isAutoProgressRunning: false,
                // NEW: Flag to control main step clickability
                isMainStepClickable: true,
                // NEW: Status tracking properties
                lastToggledSubStep: -1,
                launchStateText: "A in Progress",
                tubeStateText: "A in Progress",
                weaponStateText: "No Sequence"
            };
        }
        return data;
    }

    // Timer to automate sub-step progression
    Timer {
        id: autoSubStepTimer
        interval: 3000 // 3 seconds per sub-step
        repeat: false // Will be set to true when auto-running
        property int currentMachineIndex: -1
        property int currentSubStepToComplete: -1

        onTriggered: {
            var machine = mainContainer.machineProgressData[currentMachineIndex];
            if (machine && !machine.isComplete) {
                if (currentSubStepToComplete < mainContainer.getCurrentSubStepsCount(machine.currentMainStep)) {
                    // Mark the current sub-step as complete
                    machine.subStepsCompleted[currentSubStepToComplete] = true;
                    // Update status texts for the completed sub-step
                    mainContainer.updateStatusFromSubStep(currentMachineIndex, currentSubStepToComplete, true);
                    mainContainer.machineProgressData = mainContainer.machineProgressData; // Trigger UI update

                    currentSubStepToComplete++;

                    if (currentSubStepToComplete < mainContainer.getCurrentSubStepsCount(machine.currentMainStep)) {
                        // If there are more sub-steps, restart the timer for the next one
                        autoSubStepTimer.start();
                    } else {
                        // All sub-steps for the current main step are complete
                        console.log("All sub-steps for main step " + machine.currentMainStep + " completed for machine " + currentMachineIndex);
                        machine.isAutoProgressRunning = false; // Stop auto-progress
                        machine.isMainStepClickable = true; // Make the next main step clickable
                        mainContainer.machineProgressData = mainContainer.machineProgressData; // Trigger UI update

                        // Advance the main step after a short delay to ensure UI updates
                        Qt.callLater(mainContainer.advanceMainStep, currentMachineIndex);
                    }
                }
            } else {
                autoSubStepTimer.stop(); // Stop if machine is complete
            }
        }
    }

    // Function to get current sub-steps count for a main step
    function getCurrentSubStepsCount(mainStep) {
        var stepNames = ["A", "B", "C", "D"];
        var stepName = stepNames[mainStep];
        return subStepsConfig[stepName] || 5;
    }

    // Function to get completed sub-steps count
    function getCompletedSubSteps(machineIndex) {
        var machine = machineProgressData[machineIndex];
        if (!machine) return 0; // Handle case where machineProgressData[index] might be undefined initially
        var maxSteps = getCurrentSubStepsCount(machine.currentMainStep);
        var count = 0;
        for (var i = 0; i < maxSteps; i++) {
            if (machine.subStepsCompleted[i]) count++;
        }
        return count;
    }

    // Function to check if all sub-steps are now completed for current main step
    function areAllSubStepsCompleted(machineIndex) {
        var machine = machineProgressData[machineIndex];
        if (!machine) return false;
        var maxSteps = getCurrentSubStepsCount(machine.currentMainStep);
        for (var i = 0; i < maxSteps; i++) {
            if (!machine.subStepsCompleted[i]) return false;
        }
        return true;
    }

    // NEW: Function to handle main step click
    function onMainStepClicked(machineIndex, mainStepIndex) {
        var machine = machineProgressData[machineIndex];

        // Ensure it's the current active main step and it's clickable
        if (machine && mainStepIndex === machine.currentMainStep && machine.isMainStepClickable && !machine.isComplete) {
            console.log("Main step " + mainStepIndex + " clicked for machine " + machineIndex);

            // Disable main step clickability and start auto-progress
            machine.isMainStepClickable = false;
            machine.isAutoProgressRunning = true;
            machineProgressData = machineProgressData; // Trigger UI update

            // Reset sub-steps completed array for the current main step if needed
            // This ensures we start from fresh for auto-completion.
            for (var i = 0; i < getCurrentSubStepsCount(machine.currentMainStep); i++) {
                machine.subStepsCompleted[i] = false;
            }

            // Start the auto-progression timer for sub-steps
            autoSubStepTimer.currentMachineIndex = machineIndex;
            autoSubStepTimer.currentSubStepToComplete = 0; // Start from the first sub-step
            autoSubStepTimer.repeat = false; // We'll manually chain triggers or use a loop
            autoSubStepTimer.start();
        } else {
            console.log("Main step " + mainStepIndex + " not clickable or already completed for machine " + machineIndex);
        }
    }


    // NEW: Function to update status based on sub-step changes
    function updateStatusFromSubStep(machineIndex, subIndex, isCompleted) {
        var machine = machineProgressData[machineIndex];
        var stepNames = ["A", "B", "C", "D"];
        var currentMainStepName = stepNames[machine.currentMainStep];
        var maxSteps = getCurrentSubStepsCount(machine.currentMainStep);

        // Update last toggled sub-step
        machine.lastToggledSubStep = subIndex;

        // Update launch state text
        if (isCompleted) {
            machine.launchStateText = currentMainStepName + " P" + (subIndex + 1) + " Completed";
        } else {
            machine.launchStateText = currentMainStepName + " P" + (subIndex + 1) + " In Progress";
        }

        // Update tube state text
        machine.tubeStateText = currentMainStepName + " Step " + (subIndex + 1) + "/" + maxSteps;

        // Update weapon state text based on main step
        if (machine.currentMainStep < 2) { // A or B
            machine.weaponStateText = "No Sequence";
        } else if (machine.currentMainStep === 2) { // C
            machine.weaponStateText = "Sequence Initiated - P" + (subIndex + 1);
        } else if (machine.currentMainStep === 3) { // D
            machine.weaponStateText = "Sequence Active - P" + (subIndex + 1);
        }

        if (machine.isComplete) {
            machine.launchStateText = "Complete";
            machine.tubeStateText = "Ready";
            machine.weaponStateText = "Sequence Complete";
        }

        // Trigger UI update
        // machineProgressData = machineProgressData; // This line is often redundant if properties are bound correctly.
                                                   // However, for direct manipulation of nested objects, it helps.
    }

    // Helper function to advance main step
    function advanceMainStep(machineIndex) {
        var machine = machineProgressData[machineIndex];

        if (machine.currentMainStep < 3) { // 0,1,2,3 = A,B,C,D
            machine.currentMainStep++;
            // Reset sub-steps for next main step
            machine.subStepsCompleted = [false, false, false, false, false];

            // Update operation status
            machine.operationStatus[machine.currentMainStep - 1] = true;

            // Update status texts for new main step
            var stepNames = ["A", "B", "C", "D"];
            var newStepName = stepNames[machine.currentMainStep];
            machine.launchStateText = newStepName + " in Progress";
            machine.tubeStateText = newStepName + " in Progress";

            if (machine.currentMainStep === 2) { // C
                machine.weaponStateText = "Sequence Initiated";
            } else if (machine.currentMainStep === 3) { // D
                machine.weaponStateText = "Sequence Active";
            }
            machine.isMainStepClickable = true; // Make the new main step clickable
        } else {
            // All main steps completed
            machine.isComplete = true;
            machine.operationStatus[3] = true; // Mark OP-4 as complete
            machine.isAutoProgressRunning = false; // Stop auto progress
            machine.isMainStepClickable = false; // No more main steps to click

            // Update status texts for completion
            machine.launchStateText = "Complete";
            machine.tubeStateText = "Ready";
            machine.weaponStateText = "Sequence Complete";
        }

        // Trigger UI update
        machineProgressData = machineProgressData;
    }

    // REMOVED: toggleSubStep function as it's no longer user-driven.
    // The autoSubStepTimer will handle marking sub-steps complete.

    // Function to advance to next incomplete sub-step (now only for programmatic use)
    function advanceNextSubStep(machineIndex) {
        var machine = machineProgressData[machineIndex];
        if (!machine || machine.isComplete || machine.isAutoProgressRunning) return; // Prevent manual advance during auto-run

        var maxSteps = getCurrentSubStepsCount(machine.currentMainStep);
        for (var i = 0; i < maxSteps; i++) {
            if (!machine.subStepsCompleted[i]) {
                machine.subStepsCompleted[i] = true; // Mark as complete
                updateStatusFromSubStep(machineIndex, i, true); // Update status text
                if (areAllSubStepsCompleted(machineIndex)) {
                     // If all sub-steps are done, advance main step after a short delay
                    Qt.callLater(advanceMainStep, machineIndex);
                }
                break;
            }
        }
        machineProgressData = machineProgressData; // Trigger UI update
    }

    // Function to go back one sub-step (still manual)
    function goBackSubStep(machineIndex) {
        var machine = machineProgressData[machineIndex];
        if (machine.isAutoProgressRunning) return; // Prevent manual back during auto-run

        // If we're at the beginning of a main step and there's a previous main step
        if (getCompletedSubSteps(machineIndex) === 0 && machine.currentMainStep > 0) {
            machine.currentMainStep--;
            var prevMaxSteps = getCurrentSubStepsCount(machine.currentMainStep);
            // Set all sub-steps as completed for previous step
            for (var i = 0; i < 5; i++) {
                machine.subStepsCompleted[i] = i < prevMaxSteps;
            }
            machine.operationStatus[machine.currentMainStep] = false;
            machine.isComplete = false;
            machine.isMainStepClickable = true; // Make current main step clickable again

            // Update status texts for previous main step
            var stepNames = ["A", "B", "C", "D"];
            var prevStepName = stepNames[machine.currentMainStep];
            machine.launchStateText = prevStepName + " Complete";
            machine.tubeStateText = prevStepName + " Step " + prevMaxSteps + "/" + prevMaxSteps;

            if (machine.currentMainStep < 2) { // A or B
                machine.weaponStateText = "No Sequence";
            } else if (machine.currentMainStep === 2) { // C
                machine.weaponStateText = "Sequence Initiated - Complete";
            }
        } else {
            // Find last completed sub-step and uncomplete it
            var maxSteps = getCurrentSubStepsCount(machine.currentMainStep);
            for (var i = maxSteps - 1; i >= 0; i--) {
                if (machine.subStepsCompleted[i]) {
                    // Update status before uncompleting
                    updateStatusFromSubStep(machineIndex, i, false);
                    machine.subStepsCompleted[i] = false;
                    break;
                }
            }
        }

        machineProgressData = machineProgressData;
    }

    // Function to reset progress
    function resetProgress(machineIndex) {
        var machine = machineProgressData[machineIndex];
        machine.currentMainStep = 0;
        machine.subStepsCompleted = [false, false, false, false, false];
        machine.operationStatus = [false, false, false, false];
        machine.parameters = [false, false, false, false, false, false];
        machine.isComplete = false;
        machine.isAutoProgressRunning = false;
        machine.isMainStepClickable = true; // Reset clickability

        // Reset status texts
        machine.launchStateText = "A in Progress";
        machine.tubeStateText = "A in Progress";
        machine.weaponStateText = "No Sequence";
        machine.lastToggledSubStep = -1;

        // Stop auto-progress timer if it's running for this machine
        if (autoSubStepTimer.currentMachineIndex === machineIndex) {
            autoSubStepTimer.stop();
        }

        machineProgressData = machineProgressData;
    }

    // Function to start/stop auto progress (now only for external control, internal is by main step click)
    function toggleAutoProgress(machineIndex) {
        // This function might be less relevant now, as auto-progress is tied to main step clicks.
        // You might consider removing it or re-purposing it if you need a "pause/play" for the auto sequence.
        // For now, it will simply toggle the flag. The actual auto-progression is managed by onMainStepClicked.
        var machine = machineProgressData[machineIndex];
        machine.isAutoProgressRunning = !machine.isAutoProgressRunning;
        machineProgressData = machineProgressData;
        console.log("Toggle auto progress called, but logic is now driven by main step clicks.");
    }

    // Get current step name
    function getCurrentStepName(machineIndex) {
        var machine = machineProgressData[machineIndex];
        if (!machine) return "N/A"; // Handle undefined case
        var stepNames = ["A", "B", "C", "D"];
        if (machine.isComplete) return "Complete";
        return stepNames[machine.currentMainStep];
    }

    // Smooth height transition
    Behavior on implicitHeight {
        NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
    }

    Column {
        id: contentColumn
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 15
        spacing: 10

        // Header with title and close button
        Rectangle {
            width: parent.width
            height: 40
            color: "#2a2a2a"
            border.color: "#444444"
            border.width: 1
            radius: 3

            Row {
                anchors.left: parent.left
                anchors.leftMargin: 15
                anchors.verticalCenter: parent.verticalCenter
                spacing: 10

                Text {
                    text: "Machine Tubes"
                    font.pixelSize: 16
                    font.bold: true
                    color: "#ffffff"
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            // Close button
            Rectangle {
                width: 30
                height: 30
                anchors.right: parent.right
                anchors.rightMargin: 5
                anchors.verticalCenter: parent.verticalCenter
                color: closeMouseArea.containsMouse ? "#f44336" : "transparent"
                radius: 3

                Text {
                    anchors.centerIn: parent
                    text: "✕"
                    font.pixelSize: 16
                    color: "#ffffff"
                    font.bold: true
                }

                MouseArea {
                    id: closeMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: closeRequested()
                }
            }
        }

        // Machine tabs
        Repeater {
            model: 6
            delegate: MachineTab {
                width: parent.width
                machineIndex: index
                isOpen: currentOpenMachine === index
                onToggleOpen: {
                    if (currentOpenMachine === index) {
                        currentOpenMachine = -1
                    } else {
                        currentOpenMachine = index
                    }
                }
                // REMOVED: onAdvanceNext and onSubStepToggled are no longer directly triggered by user
                onGoBack: goBackSubStep(index)
                onReset: resetProgress(index)
                // NEW: Connect to MainProgressBar's mainStepClicked signal
                onMainStepClicked: mainContainer.onMainStepClicked(machineIndex, mainStepIndex)

                // Data bindings
                machineName: "Machine " + (index + 1)
                currentStepName: getCurrentStepName(index)
                completedSubSteps: getCompletedSubSteps(index)
                maxSubSteps: getCurrentSubStepsCount(machineProgressData[index] ? machineProgressData[index].currentMainStep : 0)
                isComplete: machineProgressData[index] ? machineProgressData[index].isComplete : false
                isAutoRunning: machineProgressData[index] ? machineProgressData[index].isAutoProgressRunning : false
                currentMainStep: machineProgressData[index] ? machineProgressData[index].currentMainStep : 0
                subStepsCompleted: machineProgressData[index] ? machineProgressData[index].subStepsCompleted : [false, false, false, false, false]
                operationStatus: machineProgressData[index] ? machineProgressData[index].operationStatus : [false, false, false, false]
                parameters: machineProgressData[index] ? machineProgressData[index].parameters : [false, false, false, false, false, false]
                // NEW: Pass the main step clickability to MainProgressBar
                mainStepClickable: machineProgressData[index] ? machineProgressData[index].isMainStepClickable : true

                // NEW: Status text bindings
                launchStateText: machineProgressData[index] ? machineProgressData[index].launchStateText : "A in Progress"
                tubeStateText: machineProgressData[index] ? machineProgressData[index].tubeStateText : "A in Progress"
                weaponStateText: machineProgressData[index] ? machineProgressData[index].weaponStateText : "No Sequence"
                lastToggledSubStep: machineProgressData[index] ? machineProgressData[index].lastToggledSubStep : -1

                // Event handlers for other interactions
                onParameterToggled: {
                    machineProgressData[index].parameters[paramIndex] = !machineProgressData[index].parameters[paramIndex];
                    machineProgressData = machineProgressData; // Trigger UI update
                }
            }
        }
    }
}
