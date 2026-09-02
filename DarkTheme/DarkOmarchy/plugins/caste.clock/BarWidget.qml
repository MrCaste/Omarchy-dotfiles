import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui
import "Model.js" as Model

BarWidget {
  id: root

  moduleName: "caste.clock"

  property date displayDate: clock.date

  readonly property string configuredFormat: vertical
    ? setting("verticalFormat", "HH\n—\nmm")
    : setting("format", "dddd HH:mm")

  readonly property string configuredAltFormat: vertical
    ? setting("verticalFormatAlt", "dd\nMMM\n'W'ww\n''yy")
    : setting("formatAlt", "d MMMM 'W'ww yyyy")

  readonly property var formatRing: Model.clockFormatRing(
    configuredFormat,
    configuredAltFormat,
    Model.clockFormats(vertical)
  )

  readonly property string activeFormat: configuredFormat
  readonly property string displayText: formatted(displayDate)

  function refresh() {
    displayDate = new Date()

    if (panelLoader.item && panelLoader.item.refresh)
      panelLoader.item.refresh()
  }

  function cycleFormat() {
    var current = String(configuredFormat)
    var next = Model.nextClockFormat(formatRing, current)

    if (next === "" || next === current)
      return

    var entry = { id: root.moduleName }

    for (var key in root.settings) {
      if (key !== "id")
        entry[key] = root.settings[key]
    }

    entry[vertical ? "verticalFormat" : "format"] = next

    root.settings = entry

    if (root.bar &&
        root.bar.shell &&
        typeof root.bar.shell.updateEntryInline === "function") {
      root.bar.shell.updateEntryInline(root.moduleName, entry)
    }
  }

  function formatted(date) {
    return Qt.formatDateTime(
      date,
      activeFormat.replace(
        /ww/g,
        Model.isoWeekLiteral(
          date.getFullYear(),
          date.getMonth(),
          date.getDate()
        )
      )
    )
  }

  readonly property bool opened:
    panelLoader.item ? panelLoader.item.opened === true : false

  function open() {
    if (panelLoader.item)
      panelLoader.item.open()
  }

  function close() {
    if (panelLoader.item)
      panelLoader.item.close()
  }

  function togglePanel() {
    if (panelLoader.item)
      panelLoader.item.toggle()
  }

  function toggleWeekStart() {
    if (panelLoader.item)
      panelLoader.item.toggleWeekStart()
  }

  readonly property real openPanelIndicatorWidth:
    clockText.implicitWidth + 20

  readonly property real openPanelIndicatorHeight:
    Math.max(
      Style.space(10),
      Math.round(Style.bar.iconSlot * 0.55)
    )

  readonly property bool popoutSwitchClosing:
    panelLoader.item
      ? panelLoader.item.popoutSwitchClosing === true
      : false

  function closeForPopoutSwitch() {
    if (panelLoader.item)
      panelLoader.item.closeForPopoutSwitch()
  }

  function injectPanel() {
    var target = panelLoader.item

    if (!target)
      return

    if ("bar" in target)
      target.bar = root.bar

    if ("settings" in target)
      target.settings = root.settings

    if ("anchorItem" in target)
      target.anchorItem = clockArea

    if ("hostWidget" in target)
      target.hostWidget = root
  }

  /*
   * IMPORTANTE:
   * El ancho del módulo lo determina nuestro texto.
   * Así la barra reserva realmente el espacio del reloj y nunca
   * puede quedar por encima de la batería.
   */
  implicitWidth: clockArea.implicitWidth
  implicitHeight: clockArea.implicitHeight

  onBarChanged: injectPanel()
  onSettingsChanged: injectPanel()

  SystemClock {
    id: clock

    precision: SystemClock.Minutes

    onDateChanged:
      root.displayDate = date
  }

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

  IpcHandler {
    target: "caste.clock"

    function refresh(): void {
      root.broadcast("refresh")
    }

    function cycleFormat(): void {
      root.cycleFormat()
    }

    function toggleWeekStart(): void {
      root.toggleWeekStart()
    }

    function open(): void {
      root.open()
    }

    function close(): void {
      root.close()
    }

    function show(): void {
      root.open()
    }

    function hide(): void {
      root.close()
    }

    function toggle(): void {
      root.togglePanel()
    }
  }

  /*
   * Área real del módulo.
   * La pill/fondo sigue siendo responsabilidad de la barra.
   */
  Item {
    id: clockArea

    implicitWidth: clockText.implicitWidth + 20
    implicitHeight: clockText.implicitHeight + 12

    width: implicitWidth
    height: implicitHeight

    Text {
      id: clockText

      anchors.centerIn: parent

      text: root.vertical ? "" : root.displayText

      font.family: root.bar
        ? root.bar.fontFamily
        : Style.font.family

      font.pixelSize: 14
      font.weight: Font.Bold

      color: "#c0c0cc"

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

      onClicked: function(mouse) {
        if (mouse.button === Qt.RightButton) {
          root.cycleFormat()
        }
        else if (mouse.button === Qt.MiddleButton) {
          if (root.bar)
            root.bar.run("omarchy-menu-timezone")
        }
        else {
          root.togglePanel()
        }
      }
    }
  }
}
