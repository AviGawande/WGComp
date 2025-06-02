import QtQuick
import QtQuick.Window 2.15

Window {
    width: 348
    height:  732
    visible: true
    title: qsTr("Hello World")

    MachineComp{
        anchors.fill:parent
    }
}
