import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Bluetooth
import Quickshell.Io
import qs.Ui

BarWidget {
  id: root

  moduleName: "caste.tray"

  property bool expanded: false
  property string spotifyText: ""
  property string spotifyStatus: ""

  readonly property var adapter: Bluetooth.defaultAdapter

  readonly property bool bluetoothEnabled:
    adapter !== null && adapter.enabled

  readonly property bool bluetoothConnected:
    adapter !== null &&
    adapter.devices.values.some(function(device) {
      return device.connected
    })

  implicitWidth: content.implicitWidth
  implicitHeight: content.implicitHeight

  HoverHandler {
    id: trayHover

    onHoveredChanged: {
      root.expanded = hovered
    }
  }

  // =========================
  // SPOTIFY
  // =========================

  Process {
    id: spotifyProcess

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
          root.spotifyText = ""
          root.spotifyStatus = ""
          return
        }

        var parts = output.split("|")

        if (parts.length >= 3) {
          root.spotifyStatus = parts[0]

          var artist = parts[1]
          var title = parts[2]

          var result = artist + " - " + title

          if (result.length > 40)
            result = result.substring(0, 40) + "..."

          root.spotifyText = result
        }
      }
    }
  }

  function updateSpotify() {
    spotifyProcess.running = false
    spotifyProcess.running = true
  }

  Timer {
    interval: 2000
    running: true
    repeat: true

    onTriggered: root.updateSpotify()
  }

  // =========================
  // CONTENIDO DEL TRAY
  // =========================

  Row {
    id: content

    spacing: 5

    anchors.verticalCenter: parent.verticalCenter

    // =========================
    // FLECHA
    // =========================

    WidgetButton {
      id: expandButton

      bar: root.bar

      text: ""

      horizontalMargin: 8
      verticalPadding: 8

      anchors.verticalCenter: parent.verticalCenter
    }

    // =========================
    // ÁREA EXPANDIBLE
    // =========================

    Item {
      id: expandableArea

      clip: true

      anchors.verticalCenter: parent.verticalCenter

      implicitWidth:
        root.expanded
          ? pillsRow.implicitWidth
          : 0

      implicitHeight: pillsRow.implicitHeight

      Behavior on implicitWidth {
        NumberAnimation {
          duration: 600
          easing.type: Easing.InOutCubic
        }
      }

      // =========================
      // PILLS
      // =========================

      Row {
        id: pillsRow

        anchors.verticalCenter: parent.verticalCenter

        spacing: 5

        // =========================
        // SPOTIFY
        // =========================

        Item {
          id: spotifyPill

          implicitWidth: root.spotifyText === ""
              ? 34
              : spotifyRow.implicitWidth + 20

          implicitHeight: 30

          Rectangle {
              anchors.fill: parent
              radius: 18
              color: "#222330"
          }

          // Spotify SOLO
          Text {
              id: spotifyIconOnly

              visible: root.spotifyText === ""

              anchors.centerIn: parent

              text: ""

              font.family: "JetBrainsMono Nerd Font"
              font.pixelSize: 16
              font.weight: Font.Bold

              color: "#9ece6a"

              // IMPORTANTE:
              // no width, no height, no x
              // dejamos que el Text tenga exactamente el tamaño
              // que necesita el glifo.
          }

          // Spotify + canción
          Row {
              id: spotifyRow

              visible: root.spotifyText !== ""

              anchors.centerIn: parent

              spacing: 8

              Text {
                  text: ""

                  font.family: "JetBrainsMono Nerd Font"
                  font.pixelSize: 14
                  font.weight: Font.Bold

                  color: "#9ece6a"

                  anchors.verticalCenter: parent.verticalCenter
              }

              Text {
                  text: root.spotifyText

                  anchors.verticalCenter: parent.verticalCenter

                  font.family: "JetBrainsMono Nerd Font"
                  font.pixelSize: 14
                  font.weight: Font.Bold

                  color: root.spotifyStatus === "Paused"
                      ? "#8b8b8b"
                      : "#F1F1F1"

                  verticalAlignment: Text.AlignVCenter
              }
          }

          MouseArea {
              anchors.fill: parent

              acceptedButtons:
                  Qt.LeftButton |
                  Qt.RightButton |
                  Qt.MiddleButton

              cursorShape: Qt.PointingHandCursor

              onClicked: function(mouse) {
                  if (!root.bar)
                      return

                  if (mouse.button === Qt.RightButton)
                      root.bar.run("playerctl -p spotify next")
                  else if (mouse.button === Qt.MiddleButton)
                      root.bar.run("playerctl -p spotify previous")
                  else
                      root.bar.run("playerctl -p spotify play-pause")
              }
          }
      }

        // =========================
        // BLUETOOTH
        // =========================

        Item {
          id: bluetoothPill

          implicitWidth:
            bluetoothContent.implicitWidth + 20

          implicitHeight: 30

          Rectangle {
            anchors.fill: parent

            radius: 18
            color: "#222330"
          }

          Text {
            id: bluetoothContent

            anchors.centerIn: parent

            text: {
              if (!root.bluetoothEnabled)
                return "󰂲"

              if (root.bluetoothConnected)
                return "󰂱"

              return ""
            }

            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 18
            font.weight: Font.Bold

            color: "#7aa2f7"

            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
          }

          MouseArea {
            anchors.fill: parent

            acceptedButtons:
              Qt.LeftButton |
              Qt.RightButton |
              Qt.MiddleButton

            cursorShape: Qt.PointingHandCursor

            onClicked: {
              if (root.bar)
                root.bar.run("omarchy-launch-bluetooth")
            }
          }
        }
      }
    }
  }
}
