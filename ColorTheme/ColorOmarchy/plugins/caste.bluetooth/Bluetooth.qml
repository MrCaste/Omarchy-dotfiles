import QtQuick
import Quickshell
import Quickshell.Bluetooth
import qs.Ui

BarWidget {
  id: root

  moduleName: "caste.bluetooth"

  readonly property var adapter: Bluetooth.defaultAdapter

  readonly property bool hasAdapter:
    adapter !== null

  readonly property bool enabled:
    hasAdapter && adapter.enabled

  readonly property int connectedDevices:
    Bluetooth.devices.values.filter(function(device) {
      return device.connected
    }).length

  readonly property bool connected:
    connectedDevices > 0

  readonly property string bluetoothText: {
    if (!hasAdapter)
      return ""

    if (!enabled)
      return "󰂲"

    if (connected)
      return "󰂱"

    return ""
  }

  implicitWidth: content.implicitWidth + 20
  implicitHeight: content.implicitHeight + 12

  Item {
    anchors.fill: parent

    Text {
      id: content

      anchors.centerIn: parent

      text: root.bluetoothText

      font.family: "JetBrainsMono Nerd Font"
      font.pixelSize: 18
      font.weight: Font.Bold

      color: "#7aa2f7"

      verticalAlignment: Text.AlignVCenter
      horizontalAlignment: Text.AlignHCenter
    }

    MouseArea {
      anchors.fill: parent

      acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

      cursorShape: Qt.PointingHandCursor

      onClicked: {
        if (root.bar)
          root.bar.run("omarchy-launch-bluetooth")
      }
    }
  }
}
