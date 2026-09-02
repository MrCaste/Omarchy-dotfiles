import QtQuick
import Quickshell
import Quickshell.Io
import qs.Ui

BarWidget {
  id: root

  moduleName: "caste.spotify"

  property string trackText: ""
  property string playerStatus: ""

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  Process {
    id: playerProcess

    command: [
      "bash",
      "-c",
      "status=$(playerctl -p spotify status 2>/dev/null); " +
      "if [ -z \"$status\" ]; then exit 0; fi; " +
      "artist=$(playerctl -p spotify metadata artist 2>/dev/null); " +
      "title=$(playerctl -p spotify metadata title 2>/dev/null); " +
      "printf '%s|%s|%s\\n' \"$status\" \"$artist\" \"$title\""
    ]

    running: true

    stdout: StdioCollector {
      onStreamFinished: {
        var output = text.trim()

        if (output === "") {
          root.trackText = ""
          root.playerStatus = ""
          return
        }

        var parts = output.split("|")

        if (parts.length >= 3) {
          root.playerStatus = parts[0]

          var artist = parts[1]
          var title = parts[2]

          var result = artist + " - " + title

          if (result.length > 40)
            result = result.substring(0, 40) + "..."

          root.trackText = result
        }
      }
    }
  }

  function updatePlayer() {
    playerProcess.running = false
    playerProcess.running = true
  }

  Timer {
    interval: 2000
    running: true
    repeat: true

    onTriggered: root.updatePlayer()
  }

  // =========================
  // SPOTIFY PILL
  // =========================

  WidgetButton {
    id: button

    anchors.fill: parent

    bar: root.bar

    horizontalMargin: 10
    verticalPadding: 8

    text: ""

    contentItem: Item {

      Row {
        anchors.centerIn: parent

        spacing: 8

        Text {
          id: spotifyIcon

          text: ""

          width: 18
          height: 18

          anchors.verticalCenter: parent.verticalCenter

          font.family: "JetBrainsMono Nerd Font"
          font.pixelSize: 14
          font.weight: Font.Bold

          color: "#9ece6a"

          verticalAlignment: Text.AlignVCenter
          horizontalAlignment: Text.AlignHCenter
        }

        Text {
          id: spotifyTitle

          text: root.trackText

          anchors.verticalCenter: parent.verticalCenter

          font.family: "JetBrainsMono Nerd Font"
          font.pixelSize: 14
          font.weight: Font.Bold

          color:
            root.playerStatus === "Paused"
              ? "#8b8b8b"
              : "#F1F1F1"

          verticalAlignment: Text.AlignVCenter
        }
      }
    }

    onPressed: function(b) {
      if (b === Qt.RightButton)
        root.bar.run("playerctl -p spotify next")
      else if (b === Qt.MiddleButton)
        root.bar.run("playerctl -p spotify previous")
      else
        root.bar.run("playerctl -p spotify play-pause")
    }
  }
}
