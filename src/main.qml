import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window
import QtQuick.Controls.Material 2.15

//Set "pragma ComponentBehavior: Bound"



Window {
    visible: true
    width: 640
    height: 480
    title: "Infinite Math Test"
    minimumWidth: 640
    maximumWidth: 640
    minimumHeight: 480
    maximumHeight: 480
    id: window

    Connections {
        target: backend
        function onTimer_changed(value) {
            timer.text = value.toString()
        }
    }
    property string theme: "Normal"
    function enable_normal_theme() {
        made_by_text.color = "black"
        example_text.color = "black"
        userinput.color = "black"
        settings.color = "white"
        window.color = "white"
        dark_theme_text.color = "black"
        userinput_background.color = "white"
        cross_image.source = "qrc:/qt/qml/infinite_math_test/cross.png"
        numpad_text.color = "black"
        stats_settings_text.color = "black"
        separator.color = "black"
        incorrect_percent_text.color = "black"
        streak_text.color = "black"
        timer_settings_text.color = "black"
        negative_num_settings_text.color = "black"
        brackets_settings_text.color = "black"
        brackets_text.color = "black"
        negative_numbers_text.color = "black"
        
        window.theme = "Normal"
        settings_button_icon.source = "qrc:/qt/qml/infinite_math_test/settings_icon.png"

        dark_theme_cb_background.border.color = "black" 
        stats_cb_background.border.color = "black" 
        negative_cb_background.border.color = "black" 
        brackets_cb_background.border.color = "black" 
        timer_cb_background.border.color = "black"
        numpad_cb_background.border.color = "black" 
        seconds_settings_text.color = "black"
        seconds_userinput_background.color = "white"
        seconds_userinput_background.border.color = "black"
        seconds_userinput.color = "black"
        
        dark_theme_cb_normal_background.color = "white"
        stats_cb_normal_background.color = "white"
        negative_cb_normal_background.color = "white"
        brackets_cb_normal_background.color = "white"
        timer_cb_normal_background.color = "white"
        numpad_cb_normal_background.color = "white"

        link.link_color = "red"

        if (rectangle_answer.color === "#303030") {
            rectangle_answer.color = "white"
        }
        
        right_answer.color = "black"

    }

    function enable_dark_theme() {
        made_by_text.color = "white"
        example_text.color = "white"
        userinput.color = "white"
        window.color = "#303030"
        settings.color = "#303030"
        dark_theme_text.color = "white"
        userinput_background.color = "#303030"
        cross_image.source = "qrc:/qt/qml/infinite_math_test/white_cross.png"
        numpad_text.color = "white"
        stats_settings_text.color = "white"
        separator.color = "white"
        incorrect_percent_text.color = "white"
        streak_text.color = "white"
        timer_settings_text.color = "white"
        negative_num_settings_text.color = "white"
        brackets_settings_text.color = "white"

        if (rectangle_answer.color === "white") {
            rectangle_answer.color = "#303030"
        }
        right_answer.color = "white"
        brackets_text.color = "white"
        negative_numbers_text.color = "white"

        window.theme = "Dark"
        settings_button_icon.source = "qrc:/qt/qml/infinite_math_test/settings_icon_black.png"

        dark_theme_cb_background.border.color = "white" 
        stats_cb_background.border.color = "white" 
        negative_cb_background.border.color = "white" 
        brackets_cb_background.border.color = "white" 
        timer_cb_background.border.color = "white"
        numpad_cb_background.border.color = "white" 
        seconds_settings_text.color = "white"
        seconds_userinput_background.color = "#303030"
        seconds_userinput.color = "white"


        dark_theme_cb_normal_background.color = "#303030"
        stats_cb_normal_background.color = "#303030"
        negative_cb_normal_background.color = "#303030"
        brackets_cb_normal_background.color = "#303030"
        timer_cb_normal_background.color = "#303030"
        numpad_cb_normal_background.color = "#303030"

        link.link_color = "#08D600"




        for (let i = 0; i < numpad.count; i++) {
            numpad.itemAt(i).contentItem.color = "red"
        }

       // numpad_button_background.color = "#303030"
       // numpad_button_text.color = "white"
        

       
    }
    

    function send_answer() {
        backend.check_answer(userinput.text)
    }



    ////////// MADE BY TEXT
    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.bottom
        anchors.verticalCenterOffset: -17
        bottomPadding: 2
        Row {
            Text {
                id: made_by_text
                text: "Made by "
                color: "black"
                font.pixelSize: 14
                font.letterSpacing: 0.4
            }
            Text {

                property string link_color: "red"
                id: link
                text: "teshay"
                color: link_color
                font.pixelSize: 14
                font.underline: false
                
                MouseArea {
                    anchors.fill: parent
                    
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onEntered:  {
                        link.font.underline = true
                        link.color = link.link_color
                    }
                    onExited: {
                        link.color = link.link_color
                        link.font.underline = false
                    }
                    onClicked: Qt.openUrlExternally("https://github.com/teshay-btw")
                }
            }
        }
    }
    ///////////////

    function set_the_answer(answer) {
        right_answer.text = answer
        right_answer.opacity = 1
    }
    function set_red_color() {
        rectangle_answer.color = "red"

    }
    function set_green_color() {
        rectangle_answer.color = "#08FF00"
    }


    //////// example

    Column{
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 40
        spacing: 0
        id: example 
        
        Row {

            objectName: "main_column"
            id: main_column

                

            Text {
                id: example_text
                objectName: "example" 
                font.pointSize: 40
                font.family: "Consolas"
                font.bold: true
                text: ""
                Behavior on x {
                    PropertyAnimation { duration: 100 }
                }
            }
            TextField {
                id: userinput
                objectName: "userinput"
                y: -5
                padding: 20
                font.pointSize: 40
                font.family: "Consolas"
                font.bold: true
                color: "black"
                focus: true
                background: Rectangle {
                    id: userinput_background
                    objectName: "userinput_background"
                    implicitWidth: 120
                    implicitHeight: 40
                    color: "white"
                }
                Keys.onReturnPressed: {
                    backend.check_answer(userinput.text)
                }
            }
        }
        Rectangle {
            id: rectangle_answer
            width: main_column.width
            height: 5
        }
        Text {
            id: right_answer
            anchors.horizontalCenter: parent.horizontalCenter
            objectName: "right_answer" 
            font.pointSize: 40
            font.family: "Consolas"
            opacity: 0
            text: "10"
        }
    }
    
    



    /////// NUMPAD
    GridLayout {
        objectName: "numpad"
        id: numpad
        columns: 5
        rowSpacing: -10
        columnSpacing: 4
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 160
        anchors.horizontalCenterOffset: -200
        
        Repeater {
             model: ["1","2","3", "4","5",
                    "6", "7","8","9", "0",
                    "","<", "E","-", ""]
            
            Button {
                id: numpad_button
                text: modelData
                font.pixelSize: 30
                padding: 10
                rightPadding: 10
                leftPadding: 10
                topPadding: 10
                bottomPadding: 10
                enabled: text !== ""   // пустые ячейки не кликаются
                opacity: text === "" ? 0 : 1   // и не видны
                contentItem: Text {
                    id: numpad_button_text
                    font.family: "Consolas"
                    text: parent.text
                    font.bold: true
                    color: { 
                        if (window.theme === "Normal")
                            numpad_button.hovered ? "white" : "black" 
                        else
                            numpad_button.hovered ? "#303030" : "white" 
                    }
                    font.pixelSize: 24
                    anchors.centerIn: parent
                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }
                }
                background: Rectangle {
                    objectName: "numpad_buttons_background"
                    id: numpad_button_background
                    radius: 3
                    color: { 
                        if (window.theme === "Normal")
                            numpad_button.hovered ? "black" : "white" 
                        else
                            numpad_button.hovered ? "white" : "#303030" 
                    }
                    border.width: 2;
                    border.color: { 
                        if (window.theme === "Normal")
                            return "black" 
                        else
                            return "white" 
                    }
                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }
                }
                onClicked: {
                    userinput.text += text !== "E" && text !== "<" ? text : ""

                    if (text === "<") 
                        userinput.text = userinput.text.slice(0, -1)

                    if (text === "E")
                        backend.check_answer(userinput.text)
                }
            }
        }
    }

    //////////////// STATS
    Column {
        visible: false
        id: stats
        topPadding: 10
        anchors.horizontalCenter: parent.horizontalCenter
        Row {
            spacing: 10
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                id: correct_number_text
                objectName: "correct_number_text"
                font.pointSize: 15
                font.letterSpacing: 1
                color: "#08D600" 
                
            }
            Text {
                id: separator
                font.pointSize: 15
                text: "/"
                font.letterSpacing: 1
                
            }
            Text {
                id: incorrect_number_text
                objectName: "incorrect_number_text"
                font.pointSize: 15
                font.letterSpacing: 1
                color: "red" 
                
            }
        }
        Row {
            spacing: 10
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                id: incorrect_percent_text
                font.pointSize: 15
                text: "Incorrect: "
                font.letterSpacing: 1
            }
            Text {
                id: incorrect_percent
                objectName: "incorrect_percent"
                font.pointSize: 15
                font.letterSpacing: 1
                color: "red"
                
            }
        }
        Row {
            spacing: 10
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                id: streak_text
                font.pointSize: 15
                text: "Streak: "
                font.letterSpacing: 1
            }
            Text {
                id: streak
                objectName: "streak"
                font.pointSize: 15
                font.letterSpacing: 1
                color: "#08D600"
                
            }
        }
         //////////  BRACKETS MODE
        Row {
            visible: false
            id: brackets_text_on
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                id: brackets_text
                font.pointSize: 15
                text: "Brackets: "
                font.letterSpacing: 1
            }
            Text {
                id: brackets_on
                font.pointSize: 15
                color: "#08D600"
                y: 1
                text: "ON"
                font.letterSpacing: 1
            }
            
        }
        /////////


        Row {
            visible: false
            id: negative_numbers_text_on
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                id: negative_numbers_text
                font.pointSize: 15
                text: "Negative numbers: "
                font.letterSpacing: 1
            }
            Text {
                id: negative_numbers_on
                font.pointSize: 15
                color: "#08D600"
                y: 2
                text: "ON"
                font.letterSpacing: 1
            }
            
        }
           
    }

     /////////// TIMER
        Text {
            visible: false
            anchors.horizontalCenter: parent.horizontalCenter
            id: timer
            y: 150
            objectName: "timer"
            font.pointSize: 17
            text: seconds_userinput.text
            color: {
                if (window.theme === "Normal") {
                    return text === "0" ? "red" 
                    : text === "1" ? "red" 
                    : text === "2" ? "red"
                    : text === "3" ? "red" 
                    : "black"
                }
                else {
                    return text === "0" ? "red" 
                    : text === "1" ? "red" 
                    : text === "2" ? "red"
                    : text === "3" ? "red" 
                    : "white"
                }
            }
            font.letterSpacing: 1
        }
   



    ////////// SETTINGS BUTTON
    Button {
        id: settings_button
        width: 40
        height: 40
        background: Rectangle { color: "transparent" }
        anchors.verticalCenter: parent.top
        anchors.verticalCenterOffset: 40
        anchors.horizontalCenter: parent.left
        anchors.horizontalCenterOffset: 40
       
        MouseArea {
            id: settings_button_mousearea
            objectName: "settings_button_mousearea"
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor 
            onClicked: {
                settings.visible = true
                settings_button.visible = false
                
            }
        }
        Image {
            id: settings_button_icon
            source: "qrc:/qt/qml/infinite_math_test/settings_icon.png"
            
            width: 40
            height: 40
        }
    }
    ////////////

    ///////////// SETTINGS RECTANGLE
    Rectangle {
        id: settings
        color: "white"
        anchors.fill: parent 
        visible: false
        Button {
            id: settings_close
            width: 20
            height: 20
            background: Rectangle { color: "transparent" }
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -200

            anchors.horizontalCenter: parent.left
            anchors.horizontalCenterOffset: 40

       
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor 
                onClicked: {

                    if (timer_cb.checked === true) {
                        if (seconds_userinput.text === "") {
                            backend.set_timer_seconds("10")
                        }
                        else {
                            backend.set_timer_seconds(seconds_userinput.text)
                        }
                    }
                    settings.visible = false
                    settings_button.visible = true
                    userinput.focus = true

                }
            }
            Image {
                id: cross_image
                source: "qrc:/qt/qml/infinite_math_test/cross.png"
                width: 20
                height: 20
            }
        }
        Row {
            id: seconds_row
            visible: false
            spacing: 50
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenterOffset: 102
            anchors.horizontalCenterOffset: 32
            Text {
                id: seconds_settings_text
                font.pointSize: 14
                text: "Seconds: "
                font.letterSpacing: 1
                color: "black"
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: 8
                
            }
            TextField {

                id: seconds_userinput
                objectName: "seconds_userinput"
                z: -1
                y: 10
                font.pointSize: 14
                font.letterSpacing: 1
                font.bold: true
                color: "black"
                focus: true
                
                background: Rectangle {
                    id: seconds_userinput_background
                    objectName: "seconds_userinput_background"
                    implicitWidth: 100
                    implicitHeight: 20
                    
                    
                }

                
                   
            }
        }
        Column {
            id: settings_column
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            spacing: 5
            Row {
                spacing: 6
                
                Text {
                    id: dark_theme_text
                    font.pointSize: 15
                    text: "Dark theme: "
                    font.letterSpacing: 1
                    color: "black"
                    anchors.verticalCenter: parent.verticalCenter
                    width: 150
                }
                CheckBox {
                    id: dark_theme_cb
                    objectName: "dark_theme_cb"
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: 3
                    checked: false
                    width: 20
                    height: 20
                    onCheckedChanged: {
                        if (checked === true) { 
                            window.enable_dark_theme()  
                            backend.set_theme(1)
                        }
                        else {
                            window.enable_normal_theme()
                            backend.set_theme(0)
                        }
                    }
                    background: Rectangle {
                        id: dark_theme_cb_normal_background
                        //color: dark_theme_cb.hovered ? "black" : "white"
                        //Behavior on color { ColorAnimation { duration: 200 } }
                    }
                    indicator: Rectangle {
                        id: dark_theme_cb_background
                        width: parent.width
                        height: parent.height
                        border.width: 2
                        border.color: dark_theme_cb.checked ? "black" : "black"
                        color: dark_theme_cb.checked ? "black" : "transparent"
                        Behavior on color { ColorAnimation { duration: 120 } }
                        Behavior on border.color { ColorAnimation { duration: 120 } }
                    
                        Text {
                            anchors.centerIn: parent
                            text: dark_theme_cb.checked ? "✔" : ""
                            color: "white"
                            font.pixelSize: 16
                        }
                    }
                
                }
            }

            Row {
                spacing: 6
                
                Text {
                    id: numpad_text
                    font.pointSize: 15
                    text: "Numpad: "
                    font.letterSpacing: 1
                    color: "black"
                    anchors.verticalCenter: parent.verticalCenter
                    width: 150
                }
                CheckBox {
                    id: numpad_cb
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: 3
                    objectName: "numpad_cb"
                    width: 20
                    height: 20
                    onCheckedChanged: {
                        if (checked === true) { 
                            numpad.visible = true
                            backend.set_numpad(1)
                        }
                        else {
                            numpad.visible = false
                            backend.set_numpad(0)
                        }
                    }
                    background: Rectangle {
                        id: numpad_cb_normal_background
                        /*color: {
                            if (window.theme === "Normal") {
                                return numpad_cb.hovered ? "black" : "white"
                            }
                            else {
                                return numpad_cb.hovered ? "white" : "black"
                            }
                                
                        }*/
                                
                        Behavior on color { ColorAnimation { duration: 200 } }
                    }
                    indicator: Rectangle {
                        id: numpad_cb_background
                        width: parent.width
                        height: parent.height
                        border.width: 2
                        border.color: numpad_cb.checked ? "black" : "black"
                        color: numpad_cb.checked ? "black" : "transparent"
                        Behavior on color { ColorAnimation { duration: 120 } }
                        Behavior on border.color { ColorAnimation { duration: 120 } }
                    
                        Text {
                            anchors.centerIn: parent
                            text: numpad_cb.checked ? "✔" : ""
                            color: "white"
                            font.pixelSize: 16
                        }
                    }
                
                }
            }
            Row {
                spacing: 6
                
                Text {
                    id: stats_settings_text
                    font.pointSize: 15
                    text: "Show stats: "
                    font.letterSpacing: 1
                    color: "black"
                    anchors.verticalCenter: parent.verticalCenter
                    width: 150
                }
                CheckBox {
                    id: stats_cb
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: 3
                    objectName: "stats_cb"
                    width: 20
                    height: 20
                    onCheckedChanged: {
                        if (checked === true) { 
                            stats.visible = true
                            backend.set_show_stats(1)
                        }
                        else {
                            stats.visible = false
                            backend.set_show_stats(0)
                        }
                    }
                    background: Rectangle {
                        id: stats_cb_normal_background
                        color: stats_cb.hovered ? "black" : "white"
                        Behavior on color { ColorAnimation { duration: 200 } }
                    }
                    indicator: Rectangle {
                        id: stats_cb_background
                        width: parent.width
                        height: parent.height
                        border.width: 2
                        border.color: stats_cb.checked ? "black" : "black"
                        color: stats_cb.checked ? "black" : "transparent"
                        Behavior on color { ColorAnimation { duration: 120 } }
                        Behavior on border.color { ColorAnimation { duration: 120 } }
                    
                        Text {
                            anchors.centerIn: parent
                            text: stats_cb.checked ? "✔" : ""
                            color: "white"
                            font.pixelSize: 16
                        }
                    }
                
                }
            }
            
            Row {
                spacing: 6
                
                Text {
                    id: negative_num_settings_text
                    font.pointSize: 15
                    text: "Neg. numbers: "
                    font.letterSpacing: 1
                    color: "black"
                    anchors.verticalCenter: parent.verticalCenter
                    width: 150
                }
                CheckBox {
                    id: negative_cb
                    objectName: "negative_cb"
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: 3
                    
                    width: 20
                    height: 20
                    onCheckedChanged: {
                       
                        if (checked === true) { 
                            backend.enable_negatives(true)
                            negative_numbers_text_on.visible = true
                            example_text.font.pixelSize = example_text.font.pixelSize-10
                            userinput.font.pixelSize = userinput.font.pixelSize - 10
                            right_answer.font.pointSize = right_answer.font.pointSize - 10
                            example_text.y = example_text.y + 5
                            userinput.y = userinput.y + 5
                        }
                        else {
                            backend.enable_negatives(false)
                            negative_numbers_text_on.visible = false
                            example_text.font.pixelSize = example_text.font.pixelSize+10
                            userinput.font.pixelSize = userinput.font.pixelSize + 10
                            right_answer.font.pointSize = right_answer.font.pointSize + 10
                            example_text.y = example_text.y - 5
                            userinput.y = userinput.y - 5
                        }
                        backend.choose_sign()
                        backend.set_numbers();
                    }
                    background: Rectangle {
                        id: negative_cb_normal_background
                        color: negative_cb.hovered ? "black" : "white"
                        Behavior on color { ColorAnimation { duration: 200 } }
                    }
                    indicator: Rectangle {
                        id: negative_cb_background
                        width: parent.width
                        height: parent.height
                        border.width: 2
                        border.color: negative_cb.checked ? "black" : "black"
                        color: negative_cb.checked ? "black" : "transparent"
                        Behavior on color { ColorAnimation { duration: 120 } }
                        Behavior on border.color { ColorAnimation { duration: 120 } }
                    
                        Text {
                            anchors.centerIn: parent
                            text: negative_cb.checked ? "✔" : ""
                            color: "white"
                            font.pixelSize: 16
                        }
                    }
                
                }
            }
            Row {
                spacing: 6
                
                Text {
                    id: brackets_settings_text
                    font.pointSize: 15
                    text: "Brackets: "
                    font.letterSpacing: 1
                    color: "black"
                    anchors.verticalCenter: parent.verticalCenter
                    width: 150
                }
                CheckBox {
                    id: brackets_cb
                    objectName: "brackets_cb"
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: 3
                    
                    width: 20
                    height: 20
                    onCheckedChanged: {
                        
                        if (checked === true) { 
                            backend.enable_brackets(true)
                            example_text.font.pixelSize = example_text.font.pixelSize - 10
                            userinput.font.pixelSize = userinput.font.pixelSize - 10
                            right_answer.font.pointSize = right_answer.font.pointSize - 10
                            brackets_text_on.visible = true
                            example_text.y = example_text.y + 5
                            userinput.y = userinput.y + 5
                        }
                        else {
                            backend.enable_brackets(false)
                            example_text.font.pixelSize = example_text.font.pixelSize + 10
                            userinput.font.pixelSize = userinput.font.pixelSize + 10
                            right_answer.font.pointSize = right_answer.font.pointSize + 10
                            brackets_text_on.visible = false
                            example_text.y = example_text.y - 5
                            userinput.y = userinput.y - 5
                        }
                        backend.choose_sign()
                        backend.set_numbers();
                    }
                    background: Rectangle {
                        id: brackets_cb_normal_background
                        color: brackets_cb.hovered ? "black" : "white"
                        Behavior on color { ColorAnimation { duration: 200 } }
                    }
                    indicator: Rectangle {
                        id: brackets_cb_background
                        width: parent.width
                        height: parent.height
                        border.width: 2
                        border.color: brackets_cb.checked ? "black" : "black"
                        color: brackets_cb.checked ? "black" : "transparent"
                        Behavior on color { ColorAnimation { duration: 120 } }
                        Behavior on border.color { ColorAnimation { duration: 120 } }
                    
                        Text {
                            anchors.centerIn: parent
                            text: brackets_cb.checked ? "✔" : ""
                            color: "white"
                            font.pixelSize: 16
                        }
                    }
                
                }
            }
            Row {
                spacing: 6
                
                Text {
                    id: timer_settings_text
                    font.pointSize: 15
                    text: "Timer: "
                    font.letterSpacing: 1
                    color: "black"
                    anchors.verticalCenter: parent.verticalCenter
                    width: 150
                }
                CheckBox {
                    id: timer_cb
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: 3
                    objectName: "timer_cb"
                    width: 20
                    height: 20
                    onCheckedChanged: {
                        if (checked === true) { 
                            timer.visible = true
                            seconds_row.visible = true
                            backend.enable_timer(true)
                            timer.visible = true
                            seconds_userinput.focus = true
                        }
                        else {
                            timer.visible = false
                            seconds_row.visible = false
                            backend.enable_timer(false)
                            timer.visible = false
                            seconds_userinput.focus = false
                            
                        }
                    }
                    background: Rectangle {
                        id: timer_cb_normal_background
                        color: timer_cb.hovered ? "black" : "white"
                        Behavior on color { ColorAnimation { duration: 200 } }
                    }
                    indicator: Rectangle {
                        id: timer_cb_background
                        width: parent.width
                        height: parent.height
                        border.width: 2
                        border.color: timer_cb.checked ? "black" : "black"
                        color: timer_cb.checked ? "black" : "transparent"
                        Behavior on color { ColorAnimation { duration: 120 } }
                        Behavior on border.color { ColorAnimation { duration: 120 } }
                    
                        Text {
                            anchors.centerIn: parent
                            text: timer_cb.checked ? "✔" : ""
                            color: "white"
                            font.pixelSize: 16
                        }
                    }
                
                }
            }
            
        }
        
        
    }

}
