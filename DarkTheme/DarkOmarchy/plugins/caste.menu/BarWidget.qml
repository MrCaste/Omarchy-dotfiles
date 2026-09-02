import QtQuick
import qs.Ui

BarWidget {
  id: root

  moduleName: "caste.menu"

  implicitWidth: content.implicitWidth + 30
  implicitHeight: content.implicitHeight + 12

  Item {
    anchors.fill: parent

    Text {
      id: content

      anchors.centerIn: parent
      anchors.horizontalCenterOffset: -3   // prueba valores pequeños: -2, -1, 1, 2
      anchors.verticalCenterOffset: -1

      text: ""

      font.family: "JetbrainsMono Nerd Font"
      font.pixelSize: 18
      font.bold: true

      color: "#c0c0cc"

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
