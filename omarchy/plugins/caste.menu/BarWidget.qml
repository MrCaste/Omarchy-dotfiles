import QtQuick
import qs.Ui

BarWidget {
  id: root

  moduleName: "caste.menu"

  implicitWidth: content.implicitWidth + 20
  implicitHeight: content.implicitHeight + 12

  Item {
    anchors.fill: parent

    Text {
      id: content

      anchors.centerIn: parent

      text: ""

      font.family: "JetbrainsMono Nerd Font"
      font.pixelSize: 18
      font.bold: true

      color: "#9ece6a"

      verticalAlignment: Text.AlignVCenter
      horizontalAlignment: Text.AlignHCenter
    }

    MouseArea {
      anchors.fill: parent

      acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

      cursorShape: Qt.PointingHandCursor

      onClicked: function(mouse) {
        if (!root.bar)
          return

        if (mouse.button === Qt.RightButton) {
          root.bar.run("xdg-terminal-exec")
        } else {
          root.bar.run(
            "omarchy-shell shell toggle omarchy.menu '{\"menu\":\"root\"}'"
          )
        }
      }
    }
  }
}
