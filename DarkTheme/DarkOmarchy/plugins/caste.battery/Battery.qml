import QtQuick
import Quickshell
import Quickshell.Io
import qs.Ui

BarWidget {
  id: root

  moduleName: "caste.battery"

  property int batteryPercent: 0
  property bool charging: false

  implicitWidth: content.implicitWidth + 20
  implicitHeight: content.implicitHeight + 12

  Process {
    id: batteryProcess

    command: [
      "bash",
      "-c",
      "capacity=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null); " +
      "status=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null); " +
      "printf '%s|%s' \"$capacity\" \"$status\""
    ]

    running: true

    stdout: StdioCollector {
      onStreamFinished: {
        var parts = text.trim().split("|")

        if (parts.length >= 2) {
          var value = parseInt(parts[0])

          if (!isNaN(value)) {
            root.batteryPercent = value
            root.charging =
              parts[1] === "Charging" ||
              parts[1] === "Full"
          }
        }
      }
    }
  }

  function updateBattery() {
    batteryProcess.running = false
    batteryProcess.running = true
  }

  Timer {
    interval: 5000
    running: true
    repeat: true

    onTriggered: root.updateBattery()
  }

  Item {
    anchors.fill: parent

    Row {
      id: content

      anchors.centerIn: parent
      spacing: 5

      Text {
        text: {
          if (root.charging)
            return "󰂄"

          if (root.batteryPercent >= 80)
            return "󰁹"

          if (root.batteryPercent >= 60)
            return "󰂀"

          if (root.batteryPercent >= 40)
            return "󰁾"

          if (root.batteryPercent >= 20)
            return "󰁼"

          return "󰁺"
        }

        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 14
        font.weight: Font.Bold

        color: {
          if (root.charging)
            return "#9ece6a"

          if (root.batteryPercent >= 80)
            return "#9ece6a"

          if (root.batteryPercent >= 60)
            return "#e0af68"

          if (root.batteryPercent >= 40)
            return "#e0af68"

          if (root.batteryPercent >= 20)
            return "#f7768e"

          return "#f7768e"
        }

        verticalAlignment: Text.AlignVCenter
      }

      Text {
        text: root.batteryPercent + "%"

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
          root.bar.run("omarchy-battery-status")
        } else {
          root.bar.run("omarchy-launch-power-menu")
        }
      }
    }
  }
}
