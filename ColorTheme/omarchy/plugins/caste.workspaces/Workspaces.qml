import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import qs.Commons
import qs.Ui

BarWidget {
  id: root

  moduleName: "caste.workspaces"

  function workspaceById(id) {
    var values = Hyprland.workspaces.values

    for (var i = 0; i < values.length; i++) {
      if (values[i].id === id)
        return values[i]
    }

    return null
  }

  function workspaceIds() {
    var ids = [1, 2, 3, 4, 5, 6]
    var values = Hyprland.workspaces.values

    for (var i = 0; i < values.length; i++) {
      var id = values[i].id

      if (id > 6 && id <= 10 && ids.indexOf(id) === -1)
        ids.push(id)
    }

    ids.sort(function(left, right) {
      return left - right
    })

    return ids
  }

  function focusWorkspace(id) {
    if (!root.bar)
      return

    root.bar.run(
      "hyprctl dispatch " +
      Util.shellQuote(
        "hl.dsp.focus({ workspace = \"" + id + "\" })"
      )
    )
  }

  implicitWidth: grid.implicitWidth + 16
  implicitHeight: grid.implicitHeight

GridLayout {
    id: grid

    anchors.centerIn: parent

    columns: root.vertical ? 1 : root.workspaceIds().length

    columnSpacing: root.vertical ? 0 : 4
    rowSpacing: root.vertical ? 4 : 0

    Repeater {
      model: root.workspaceIds()

      Item {
        required property int modelData

        readonly property var workspace:
          root.workspaceById(modelData)

        readonly property bool occupied:
          workspace !== null &&
          workspace.toplevels.values.length > 0

        readonly property bool focused:
          Hyprland.focusedWorkspace !== null &&
          Hyprland.focusedWorkspace.id === modelData

        implicitWidth: 28
        implicitHeight: 30

        MouseArea {
          anchors.fill: parent

          cursorShape: Qt.PointingHandCursor

          onClicked: root.focusWorkspace(modelData)
        }

        // WORKSPACE ACTIVO
        Text {
          visible: focused

          anchors.centerIn: parent

          text: "󰚌"

          font.family: "JetBrainsMono Nerd Font"
          font.pixelSize: 20
          font.weight: Font.Normal

          color: "#9ece6a"

          verticalAlignment: Text.AlignVCenter
          horizontalAlignment: Text.AlignHCenter
        }

        // WORKSPACE CON VENTANAS
        Text {
          visible: !focused && occupied

          anchors.centerIn: parent

          text: "󰊠"

          font.family: "JetBrainsMono Nerd Font"
          font.pixelSize: 15
          font.weight: Font.Normal

          color: "#7aa2f7"

          verticalAlignment: Text.AlignVCenter
          horizontalAlignment: Text.AlignHCenter
        }

        // WORKSPACE VACÍO
        Text {
          visible: !focused && !occupied

          anchors.centerIn: parent

          text: ""

          font.family: "JetBrainsMono Nerd Font"
          font.pixelSize: 10
          font.weight: Font.Normal

          color: "#583794"
          opacity: 0.5

          verticalAlignment: Text.AlignVCenter
          horizontalAlignment: Text.AlignHCenter
        }
      }
    }
  }
}
