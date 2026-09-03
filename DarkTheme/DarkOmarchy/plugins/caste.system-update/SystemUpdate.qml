import QtQuick
import Quickshell
import Quickshell.Io
import qs.Ui

BarWidget {
  id: root

  moduleName: "omarchy.system-update"

  property bool updateAvailable: false

  visible: updateAvailable
  implicitWidth: content.implicitWidth + 20
  implicitHeight: content.implicitHeight + 12

  function refresh() {
    if (!updateProc.running) updateProc.running = true
  }

  function clear() { updateAvailable = false }

  function runUpdate() {
    if (root.bar) root.bar.run("omarchy-launch-floating-terminal-with-presentation omarchy-update")
  }

  IpcHandler {
    target: "omarchy.system-update"

    function refresh(): void {
      root.broadcast("refresh")
    }

    function clear(): void {
      root.broadcast("clear")
    }
  }

  Process {
    id: updateProc
    command: ["omarchy-update-available"]
    onExited: function(exitCode) {
      root.updateAvailable = exitCode === 0
    }
  }

  Timer {
    interval: 21600000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: root.refresh()
  }

  Item {
    anchors.fill: parent

    Row {
      id: content

      anchors.centerIn: parent
      spacing: 5

      Text {
        text: "󰚰"

        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 14
        font.weight: Font.Bold

        color: "#e0af68"

        verticalAlignment: Text.AlignVCenter
      }

      Text {
        text: "Update"

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
        if (mouse.button === Qt.RightButton)
          root.clear()
        else
          root.runUpdate()
      }
    }
  }
}
