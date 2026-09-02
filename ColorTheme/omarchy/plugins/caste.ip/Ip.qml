import QtQuick
import Quickshell
import Quickshell.Io
import qs.Ui

BarWidget {
  id: root

  moduleName: "caste.ip"

  property string ipText: "󰈀  sin conexión"

  implicitWidth: content.implicitWidth + 20
  implicitHeight: content.implicitHeight + 12

  Process {
    id: ipProcess

    command: [
      "bash",
      "-c",
      "vpn_iface=$(ip -o -4 addr show | awk '{print $2}' | grep -E '^(tun|wg|ht-tun)' | head -n1); " +
      "if [ -n \"$vpn_iface\" ]; then " +
      "ip_addr=$(ip -4 addr show \"$vpn_iface\" | grep -oP '(?<=inet\\s)\\d+(\\.\\d+){3}'); " +
      "printf '󰖂  %s' \"$ip_addr\"; " +
      "else " +
      "main_iface=$(ip route get 1.1.1.1 2>/dev/null | awk '{print $5; exit}'); " +
      "ip_addr=$(ip -4 addr show \"$main_iface\" 2>/dev/null | grep -oP '(?<=inet\\s)\\d+(\\.\\d+){3}'); " +
      "printf '󰈀  %s' \"${ip_addr:-sin conexión}\"; " +
      "fi"
    ]

    running: true

    stdout: StdioCollector {
      onStreamFinished: {
        var result = text.trim()

        if (result.length > 0)
          root.ipText = result
      }
    }
  }

  function updateIp() {
    ipProcess.running = false
    ipProcess.running = true
  }

  Timer {
    interval: 5000
    running: true
    repeat: true

    onTriggered: root.updateIp()
  }

  Item {
    anchors.fill: parent

    Row {
      id: content

      anchors.centerIn: parent

      Text {
        text: root.ipText

        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 14
        font.weight: Font.Bold

        color: "#7aa2f7"

        verticalAlignment: Text.AlignVCenter
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
      }
    }
  }
}
