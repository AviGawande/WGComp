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
                isAutoProgressRunning: false
            };
        }
        return data;
    }

    // Function to get current sub-steps count for a main step
    function getCurrentSubStepsCount(mainStep) {
        var stepNames = ["A", "B", "C", "D"];
        var stepName = stepNames[mainStep];
        return subStepsConfig[stepName] || 5; // Default to 5 if not found
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

    // Helper function to advance main step (used as fallback)
    function advanceMainStep(machineIndex) {
        var machine = machineProgressData[machineIndex];

        if (machine.currentMainStep < 3) { // 0,1,2,3 = A,B,C,D
            machine.currentMainStep++;
            // Reset sub-steps for next main step
            machine.subStepsCompleted = [false, false, false, false, false];

            // Update operation status
            machine.operationStatus[machine.currentMainStep - 1] = true;
        } else {
            // All main steps completed
            machine.isComplete = true;
            machine.operationStatus[3] = true; // Mark OP-4 as complete
            machine.isAutoProgressRunning = false; // Stop auto progress
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
        machine.subStepsCompleted[subIndex] = !machine.subStepsCompleted[subIndex];

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
        var machine = machineProgressData[machineIndex];

        // Advance main progress after delay
        if (machine.currentMainStep < 3) { // 0,1,2,3 = A,B,C,D
            machine.currentMainStep++;
            // Reset sub-steps for next main step
            machine.subStepsCompleted = [false, false, false, false, false];

            // Update operation status
            machine.operationStatus[machine.currentMainStep - 1] = true;
        } else {
            // All main steps completed
            machine.isComplete = true;
            machine.operationStatus[3] = true; // Mark OP-4 as complete
            machine.isAutoProgressRunning = false; // Stop auto progress
        }

        // Trigger UI update
        machineProgressData = machineProgressData;
    }

    // Function to advance to next incomplete sub-step
    function advanceNextSubStep(machineIndex) {
        var machine = machineProgressData[machineIndex];

        if (machine.isComplete) return;

        var maxSteps = getCurrentSubStepsCount(machine.currentMainStep);

        // Find next incomplete sub-step
        for (var i = 0; i < maxSteps; i++) {
            if (!machine.subStepsCompleted[i]) {
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
        } else {
            // Find last completed sub-step and uncomplete it
            var maxSteps = getCurrentSubStepsCount(machine.currentMainStep);
            for (var i = maxSteps - 1; i >= 0; i--) {
                if (machine.subStepsCompleted[i]) {
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
