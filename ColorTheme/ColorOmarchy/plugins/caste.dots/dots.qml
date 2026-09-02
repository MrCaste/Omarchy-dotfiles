import QtQuick
import qs.Ui

BarWidget {
  id: root

  moduleName: "caste.dots"

  implicitWidth: content.implicitWidth
  implicitHeight: content.implicitHeight

  Item {
    anchors.fill: parent

    Text {
      id: content

      anchors.centerIn: parent

      text: "⋮ "

      font.family: "JetBrainsMono Nerd Font"
      font.pixelSize: 18
      font.bold: true

      color: "#F1F1F1"

      verticalAlignment: Text.AlignVCenter
      horizontalAlignment: Text.AlignHCenter
    }
  }
}
