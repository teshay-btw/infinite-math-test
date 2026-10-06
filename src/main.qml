import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window
import QtQuick.Controls.Material 2.15
import QtQuick.Effects
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
    Image {
        source: "background.png"
        anchors.fill: parent
    }
    property string theme: "Normal"

    

    function send_answer() {
        backend.check_answer(userinput.text)
    }
    FontLoader {
        source: "unnamedregular.otf"
        id: unnamedregular
    }
    FontLoader {
        source: "glonto_egular.ttf"
        id: glonto
    }

    ////////// MADE BY TEXT
    Column {
        anchors.horizontalCenter: parent.right
        anchors.horizontalCenterOffset: -80
        anchors.verticalCenter: parent.bottom
        anchors.verticalCenterOffset: -17
        bottomPadding: 2
        Row {
            Text {
                id: made_by_text
                text: "Made by "
                color: "#E3E3E3"
                font.pixelSize: 14
                font.letterSpacing: 0.4
                font.family: unnamedregular.font.family
            }
            Text {

                property string link_color: "#08FF00"
                id: link
                text: "teshay"
                color: link_color
                font.pixelSize: 14
                font.bold: true
                font.underline: false
                font.family: unnamedregular.font.family
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
        anchors.verticalCenterOffset: 0
        spacing: 0
        id: example 
         MultiEffect {
                source: example_text
                anchors.fill: example_text

                blurEnabled: true
                blur: 1

                shadowEnabled: true
                shadowColor: "white"
                shadowBlur: 1
                shadowHorizontalOffset: 0
                shadowVerticalOffset: 0
                
            } 
        Row {

            objectName: "main_column"
            id: main_column
            spacing: 10
                
               
            Text {
                id: example_text
                objectName: "example" 
                font.pointSize: 40
                font.family: glonto.font.family
                color: "#E0E4FF"
                font.bold: true
                Behavior on x {
                    PropertyAnimation { duration: 100 }
                }
            }
            TextField {
                id: userinput
                objectName: "userinput"
                y: -7
                padding: 20
                font.pointSize: 40
                font.family: glonto.font.family
                font.bold: true
                color: "#E0E4FF"
                focus: true
                background: Rectangle {
                    id: userinput_background
                    objectName: "userinput_background"
                    implicitWidth: 150
                    implicitHeight: 40
                    color: "transparent"
                }
                Keys.onReturnPressed: {
                    backend.check_answer(userinput.text)
                }
                cursorDelegate: Rectangle {
                    width: 1
                    height: parent.height - 15
                    color: "#2753B8"
                }
            }
           
        }
        
        Rectangle {
            id: rectangle_answer
            width: main_column.width
            height: 20
            radius: 10
            color: "#08FF00"
            border.width: 1
            border.color: "#2753B8"
        }
        
        
        
    }
   ///////////// INCORRECT ANSWER RECTANGLE
    Rectangle {
        height: 50
        width: right_answer.width + 20
        visible: false
        radius: 10
        color: "#30152235"
        border.width: 1
        border.color: "#1f3253"
        id: incorrect_answer_rectangle
        objectName: "incorrect_answer_rectangle"
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -115
        Text {
            id: right_answer
            anchors.centerIn: parent
            font.bold: true 
            color: "red"
            objectName: "right_answer" 
            font.pointSize: 20
            font.family: glonto.font.family
            opacity: 0
            text: "10"
        }
        
    }
    MultiEffect {
        source: incorrect_answer_rectangle
        anchors.fill: incorrect_answer_rectangle

        blurEnabled: true
        blur: 1

        shadowEnabled: true
        shadowColor: "#2753B8"
        shadowBlur: 1 
        shadowHorizontalOffset: 0
        shadowVerticalOffset: 0
        z: -1
    }
    MultiEffect {
        source: incorrect_answer_rectangle
        anchors.fill: incorrect_answer_rectangle

        blurEnabled: true
        blur: 1

        shadowEnabled: true
        shadowColor: "#2753B8"
        shadowBlur: 1 
        shadowHorizontalOffset: 0
        shadowVerticalOffset: 0
        z: -1
    }
    MultiEffect {
            source: rectangle_answer
            anchors.fill: rectangle_answer

            blurEnabled: true
            blur: 1

            shadowEnabled: true
            shadowColor: "#070059"
            shadowBlur: 1 
            shadowHorizontalOffset: 0
            shadowVerticalOffset: 0
            z: -1
        }
    



    /////// NUMPAD
    GridLayout {
        objectName: "numpad"
        id: numpad
        columns: 5
        rowSpacing: -5
        columnSpacing: 7
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 150
        
        Repeater {
             model: ["1","2","3", "4","5",
                    "6", "7","8","9", "0",
                    "","<", "E","-", ""]
            
            Button {
                id: numpad_button
                text: modelData
                font.pixelSize: 30
                padding: 10
                rightPadding: 15
                leftPadding: 15
                topPadding: 15
                bottomPadding: 15
                enabled: text !== ""   // пустые ячейки не кликаются
                opacity: text === "" ? 0 : 1   // и не видны
                contentItem: Text {
                    id: numpad_button_text
                    font.family: glonto.font.family
                    text: parent.text
                    font.bold: true
                    color: "#C7CFFF"
                    font.pixelSize: 24
                    anchors.centerIn: parent
                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }
                }
                background: Rectangle {
                    objectName: "numpad_buttons_background"
                    id: numpad_button_background
                    radius: 10
                    gradient: Gradient {
                        GradientStop {
                            position: 0.0
                            color: "#102B50"
                        }

                        GradientStop {
                            position: 0.45
                            color: "#081B35"
                        }

                        GradientStop {
                            position: 1.0
                            color: "#041125"
                        }
                    }
                    border.width: 1;
                    border.color: "#5E66B8"
                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: numpad_button_text.color = "white"
                    onExited: numpad_button_text.color = "#C7CFFF"

                    onClicked: {
                        userinput.text += text !== "E" && text !== "<" ? text : ""

                        if (text === "<") 
                            userinput.text = userinput.text.slice(0, -1)

                        if (text === "E")
                            backend.check_answer(userinput.text)
                    }
                }

                MultiEffect {
                    source: numpad_button_background
                    anchors.fill: numpad_button_background
                    id: numpad_button_effect
                    blurEnabled: true
                    blur: 1

                    shadowEnabled: true
                    shadowColor: "#2753B8"
                    shadowBlur: 1 
                    shadowHorizontalOffset: 0
                    shadowVerticalOffset: 0
                    z: -1
                    
                }
            }
        }
    }
    MultiEffect {
        source: stats_rectangle
        anchors.fill: stats_rectangle

        blurEnabled: true
        blur: 2

        shadowEnabled: true
        shadowColor: "#070059"
        shadowBlur: 2 
        shadowHorizontalOffset: 0
        shadowVerticalOffset: 0

    }
    MultiEffect {
        source: stats_rectangle
        anchors.fill: stats_rectangle

        blurEnabled: true
        blur: 2

        shadowEnabled: true
        shadowColor: "#070059"
        shadowBlur: 2
        shadowHorizontalOffset: 0
        shadowVerticalOffset: 0
    }
    MultiEffect {
        source: stats_rectangle
        anchors.fill: stats_rectangle

        blurEnabled: true
        blur: 2 

        shadowEnabled: true
        shadowColor: "#070059"
        shadowBlur: 2
        shadowHorizontalOffset: 0
        shadowVerticalOffset: 0
    }
    //////////////// STATS
    Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.top
        anchors.verticalCenterOffset: 50
        visible: false
        width: stats.width + 80
        height: 80
        border.width: 1
        border.color: "#1f3253"
        id: stats_rectangle
        color: "#30152235"
        radius: 20
        layer.enabled: true
        layer.effect: MultiEffect {
            blurEnabled: true
            blur: 0
        }
        Row {
            visible: false
            id: stats
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            spacing: 30
            Column {
            anchors.verticalCenter: parent.verticalCenter
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Progress"
                    color: "white"
                    font.pixelSize: 15

                }
                Row {
                    spacing: 10
                    Text {
                        id: correct_number_text
                        objectName: "correct_number_text"
                        font.pointSize: 19
                        font.letterSpacing: 1
                        color: "#08FF00" 
                        font.bold: true

                
                    }
                    Text {
                        id: separator
                        font.pointSize: 19
                        text: "/"
                        font.letterSpacing: 1
                        color: "white"
                    }
                    Text {
                        id: incorrect_number_text
                        objectName: "incorrect_number_text"
                        font.pointSize: 19
                        font.letterSpacing: 1
                        color: "red" 
                        font.bold: true
                    }
                }
                
            }

            Rectangle {
                width: 1
                height: parent.height - 10
                color: "#1f3253"
                anchors.verticalCenter: parent.verticalCenter
            }   

            Column {
                anchors.verticalCenter: parent.verticalCenter
                spacing: -5
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    id: incorrect_percent_text
                    font.pixelSize: 15
                    text: "Incorrect: "
                    font.letterSpacing: 1
                    color: "white"
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    id: incorrect_percent
                    objectName: "incorrect_percent"
                    font.pointSize: 19
                    font.letterSpacing: 1
                    color: "red"
                    font.bold: true
                }
            }
            Rectangle {
                width: 1
                height: parent.height - 10
                color: "#1f3253"
                anchors.verticalCenter: parent.verticalCenter
            }
            Column {
                anchors.verticalCenter: parent.verticalCenter
                spacing: -5
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    id: streak_text
                    font.pixelSize: 15
                    text: "Streak: "
                    font.letterSpacing: 1
                    color: "white"
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    id: streak
                    objectName: "streak"
                    font.pointSize: 19
                    font.letterSpacing: 1
                    color: "#08FF00"
                    font.bold: true
                }
            }
            
           
        }
    }



    
    MultiEffect {
            source: progress_bar_background
            anchors.fill: progress_bar_background

            blurEnabled: true
            blur: 1
            visible: progress_bar_background.visible ? true : false
            shadowEnabled: true
            shadowColor: "#36DFFF"
            shadowBlur: 1
            shadowHorizontalOffset: 0
            shadowVerticalOffset: 0

        }



    ///////////// PROGRESS BAR TIMER
    Rectangle {
        visible: false
        id: progress_bar_background
        objectName: "progress_bar_rectangle"
        width: 100
        height: 10
        color: "transparent"
        smooth: true
        border.color: "#36E2FF"
        border.width: 1 
        radius: 10
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenterOffset: -65
        Rectangle {
            id: progress_bar
            objectName: "progress_bar"
            width: 100
            height: 10
            radius: 10
            gradient: Gradient {
                GradientStop {
                    position: 0.0
                    color: "#0758D6"
                }

                GradientStop {
                    position: 0.25
                    color: "#0875E8"
                }

                GradientStop {
                    position: 0.5
                    color: "#0B8EF5"
                }

                GradientStop {
                    position: 0.75
                    color: "#18A8FA"
                }

                GradientStop {
                    position: 1.0
                    color: "#3686FF"
                }
            }
            smooth: true
            z: -1
                
        }
    }
       
    NumberAnimation {
        id: progress_bar_animation
        objectName: "progress_bar_animation"
        property: "width"
        target: progress_bar
        from: 100
        to: 0
        easing.type: Easing.Linear
        
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
   

    MultiEffect {
        source: settings_button_rectangle
        anchors.fill: settings_button_rectangle

        blurEnabled: true
        blur: 1 

        shadowEnabled: true
        shadowColor: "#070059"
        shadowBlur: 1
        shadowHorizontalOffset: 0
        shadowVerticalOffset: 0
    }
    MultiEffect {
        source: settings_button_rectangle
        anchors.fill: settings_button_rectangle

        blurEnabled: true
        blur: 1 

        shadowEnabled: true
        shadowColor: "#070059"
        shadowBlur: 1
        shadowHorizontalOffset: 0
        shadowVerticalOffset: 0
    }
    ////////// SETTINGS BUTTON
    Rectangle {
        id: settings_button_rectangle
        height: 60
        width: 60
        radius: 10
        color: "#30152235"
        border.width: 1
        border.color: "#2753B8"
        anchors.verticalCenter: parent.top
        anchors.verticalCenterOffset: 40
        anchors.horizontalCenter: parent.left
        anchors.horizontalCenterOffset: 40
        Button {
            id: settings_button
            width: 40
            height: 40
            background: Rectangle { color: "transparent" }
            anchors.centerIn: parent
       
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
    }
    ////////////

    ///////////// SETTINGS RECTANGLE
    Rectangle {
        id: settings
        Image {
            source: "background.png"
            anchors.fill: parent
        }
        anchors.fill: parent 
        visible: false
        MultiEffect {
            source: settings_close_icon_rectangle
            anchors.fill: settings_close_icon_rectangle
            
            blurEnabled: true
            blur: 1 

            shadowEnabled: true
            shadowColor: "#070059"
            shadowBlur: 1
            shadowHorizontalOffset: 0
            shadowVerticalOffset: 0
        }
        MultiEffect {
            source: settings_close_icon_rectangle
            anchors.fill: settings_close_icon_rectangle
            
            blurEnabled: true
            blur: 1 

            shadowEnabled: true
            shadowColor: "#070059"
            shadowBlur: 1
            shadowHorizontalOffset: 0
            shadowVerticalOffset: 0
        }
        MultiEffect {
            source: settings_rectangle
            anchors.fill: settings_rectangle

            blurEnabled: true
            blur: 1

            shadowEnabled: true
            shadowColor: "black"
            shadowBlur: 1
            shadowHorizontalOffset: 0
            shadowVerticalOffset: 0
            z: -1
            }
        MultiEffect {
            source: settings_rectangle
            anchors.fill: settings_rectangle

            blurEnabled: true
            blur: 1

            shadowEnabled: true
            shadowColor: "black"
            shadowBlur: 1
            shadowHorizontalOffset: 0
            shadowVerticalOffset: 0
            z: -1
        }
        Rectangle {
         
            height: 60
            width: 60
            radius: 10
            color: "#30152235"
            border.width: 1
            border.color: "#2753B8"
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -200
            id: settings_close_icon_rectangle
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.horizontalCenterOffset: 40
            Button {
                id: settings_close
                width: 25
                height: 25
                background: Rectangle { color: "transparent" }
                y: 19
                x: 17.2
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
                    anchors.fill: parent
                    id: cross_image
                    anchors.centerIn: parent
                    source: "qrc:/qt/qml/infinite_math_test/white_cross.png"
                    width: 25
                    height: 25
                }
            }

        }
       
        Rectangle {
        
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            width: 400
            height: 250
            id: settings_rectangle
            border.width: 1
            border.color: "#1f3253"
            color: "#30152235"
            radius: 20
            layer.enabled: true
            layer.effect: MultiEffect {
                blurEnabled: true
                blur: 0
            }



            Row {
                id: seconds_row
                visible: false
                spacing: 50
                anchors.centerIn: parent
                anchors.verticalCenterOffset: 115
                anchors.horizontalCenterOffset: 2
                Text {
                    id: seconds_settings_text
                    font.pointSize: 15
                    text: "Seconds: "
                    font.letterSpacing: 1
                    color: "white"
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: 8
                    width: 225
                }
                TextField {

                    id: seconds_userinput
                    objectName: "seconds_userinput"
                    z: -1
                    y: 10
                    font.pointSize: 12
                    font.letterSpacing: 1
                    font.bold: true
                    color: "white"
                    focus: true

                    background: Rectangle {
                        id: seconds_userinput_background
                        objectName: "seconds_userinput_background"
                        implicitWidth: 60
                        implicitHeight: 20
                        color: "transparent"
                        border.width: 1
                        border.color: "#2753B8"
                        radius: 10
                    }

                
                   
                }
            }
            Row {
                id: levels_text
                spacing: 22
                anchors.centerIn: parent
                anchors.verticalCenterOffset: -102
                anchors.horizontalCenterOffset: 122
                Text {
                    font.pointSize: 10
                    text: "1"
                    font.letterSpacing: 1
                    color: "grey"
                }
                Text {
                    font.pointSize: 10
                    text: "2"
                    font.letterSpacing: 1
                    color: "grey"

                }
                Text {
                    font.pointSize: 10
                    text: "3"
                    font.letterSpacing: 1
                    color: "grey"

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
                        id: level_text
                        font.pointSize: 15
                        text: "Level: "
                        font.letterSpacing: 1
                        color: "white"
                        anchors.verticalCenter: parent.verticalCenter
                        width: 240
                    }
                    Row {
                        spacing: 5
                        CheckBox {
                            id: level1_cb

                            width: 25
                            height: 25

                            anchors.verticalCenter: parent.verticalCenter
                            anchors.verticalCenterOffset: 3

                            objectName: "level1_cb"

                            onCheckedChanged: {
                                if (checked) {
                                    level2_cb.checked = false
                                    level3_cb.checked = false
                                    backend.set_level(1)
                                    backend.choose_sign()
                                    backend.set_numbers()
                                } 
                                else if (level2_cb.checked == false && level3_cb.checked == false) {
                                    level1_cb.checked = true
                                }
                            }

                            indicator: Rectangle {
                                id: level1_cb_background
                                width: 25
                                height: 25
                                anchors.centerIn: parent
                                radius: 9
                                color: level1_cb.checked
                                       ? "#102A5A"
                                       : "#0B1733"

                                border.width: 2
                                border.color: level1_cb.checked
                                              ? "#2979FF"
                                              : "#667FB7"
                                Behavior on color {
                                    ColorAnimation {
                                        duration: 150
                                    }
                                }
                                Behavior on border.color {
                                    ColorAnimation {
                                        duration: 150
                                    }
                                }
                                // Галочка
                                Text {
                                    anchors.centerIn: parent

                                    text: level1_cb.checked ? "✓" : ""

                                    color: "#36A9FF"

                                    font.family: glonto.font.family
                                    font.pixelSize: 19
                                    font.bold: true

                                    opacity: level1_cb.checked ? 1 : 0

                                    Behavior on opacity {
                                        NumberAnimation {
                                            duration: 120
                                        }
                                    }
                                }

                                // Свечение
                                MultiEffect {
                                    id: checkbox1_effect

                                    source: level1_cb_background

                                    anchors.fill: level1_cb_background

                                    shadowEnabled: true

                                    shadowColor: level1_cb.checked
                                                 ? "#2878FF"
                                                 : "transparent"

                                    shadowBlur: level1_cb.checked ? 12 : 0

                                    shadowHorizontalOffset: 0
                                    shadowVerticalOffset: 0

                                    Behavior on shadowColor {
                                        ColorAnimation {
                                            duration: 150
                                        }
                                    }

                                    Behavior on shadowBlur {
                                        NumberAnimation {
                                            duration: 150
                                        }
                                    }

                                    z: -1
                                }
                            }
                        }
                        CheckBox {
                            id: level2_cb

                            width: 25
                            height: 25

                            anchors.verticalCenter: parent.verticalCenter
                            anchors.verticalCenterOffset: 3

                            objectName: "level2_cb"

                            onCheckedChanged: {
                                if (checked) {
                                    level1_cb.checked = false
                                    level3_cb.checked = false
                                    backend.set_level(2);
                                    backend.choose_sign()
                                    backend.set_numbers()
                                } 
                                else if (level1_cb.checked == false && level3_cb.checked == false) {
                                    level2_cb.checked = true
                                }
                            }

                            indicator: Rectangle {
                                id: level2_cb_background
                                width: 25
                                height: 25
                                anchors.centerIn: parent
                                radius: 9
                                color: level2_cb.checked
                                       ? "#102A5A"
                                       : "#0B1733"

                                border.width: 2
                                border.color: level2_cb.checked
                                              ? "#2979FF"
                                              : "#667FB7"
                                Behavior on color {
                                    ColorAnimation {
                                        duration: 150
                                    }
                                }
                                Behavior on border.color {
                                    ColorAnimation {
                                        duration: 150
                                    }
                                }
                                // Галочка
                                Text {
                                    anchors.centerIn: parent

                                    text: level2_cb.checked ? "✓" : ""

                                    color: "#36A9FF"

                                    font.family: glonto.font.family
                                    font.pixelSize: 19
                                    font.bold: true

                                    opacity: level2_cb.checked ? 1 : 0

                                    Behavior on opacity {
                                        NumberAnimation {
                                            duration: 120
                                        }
                                    }
                                }

                                // Свечение
                                MultiEffect {
                                    id: checkbox2_effect

                                    source: level2_cb_background

                                    anchors.fill: level2_cb_background

                                    shadowEnabled: true

                                    shadowColor: level2_cb.checked
                                                 ? "#2878FF"
                                                 : "transparent"

                                    shadowBlur: level2_cb.checked ? 12 : 0

                                    shadowHorizontalOffset: 0
                                    shadowVerticalOffset: 0

                                    Behavior on shadowColor {
                                        ColorAnimation {
                                            duration: 150
                                        }
                                    }

                                    Behavior on shadowBlur {
                                        NumberAnimation {
                                            duration: 150
                                        }
                                    }

                                    z: -1
                                }
                            }
                        }
                        CheckBox {
                            id: level3_cb

                            width: 25
                            height: 25

                            anchors.verticalCenter: parent.verticalCenter
                            anchors.verticalCenterOffset: 3

                            objectName: "level3_cb"

                            onCheckedChanged: {
                                if (checked) {
                                    level2_cb.checked = false
                                    level1_cb.checked = false
                                    backend.set_level(3);
                                    backend.choose_sign()
                                    backend.set_numbers()

                                }
                                else if (level1_cb.checked == false && level2_cb.checked == false) {
                                    level3_cb.checked = true
                                }
                            }

                            indicator: Rectangle {
                                id: level3_cb_background
                                width: 25
                                height: 25
                                anchors.centerIn: parent
                                radius: 9
                                color: level3_cb.checked
                                       ? "#102A5A"
                                       : "#0B1733"

                                border.width: 2
                                border.color: level3_cb.checked
                                              ? "#2979FF"
                                              : "#667FB7"
                                Behavior on color {
                                    ColorAnimation {
                                        duration: 150
                                    }
                                }
                                Behavior on border.color {
                                    ColorAnimation {
                                        duration: 150
                                    }
                                }
                                // Галочка
                                Text {
                                    anchors.centerIn: parent

                                    text: level3_cb.checked ? "✓" : ""

                                    color: "#36A9FF"

                                    font.family: glonto.font.family
                                    font.pixelSize: 19
                                    font.bold: true

                                    opacity: level3_cb.checked ? 1 : 0

                                    Behavior on opacity {
                                        NumberAnimation {
                                            duration: 120
                                        }
                                    }
                                }

                                // Свечение
                                MultiEffect {
                                    id: checkbox3_effect

                                    source: level3_cb_background

                                    anchors.fill: level3_cb_background

                                    shadowEnabled: true

                                    shadowColor: level3_cb.checked
                                                 ? "#2878FF"
                                                 : "transparent"

                                    shadowBlur: level3_cb.checked ? 12 : 0

                                    shadowHorizontalOffset: 0
                                    shadowVerticalOffset: 0

                                    Behavior on shadowColor {
                                        ColorAnimation {
                                            duration: 150
                                        }
                                    }

                                    Behavior on shadowBlur {
                                        NumberAnimation {
                                            duration: 150
                                        }
                                    }

                                    z: -1
                                }
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
                        color: "white"
                        anchors.verticalCenter: parent.verticalCenter
                        width: 300
                    }
                    CheckBox {
                        id: numpad_cb

                        width: 25
                        height: 25

                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: 3

                        objectName: "numpad_cb"

                        onCheckedChanged: {
                            if (checked) {
                                numpad.visible = true
                                backend.set_numpad(1)
                            } else {
                                numpad.visible = false
                                backend.set_numpad(0)
                            }
                        }

                        indicator: Rectangle {
                            id: numpad_cb_background
                            width: 25
                            height: 25
                            anchors.centerIn: parent
                            radius: 9
                            color: numpad_cb.checked
                                   ? "#102A5A"
                                   : "#0B1733"

                            border.width: 2
                            border.color: numpad_cb.checked
                                          ? "#2979FF"
                                          : "#667FB7"
                            Behavior on color {
                                ColorAnimation {
                                    duration: 150
                                }
                            }
                            Behavior on border.color {
                                ColorAnimation {
                                    duration: 150
                                }
                            }
                            // Галочка
                            Text {
                                anchors.centerIn: parent

                                text: numpad_cb.checked ? "✓" : ""

                                color: "#36A9FF"

                                font.family: glonto.font.family
                                font.pixelSize: 19
                                font.bold: true

                                opacity: numpad_cb.checked ? 1 : 0

                                Behavior on opacity {
                                    NumberAnimation {
                                        duration: 120
                                    }
                                }
                            }

                            // Свечение
                            MultiEffect {
                                id: checkbox_effect

                                source: numpad_cb_background

                                anchors.fill: numpad_cb_background

                                shadowEnabled: true

                                shadowColor: numpad_cb.checked
                                             ? "#2878FF"
                                             : "transparent"

                                shadowBlur: numpad_cb.checked ? 12 : 0

                                shadowHorizontalOffset: 0
                                shadowVerticalOffset: 0

                                Behavior on shadowColor {
                                    ColorAnimation {
                                        duration: 150
                                    }
                                }

                                Behavior on shadowBlur {
                                    NumberAnimation {
                                        duration: 150
                                    }
                                }

                                z: -1
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
                        color: "white"
                        anchors.verticalCenter: parent.verticalCenter
                        width: 300
                    }
                    CheckBox {
                        id: stats_cb

                        width: 25
                        height: 25

                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: 3

                        objectName: "stats_cb"

                        onCheckedChanged: {
                            if (checked) {
                                stats.visible = true
                                stats_rectangle.visible = true
                                backend.set_show_stats(1)
                            } else {
                                stats_rectangle.visible = false
                                stats.visible = false
                                backend.set_show_stats(0)
                            }
                        }

                        indicator: Rectangle {
                            id: stats_cb_background

                            width: 25
                            height: 25

                            anchors.centerIn: parent

                            radius: 9

                            color: stats_cb.checked
                                   ? "#102A5A"
                                   : "#0B1733"

                            border.width: 2

                            border.color: stats_cb.checked
                                          ? "#2979FF"
                                          : "#667FB7"

                            Behavior on color {
                                ColorAnimation {
                                    duration: 150
                                }
                            }

                            Behavior on border.color {
                                ColorAnimation {
                                    duration: 150
                                }
                            }

                            // Галочка
                            Text {
                                anchors.centerIn: parent

                                text: stats_cb.checked ? "✓" : ""

                                color: "#36A9FF"

                                font.family: glonto.font.family
                                font.pixelSize: 19
                                font.bold: true

                                opacity: stats_cb.checked ? 1 : 0

                                Behavior on opacity {
                                    NumberAnimation {
                                        duration: 120
                                    }
                                }
                            }
                        }

                        // Свечение
                        MultiEffect {
                            id: stats_cb_effect

                            source: stats_cb_background

                            anchors.fill: stats_cb_background

                            shadowEnabled: true

                            shadowColor: stats_cb.checked
                                         ? "#2878FF"
                                         : "transparent"

                            shadowBlur: stats_cb.checked ? 12 : 0

                            shadowHorizontalOffset: 0
                            shadowVerticalOffset: 0

                            Behavior on shadowColor {
                                ColorAnimation {
                                    duration: 150
                                }
                            }

                            Behavior on shadowBlur {
                                NumberAnimation {
                                    duration: 150
                                }
                            }

                            z: -1
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
                        color: "white"
                        anchors.verticalCenter: parent.verticalCenter
                        width: 300
                    }
                    CheckBox {
                        id: negative_cb
                        objectName: "negative_cb"

                        width: 25
                        height: 25

                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: 3

                        onCheckedChanged: {

                            if (checked) {
                                backend.enable_negatives(true)

                                example_text.font.pointSize = example_text.font.pointSize - 2
                                userinput.font.pixelSize = userinput.font.pixelSize - 2

                                //right_answer.font.pointSize =
                                        //right_answer.font.pointSize - 10

                                example_text.y = example_text.y + 5
                                userinput.y = userinput.y + 5
                            }

                            else {
                                backend.enable_negatives(false)


                                example_text.font.pointSize = example_text.font.pointSize + 2
                                userinput.font.pixelSize = userinput.font.pixelSize + 2

                                //right_answer.font.pointSize =
                                        //right_answer.font.pointSize + 10

                                example_text.y = example_text.y - 5
                                userinput.y = userinput.y - 5
                            }

                            backend.choose_sign()
                            backend.set_numbers()
                        }


                        // ─────────────────────────────
                        // CHECKBOX
                        // ─────────────────────────────

                        indicator: Rectangle {
                            id: negative_cb_background

                            width: 25
                            height: 25

                            anchors.centerIn: parent

                            radius: 9

                            color: negative_cb.checked
                                   ? "#102A5A"
                                   : "#0B1733"

                            border.width: 2

                            border.color: negative_cb.checked
                                          ? "#2979FF"
                                          : "#667FB7"


                            Behavior on color {
                                ColorAnimation {
                                    duration: 150
                                }
                            }

                            Behavior on border.color {
                                ColorAnimation {
                                    duration: 150
                                }
                            }


                            // Галочка
                            Text {
                                anchors.centerIn: parent

                                text: negative_cb.checked ? "✓" : ""

                                color: "#36A9FF"

                                font.family: glonto.font.family
                                font.pixelSize: 19
                                font.bold: true

                                opacity: negative_cb.checked ? 1 : 0

                                Behavior on opacity {
                                    NumberAnimation {
                                        duration: 120
                                    }
                                }
                            }
                        }


                        // ─────────────────────────────
                        // GLOW
                        // ─────────────────────────────

                        MultiEffect {
                            id: negative_cb_effect

                            source: negative_cb_background

                            anchors.fill: negative_cb_background

                            shadowEnabled: true

                            shadowColor: negative_cb.checked
                                         ? "#2878FF"
                                         : "transparent"

                            shadowBlur: negative_cb.checked ? 12 : 0

                            shadowHorizontalOffset: 0
                            shadowVerticalOffset: 0

                            Behavior on shadowColor {
                                ColorAnimation {
                                    duration: 150
                                }
                            }

                            Behavior on shadowBlur {
                                NumberAnimation {
                                    duration: 150
                                }
                            }

                            z: -1
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
                        color: "white"
                        anchors.verticalCenter: parent.verticalCenter
                        width: 300
                    }
                    CheckBox {
                        id: brackets_cb
                        objectName: "brackets_cb"

                        width: 25
                        height: 25

                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: 3

                        onCheckedChanged: {

                            if (checked) {
                                backend.enable_brackets(true)

                                example_text.font.pointSize = example_text.font.pointSize - 12
                                userinput.font.pixelSize = userinput.font.pixelSize - 12


                                //right_answer.font.pointSize =
                                        //right_answer.font.pointSize - 10

                                example_text.y = example_text.y + 5
                                userinput.y = userinput.y + 5
                            }

                            else {
                                backend.enable_brackets(false)

                                example_text.font.pointSize = example_text.font.pointSize + 12
                                userinput.font.pixelSize = userinput.font.pixelSize + 12


                                //right_answer.font.pointSize =
                                        //right_answer.font.pointSize + 10

                                example_text.y = example_text.y - 5
                                userinput.y = userinput.y - 5
                            }

                            backend.choose_sign()
                            backend.set_numbers()
                        }


                        // ─────────────────────────────
                        // CHECKBOX
                        // ─────────────────────────────

                        indicator: Rectangle {
                            id: brackets_cb_background

                            width: 25
                            height: 25

                            anchors.centerIn: parent

                            radius: 9

                            color: brackets_cb.checked
                                   ? "#102A5A"
                                   : "#0B1733"

                            border.width: 2

                            border.color: brackets_cb.checked
                                          ? "#2979FF"
                                          : "#667FB7"


                            Behavior on color {
                                ColorAnimation {
                                    duration: 150
                                }
                            }

                            Behavior on border.color {
                                ColorAnimation {
                                    duration: 150
                                }
                            }


                            // Галочка
                            Text {
                                anchors.centerIn: parent

                                text: brackets_cb.checked ? "✓" : ""

                                color: "#36A9FF"

                                font.family: glonto.font.family
                                font.pixelSize: 19
                                font.bold: true

                                opacity: brackets_cb.checked ? 1 : 0

                                Behavior on opacity {
                                    NumberAnimation {
                                        duration: 120
                                    }
                                }
                            }
                        }


                        // ─────────────────────────────
                        // GLOW
                        // ─────────────────────────────

                        MultiEffect {
                            id: brackets_cb_effect

                            source: brackets_cb_background

                            anchors.fill: brackets_cb_background

                            shadowEnabled: true

                            shadowColor: brackets_cb.checked
                                         ? "#2878FF"
                                         : "transparent"

                            shadowBlur: brackets_cb.checked ? 12 : 0

                            shadowHorizontalOffset: 0
                            shadowVerticalOffset: 0

                            Behavior on shadowColor {
                                ColorAnimation {
                                    duration: 150
                                }
                            }

                            Behavior on shadowBlur {
                                NumberAnimation {
                                    duration: 150
                                }
                            }

                            z: -1
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
                        color: "white"
                        anchors.verticalCenter: parent.verticalCenter
                        width: 300
                    }
                    CheckBox {
                        id: timer_cb

                        width: 25
                        height: 25

                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: 3

                        objectName: "timer_cb"

                        onCheckedChanged: {
                            if (checked) {
                                progress_bar_background.visible = true
                                progress_bar.width = 100
                                seconds_row.visible = true
                                settings_rectangle.height = 300
                                settings_column.anchors.verticalCenterOffset = -20
                                backend.enable_timer(true)
                                seconds_row.anchors.verticalCenterOffset = 95
                                seconds_userinput.focus = true
                                levels_text.anchors.verticalCenterOffset = -122
                            }
                            else {
                                progress_bar_background.visible = false
                                levels_text.anchors.verticalCenterOffset = -102
                                seconds_row.visible = false
                                settings_rectangle.height = 250
                                settings_column.anchors.verticalCenterOffset = 0
                                backend.enable_timer(false)
                                seconds_row.anchors.verticalCenterOffset = 115
                                seconds_userinput.focus = false
                            }
                        }

                        indicator: Rectangle {
                            id: timer_cb_background

                            width: 25
                            height: 25

                            anchors.centerIn: parent

                            radius: 9

                            color: timer_cb.checked
                                   ? "#102A5A"
                                   : "#0B1733"

                            border.width: 2

                            border.color: timer_cb.checked
                                          ? "#2979FF"
                                          : "#667FB7"

                            Behavior on color {
                                ColorAnimation {
                                    duration: 150
                                }
                            }

                            Behavior on border.color {
                                ColorAnimation {
                                    duration: 150
                                }
                            }

                            // Галочка
                            Text {
                                anchors.centerIn: parent

                                text: timer_cb.checked ? "✓" : ""

                                color: "#36A9FF"

                                font.family: glonto.font.family
                                font.pixelSize: 19
                                font.bold: true

                                opacity: timer_cb.checked ? 1 : 0

                                Behavior on opacity {
                                    NumberAnimation {
                                        duration: 120
                                    }
                                }
                            }
                        }

                        // Свечение
                        MultiEffect {
                            id: timer_cb_effect

                            source: timer_cb_background

                            anchors.fill: timer_cb_background

                            shadowEnabled: true

                            shadowColor: timer_cb.checked
                                         ? "#2878FF"
                                         : "transparent"

                            shadowBlur: timer_cb.checked ? 12 : 0

                            shadowHorizontalOffset: 0
                            shadowVerticalOffset: 0

                            Behavior on shadowColor {
                                ColorAnimation {
                                    duration: 150
                                }
                            }

                            Behavior on shadowBlur {
                                NumberAnimation {
                                    duration: 150
                                }
                            }

                            z: -1
                        }
                    }
                }
            
            }
            
        }
        
        
    }

}
