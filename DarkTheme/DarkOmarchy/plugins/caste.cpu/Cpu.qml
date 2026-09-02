import QtQuick
import Quickshell
import Quickshell.Io
import qs.Ui

BarWidget {
    id: root

    moduleName: "caste.cpu"

    anchors.verticalCenter: parent.verticalCenter

    property string cpuText: "0%"

    implicitWidth: content.childrenRect.width + 20
    implicitHeight: content.childrenRect.height + 12

    Process {
        id: cpuProcess

        command: [
            "bash",
            "-c",
            "top -bn1 | grep 'Cpu(s)' | awk '{print 100 - $8}'"
        ]

        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                var value = parseFloat(text.trim())

                if (!isNaN(value))
                    root.cpuText = Math.round(value) + "%"
            }
        }
    }

    function updateCpu() {
        cpuProcess.running = false
        cpuProcess.running = true
    }

    Timer {
        interval: 5000
        running: true
        repeat: true

        onTriggered: root.updateCpu()
    }

    Item {
        anchors.fill: parent

        Row {
            id: content

            anchors.centerIn: parent
            spacing: 5

            Text {
                text: "󰍛"

                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 14
                font.weight: Font.Bold

                color: "#f7768e"

                verticalAlignment: Text.AlignVCenter
            }

          Text {
            text: root.cpuText

            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 14
            font.weight: Font.Bold

            color: "#c0c0cc"

            anchors.verticalCenter: parent.verticalCenter
          }
        }

        MouseArea {
            anchors.fill: parent

            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

            cursorShape: Qt.PointingHandCursor

            onClicked: function(mouse) {
                if (!root.bar)
                    return

                if (mouse.button === Qt.RightButton)
                    root.bar.run("alacritty")
                else
                    root.bar.run("omarchy-launch-or-focus-tui btop")
            }
        }
    }

  }
