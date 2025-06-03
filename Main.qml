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
    height: machineComponent.height
    minimumHeight: 250
    maximumHeight: 800
    visible: true
    title: qsTr("Machine Tubes")

    MachineComp {
        id: machineComponent
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        onCloseRequested: {
            machineComponent.visible= false
        }
    }
}
