import QtQuick
import Quickshell
import Quickshell.Io
import qs.Ui

BarWidget {
  id: root

  moduleName: "caste.clock"

  property string timeText: ""

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  Process {
    id: clockProcess

    command: [
      "bash",
      "-c",
      "date '+%A %H:%M'"
    ]

    running: true

    stdout: StdioCollector {
      onStreamFinished: {
        var result = text.trim()

        if (result !== "")
          root.timeText = result
      }
    }
  }

  function updateClock() {
    clockProcess.running = false
    clockProcess.running = true
  }

  Timer {
    interval: 1000
    running: true
    repeat: true

    onTriggered: root.updateClock()
  }

  WidgetButton {
    id: button

    anchors.fill: parent
    bar: root.bar

    text: root.timeText

    fontFamily: "JetBrainsMono Nerd Font"
    fontSize: 14
    fontWeight: Font.Bold
    foreground: root.bar.foreground

    horizontalMargin: 10
    verticalPadding: 8

    onPressed: function(b) {
      if (b === Qt.LeftButton)
        root.bar.run("omarchy-launch-calendar")
    }
  }
}
