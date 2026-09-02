import QtQuick
import Quickshell
import Quickshell.Io
import qs.Ui

BarWidget {
  id: root

  moduleName: "caste.network"   // debe coincidir EXACTO con moduleName en Panel.qml

  property string networkText: "Disconnected"
  property string networkIcon: "󰤮"
  property string tooltipText: "Disconnected"
  property bool connected: false

  property string previousRx: "0"
  property real lastUpdateTime: 0

  // --- conexión con el panel (esto es lo que faltaba) ---
  readonly property bool opened: panelLoader.item
    ? panelLoader.item.opened === true
    : false
  readonly property bool popoutSwitchClosing: panelLoader.item
    ? panelLoader.item.popoutSwitchClosing === true
    : false

  function open() {
    if (panelLoader.item) panelLoader.item.open()
  }

  function close() {
    if (panelLoader.item) panelLoader.item.close()
  }

  function toggle() {
    if (panelLoader.item) panelLoader.item.toggle()
  }

  function closeForPopoutSwitch() {
    if (panelLoader.item) panelLoader.item.closeForPopoutSwitch()
  }

  function injectPanel() {
    if (!panelLoader.item) return
    panelLoader.item.bar = root.bar
    panelLoader.item.anchorItem = root
    panelLoader.item.hostWidget = root
  }

  onBarChanged: injectPanel()

  Loader {
    id: panelLoader
    active: true
    source: Qt.resolvedUrl("Panel.qml")
    visible: false
    onLoaded: {
      root.injectPanel()
      Qt.callLater(root.injectPanel)
    }
  }
  // --- fin conexión con el panel ---

  implicitWidth: content.implicitWidth + 20
  implicitHeight: content.implicitHeight + 12

  function updateNetwork() {
    process.running = false
    process.running = true
  }

  function formatSpeed(bytesPerSec) {
    if (bytesPerSec < 1024)
      return bytesPerSec.toFixed(0) + " B/s"
    if (bytesPerSec < 1024 * 1024)
      return (bytesPerSec / 1024).toFixed(1) + " KB/s"
    return (bytesPerSec / (1024 * 1024)).toFixed(1) + " MB/s"
  }

  function applyRx(rxStr) {
    var now = Date.now()
    var rx = parseInt(rxStr)

    if (root.lastUpdateTime > 0 && !isNaN(rx)) {
      var deltaBytes = rx - parseInt(root.previousRx)
      var deltaTime = (now - root.lastUpdateTime) / 1000

      if (deltaTime > 0 && deltaBytes >= 0) {
        root.networkText = root.formatSpeed(deltaBytes / deltaTime)
      } else {
        root.networkText = "0 B/s"
      }
    } else {
      root.networkText = "0 B/s"
    }

    root.previousRx = rxStr
    root.lastUpdateTime = now
  }

  Process {
    id: process

    command: [
      "bash",
      "-c",
      "state=$(nmcli -t -f GENERAL.STATE,GENERAL.CONNECTION device show 2>/dev/null | " +
      "grep '^GENERAL.STATE:' | head -1 | cut -d: -f2-); " +

      "if echo \"$state\" | grep -q '^100'; then " +

      "  connection=$(nmcli -t -f GENERAL.CONNECTION device show 2>/dev/null | " +
      "grep '^GENERAL.CONNECTION:' | head -1 | cut -d: -f2-); " +

      "  wifidev=$(nmcli -t -f DEVICE,TYPE,STATE device 2>/dev/null | " +
      "awk -F: '$2 == \"wifi\" && $3 == \"connected\" {print $1; exit}'); " +

      "  if [ -n \"$wifidev\" ]; then " +

      "    signal=$(nmcli -t -f IN-USE,SIGNAL dev wifi 2>/dev/null | " +
      "awk -F: '$1 == \"*\" {print $2; exit}'); " +

      "    if [ -z \"$signal\" ]; then signal=0; fi; " +

      "    if [ \"$signal\" -ge 80 ]; then icon='󰤨'; " +
      "    elif [ \"$signal\" -ge 60 ]; then icon='󰤥'; " +
      "    elif [ \"$signal\" -ge 40 ]; then icon='󰤢'; " +
      "    elif [ \"$signal\" -ge 20 ]; then icon='󰤟'; " +
      "    else icon='󰤯'; fi; " +

      "    rx=$(cat /sys/class/net/$wifidev/statistics/rx_bytes 2>/dev/null || echo 0); " +
      "    printf 'WIFI|%s|%s|%s|%s' \"$icon\" \"$connection\" \"$signal\" \"$rx\"; " +

      "  else " +

      "    ethdev=$(nmcli -t -f DEVICE,TYPE,STATE device 2>/dev/null | " +
      "awk -F: '$2 == \"ethernet\" && $3 == \"connected\" {print $1; exit}'); " +

      "    rx=$(cat /sys/class/net/$ethdev/statistics/rx_bytes 2>/dev/null || echo 0); " +
      "    printf 'ETHERNET|%s|%s' \"$connection\" \"$rx\"; " +

      "  fi; " +

      "else " +
      "  printf 'DISCONNECTED'; " +
      "fi"
    ]

    running: true

    stdout: StdioCollector {
      onStreamFinished: {
        var result = text.trim()

        if (result === "") {
          root.networkText = "Disconnected"
          root.networkIcon = "󰤮"
          root.tooltipText = "Disconnected"
          root.connected = false
          root.previousRx = "0"
          root.lastUpdateTime = 0
          return
        }

        var parts = result.split("|")
        var type = parts[0]

        if (type === "WIFI") {
          root.networkIcon = parts[1]
          root.tooltipText = parts[3] + "% • " + parts[2]
          root.connected = true
          root.applyRx(parts[4])
        }
        else if (type === "ETHERNET") {
          root.networkIcon = "󰀂"
          root.tooltipText = "Connected" + (parts[1] ? " • " + parts[1] : "")
          root.connected = true
          root.applyRx(parts[2])
        }
        else {
          root.networkIcon = "󰤮"
          root.networkText = "Disconnected"
          root.tooltipText = "Disconnected"
          root.connected = false
          root.previousRx = "0"
          root.lastUpdateTime = 0
        }
      }
    }
  }

  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: root.updateNetwork()
  }

  Item {
    anchors.fill: parent

    Row {
      id: content
      anchors.centerIn: parent
      spacing: 5

      Text {
        text: root.networkIcon
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 14
        font.weight: Font.Bold
        color: root.connected ? "#9ece6a" : "#f7768e"
        verticalAlignment: Text.AlignVCenter
      }

      Text {
        text: root.networkText
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 14
        font.weight: Font.Bold
        color: root.connected ? "#e0af68" : "#f7768e"
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
      }
    }

    MouseArea {
      anchors.fill: parent
      acceptedButtons: Qt.LeftButton
      cursorShape: Qt.PointingHandCursor
      onClicked: root.toggle()   // ← usa el toggle del panel, no IPC externo
    }

    MouseArea {
      id: mouse
      anchors.fill: parent
      hoverEnabled: true
      acceptedButtons: Qt.NoButton
    }

    PanelToolTip {
      visible: mouse.containsMouse
      text: root.tooltipText
      fontFamily: "JetBrainsMono Nerd Font"
    }
  }
}
