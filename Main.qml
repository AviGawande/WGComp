// import QtQuick
// import QtQuick.Window 2.15

// Window {
//     width: 348
//     height:  732
//     visible: true
//     title: qsTr("Hello World")

//     MachineComp{
//         anchors.fill:parent
//     }
// }


import QtQuick
import QtQuick.Window 2.15

Window {
    width: 348
    // Remove fixed height - let it size to content
    height: machineComponent.height
    // Set minimum height to prevent window from being too small
    minimumHeight: 250
    maximumHeight: 800
    visible: true
    title: qsTr("Hello World")

    MachineComp {
        id: machineComponent
        // Remove anchors.fill - let it size naturally
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
    }
}
