import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15



Window {
    visible: true
    width: 640
    height: 480
    title: "Infinite Math Test"
    minimumWidth: 640
    maximumWidth: 640
    minimumHeight: 480
    maximumHeight: 480
    Text {
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignBottom
        padding: 13
        font.pointSize: 15
        font.family: "Courier New"
        font.italic: true
        text: "by teshay"
        color: "gray"
    }
    CheckBox {
        checked: false
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 170
        anchors.horizontalCenterOffset: -90
        onCheckedChanged: {
            backend.enable_screen_numbers(checked)
        }
    }
    Text {
        objectName: "check_box_text1"
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 170
        padding: 20
        font.pointSize: 15
        font.family: "Courier New"
        text: "Enable numpad"
        color: "black"
    }

    // темная тема
    CheckBox {
        checked: false
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 190
        anchors.horizontalCenterOffset: -90
        onCheckedChanged: {
            backend.enable_dark_theme(checked)
        }
    }
    Text {
        objectName: "check_box_text2"
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 190
        anchors.horizontalCenterOffset: -18
        padding: 20
        font.pointSize: 15
        font.family: "Courier New"
        text: "Dark theme"
        color: "black"
    }
    /////////////

    Item {
  
        anchors.centerIn: parent
        
        Column{
            anchors.centerIn: parent
            spacing: 10
            
        
            Row {
                objectName: "main_column"
                id: main_column
                anchors.centerIn: parent
                
                spacing: 10
                Text {
                    Layout.fillWidth: true
                    objectName: "example" 
                    font.pointSize: 40
                    font.family: "Consolas"
                    font.bold: true
                    text: ""
                }
                TextField {
                    Layout.fillWidth: true
                    id: userinput
                    objectName: "userinput"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    padding: 20
                    font.pointSize: 35
                    font.family: "Courier New"
                    font.bold: true
                    color: "black"
                    focus: true
                    background: Rectangle {
                        objectName: "userinput_background"
                        implicitWidth: 110
                        implicitHeight: 40
                        color: "white"
                    }
                    Keys.onReturnPressed: {
                        backend.check_answer(userinput.text)
                    }
                }
            }
            Text {
                objectName: "check_answer" 
                anchors.centerIn: parent
                anchors.verticalCenterOffset: 70
                font.pointSize: 35
                font.family: "Courier New"
                text: ""
            }
        }
    }



    GridLayout {
        objectName: "numpad"
        id: numpad
        columns: 3
        rowSpacing: 8
        columnSpacing: 8
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 50

        Repeater {
             model: ["1","2","3",
                "4","5","6",
                "7","8","9",
                "<", "0", "E"]

            Button {
                id: btn
                text: modelData
                font.pixelSize: 30
                padding: 10
                rightPadding: 15
                leftPadding: 15
                topPadding: 2
                bottomPadding: 2
                enabled: text !== ""   // пустые ячейки не кликаются
                opacity: text === "" ? 0 : 1   // и не видны
                contentItem: Text {
                    text: parent.text
                    color: "black"        // ← цвет текста
                    font.pixelSize: 24
                    anchors.centerIn: parent
                }
                background: Rectangle {
                    objectName: "numpad_buttons_background"
                    id: bg
                    radius: 8
                    color: btn.hovered ? "#777" : "white"
                    border.width: 1;
                    border.color: "black"; 
                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }
                }
                onClicked: {
                    console.log("Pressed:", text)
                    userinput.text += text !== "E" && text !== "<" ? text : ""

                    if (text === "<") 
                        userinput.text = userinput.text.slice(0, -1)

                    if (text === "E")
                        backend.check_answer(userinput.text)
                }
            }
        }
    }

}
