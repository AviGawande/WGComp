import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: mainContainer
    width: 348
    height: implicitHeight
    implicitHeight: contentColumn.implicitHeight + 30

    color: "#f0f0f0"
    border.color: "#333333"
    border.width: 1

    property int currentOpenMachine: -1

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
        spacing: 5

        // Machine tabs - only 6 tubes
        Repeater {
            model: 6
            delegate: Item {
                width: parent.width
                height: currentOpenMachine === index ? (37 + 440) : 37

                Behavior on height {
                    NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
                }

                Rectangle {
                    id: machineTab
                    width: parent.width
                    height: 37
                    color: currentOpenMachine === index ? "#e0e0e0" : "#ffffff"
                    border.color: "#333333"
                    border.width: 1

                    Row {
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 10

                        Text {
                            text: "Tube " + (index + 1)
                            font.pixelSize: 14
                            font.bold: true
                            color: "#333333"
                        }
                    }

                    // Dropdown arrow
                    Text {
                        anchors.right: parent.right
                        anchors.rightMargin: 15
                        anchors.verticalCenter: parent.verticalCenter
                        text: "˅"
                        font.pixelSize: 12
                        color: "#333333"
                        rotation: currentOpenMachine === index ? 180 : 0
                        Behavior on rotation {
                            NumberAnimation { duration: 300 }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (currentOpenMachine === index) {
                                currentOpenMachine = -1
                            } else {
                                currentOpenMachine = index
                            }
                        }
                    }
                }

                // Dropdown content
                Rectangle {
                    id: dropdownContent
                    width: parent.width
                    height: 440
                    y: 37
                    color: "#ffffff"
                    border.color: "#333333"
                    border.width: 1
                    visible: currentOpenMachine === index
                    opacity: currentOpenMachine === index ? 1 : 0
                    clip: true

                    Behavior on opacity {
                        NumberAnimation { duration: 300 }
                    }

                    Column {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 15

                        // Name section
                        Row {
                            width: parent.width
                            spacing: 10
                            Text {
                                text: "Tube "+ (index+1)
                                font.pixelSize: 12
                                color: "#333333"
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            Rectangle {
                                width: 80
                                height: 20
                                border.color: "#333333"
                                border.width: 1
                                color: "#ffffff"

                                TextInput {
                                    anchors.fill: parent
                                    anchors.margins: 3
                                    font.pixelSize: 10
                                    verticalAlignment: TextInput.AlignVCenter
                                }
                            }
                        }

                        // Image section
                        Rectangle {
                            width: parent.width - 20
                            height: 60
                            border.color: "#333333"
                            border.width: 1
                            color: "#f8f8f8"

                            Text {
                                anchors.centerIn: parent
                                text: "Image"
                                font.pixelSize: 12
                                color: "#666666"
                            }
                        }

                        // Progress indicators section
                        Column {
                            width: parent.width
                            spacing: 8

                            // Progress bars with labels A, B, C, D
                            Row {
                                spacing: 8
                                Repeater {
                                    model: ["A", "B", "C", "D"]
                                    delegate: Column {
                                        spacing: 3
                                        Rectangle {
                                            width: 30
                                            height: 15
                                            border.color: "#333333"
                                            border.width: 1
                                            color: "#ffffff"
                                            Text {
                                                anchors.centerIn: parent
                                                text: modelData
                                                font.pixelSize: 8
                                            }
                                        }
                                    }
                                }
                            }

                            // Progress circles P1 to P5
                            Row {
                                spacing: 15
                                Text {
                                    text: "P1"
                                    font.pixelSize: 8
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                Text {
                                    text: "P2"
                                    font.pixelSize: 8
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                Text {
                                    text: "P3"
                                    font.pixelSize: 8
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                Text {
                                    text: "P4"
                                    font.pixelSize: 8
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                Text {
                                    text: "P5"
                                    font.pixelSize: 8
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }

                            Row {
                                spacing: 8
                                Repeater {
                                    model: 5
                                    delegate: Rectangle {
                                        width: 10
                                        height: 10
                                        radius: 5
                                        border.color: "#333333"
                                        border.width: 1
                                        color: "#ffffff"
                                    }
                                }
                            }

                            // Operation status indicators
                            Grid {
                                columns: 2
                                spacing: 5
                                rowSpacing: 5
                                columnSpacing: 20

                                Repeater {
                                    model: ["OP-1", "OP-2", "OP-3", "OP-4"]
                                    delegate: Row {
                                        spacing: 5
                                        Rectangle {
                                            width: 8
                                            height: 8
                                            radius: 4
                                            border.color: "#333333"
                                            border.width: 1
                                            color: "#ffffff"
                                        }
                                        Text {
                                            text: modelData
                                            font.pixelSize: 8
                                            color: "#333333"
                                            anchors.verticalCenter: parent.verticalCenter
                                        }
                                    }
                                }
                            }

                            // Parameters section
                            Text {
                                text: "Parameters"
                                font.pixelSize: 10
                                font.bold: true
                                color: "#333333"
                            }

                            Grid {
                                columns: 3
                                spacing: 5
                                rowSpacing: 5
                                columnSpacing: 10

                                Repeater {
                                    model: ["A", "B", "C", "D", "E", "F"]
                                    delegate: Row {
                                        spacing: 3
                                        Rectangle {
                                            width: 10
                                            height: 10
                                            border.color: "#333333"
                                            border.width: 1
                                            color: "#ffffff"
                                        }
                                        Text {
                                            text: modelData
                                            font.pixelSize: 8
                                            color: "#333333"
                                            anchors.verticalCenter: parent.verticalCenter
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
