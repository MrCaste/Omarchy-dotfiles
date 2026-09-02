import QtQuick
import Quickshell
import Quickshell.Io
import qs.Ui

BarWidget {
  id: root

  moduleName: "caste.target"

  property string targetText: "No target"

  implicitWidth: content.implicitWidth + 20
  implicitHeight: content.implicitHeight + 12

  function updateTarget() {
    process.running = false
    process.running = true
  }

  Process {
    id: process

    command: [
      "bash",
      "-c",
      "if [ -f /home/caste/.config/bin/target ]; then " +
      "ip=$(awk '{print $1}' /home/caste/.config/bin/target); " +
      "name=$(awk '{print $2}' /home/caste/.config/bin/target); " +
      "if [ -n \"$ip\" ] && [ -n \"$name\" ]; then " +
      "printf '%s - %s' \"$ip\" \"$name\"; " +
      "else printf 'No target'; fi; " +
      "else printf 'No target'; fi"
    ]

    running: true

    stdout: StdioCollector {
      onStreamFinished: {
        var result = text.trim()

        if (result === "")
          result = "No target"

        root.targetText = result
      }
    }
  }

  Timer {
    interval: 1000
    running: true
    repeat: true

    onTriggered: root.updateTarget()
  }

  Item {
    anchors.fill: parent

    Row {
      id: content

      anchors.centerIn: parent
      spacing: 5

      Text {
        text: root.targetText === "No target" ? "" : ""

        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 14
        font.weight: Font.Bold

        color: "#f7768e"

        verticalAlignment: Text.AlignVCenter
      }

      Text {
        text: root.targetText

        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 14
        font.weight: Font.Bold

        color: "#f7768e"

        verticalAlignment: Text.AlignVCenter
      }
    }

    MouseArea {
      anchors.fill: parent

      acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

      cursorShape: Qt.PointingHandCursor

      onClicked: function(mouse) {
        root.updateTarget()
      }
    }
  }
}
