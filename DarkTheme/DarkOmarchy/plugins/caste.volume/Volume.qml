import QtQuick
import Quickshell
import Quickshell.Io
import qs.Ui

BarWidget {
  id: root

  moduleName: "caste.volume"

  property int volume: 0
  property bool muted: false

  implicitWidth: content.implicitWidth + 20
  implicitHeight: content.implicitHeight + 12

  Process {
    id: volumeProcess

    command: [
      "bash",
      "-c",
      "wpctl get-volume @DEFAULT_AUDIO_SINK@ | " +
      "awk '{printf \"%.0f|%s\", $2 * 100, ($3 == \"[MUTED]\" ? \"muted\" : \"unmuted\")}'"
    ]

    running: true

    stdout: StdioCollector {
      onStreamFinished: {
        var parts = text.trim().split("|")

        if (parts.length >= 2) {
          var value = parseInt(parts[0])

          if (!isNaN(value)) {
            root.volume = value
            root.muted = parts[1] === "muted"
          }
        }
      }
    }
  }

  function updateVolume() {
    volumeProcess.running = false
    volumeProcess.running = true
  }

  Timer {
    interval: 1000
    running: true
    repeat: true

    onTriggered: root.updateVolume()
  }

  Item {
    anchors.fill: parent

    Row {
      id: content

      anchors.centerIn: parent
      spacing: 5

      Text {
        text: {
          if (root.muted)
            return "󰖁"

          if (root.volume === 0)
            return "󰕿"

          if (root.volume < 50)
            return "󰖀"

          return "󰕾"
        }

        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 14
        font.weight: Font.Bold

        color: "#7aa2f7"

        verticalAlignment: Text.AlignVCenter
      }

      Text {
        text: root.muted ? "" : root.volume + "%"

        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 14
        font.weight: Font.Bold

        color: "#c0c0cc"

        verticalAlignment: Text.AlignVCenter
      }
    }

    MouseArea {
      anchors.fill: parent

      acceptedButtons: Qt.LeftButton | Qt.RightButton

      cursorShape: Qt.PointingHandCursor

      onClicked: function(mouse) {
        if (mouse.button === Qt.RightButton) {
          root.bar.run("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")
          root.updateVolume()
        } else if (mouse.button === Qt.LeftButton) {
          root.bar.run("omarchy-launch-audio")
        }
      }
    }
  }
}
