import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets
import qs.Common
import qs.Modules.Plugins

PluginComponent {
	id: root

	// -------------------------------------------------------------------------
	// IPC — trigger via: dms ipc dmsFullScreenPowerMenu toggle
	// -------------------------------------------------------------------------

	IpcHandler {
		target: "dmsFullScreenPowerMenu"

		function toggle(): string {
			root.toggle();
			return overlay.visible ? "opened" : "closed";
		}

		function open(): string {
			if (!overlay.visible) root.open();
			return "opened";
		}

		function close(): string {
			if (overlay.visible) root.close();
			return "closed";
		}
	}

	function open() {
		overlay.visible = true;
	}

	function close() {
		overlay.visible = false;
	}

	function toggle() {
		if (overlay.visible) root.close();
		else root.open();
	}

	// -------------------------------------------------------------------------
	// FULLSCREEN OVERLAY WINDOW
	// -------------------------------------------------------------------------

	PanelWindow {
		id: overlay
		visible: false
		color: "transparent"

		WlrLayershell.namespace: "dms:plugins:dmsFullScreenPowerMenu"
		WlrLayershell.layer: WlrLayershell.Overlay
		WlrLayershell.exclusiveZone: -1
		WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

		anchors {
			top: true
			left: true
			right: true
			bottom: true
		}

		// Background dim
		Rectangle {
			anchors.fill: parent
			color: "#000000"
			opacity: overlay.visible ? (pluginData && pluginData.dimOpacity != null ? pluginData.dimOpacity / 100 : 0.40) : 0
			Behavior on opacity { NumberAnimation { duration: 400; easing.type: Easing.OutCubic } }

			MouseArea {
				anchors.fill: parent
				onClicked: root.close()
			}
		}

		// Power Menu Card
		Rectangle {
			id: menuCard
			anchors.centerIn: parent
			width: mainRow.implicitWidth + 48
			height: mainRow.implicitHeight + 48
			radius: 32
			color: Qt.rgba(1, 1, 1, 0.08) // bg-white/10
			border.color: Qt.rgba(1, 1, 1, 0.20) // border-white/20
			border.width: 1

			scale: overlay.visible ? 1.0 : 0.9
			opacity: overlay.visible ? 1.0 : 0.0
			Behavior on scale   { NumberAnimation { duration: 600; easing.type: Easing.OutElastic; easing.overshoot: 1.2 } }
			Behavior on opacity { NumberAnimation { duration: 300 } }

			// Escape key to close
			Keys.onEscapePressed: root.close()

			RowLayout {
				id: mainRow
				anchors.centerIn: parent
				spacing: 12

				PowerButton {
					buttonId: "lock"
					label: "Lock"
					iconCode: "lock"
					isFirst: true
					accentColor: "#93C5FD"
					bgColor: Qt.rgba(0.23, 0.51, 0.96, 0.2)
					onActivated: {
						root.close();
						lockProc.command = (pluginData && pluginData.lockCommand ? pluginData.lockCommand : "loginctl lock-session").split(" ");
						lockProc.running = true;
					}
				}

				PowerButton {
					buttonId: "sleep"
					label: "Sleep"
					iconCode: "bedtime"
					accentColor: "#A5B4FC"
					bgColor: Qt.rgba(0.39, 0.38, 0.96, 0.2)
					onActivated: {
						root.close();
						suspendProc.running = true;
					}
				}

				PowerButton {
					buttonId: "restart"
					label: "Restart"
					iconCode: "restart_alt"
					accentColor: "#86EFAC"
					bgColor: Qt.rgba(0.13, 0.77, 0.36, 0.2)
					onActivated: {
						root.close();
						rebootProc.running = true;
					}
				}

				PowerButton {
					buttonId: "logout"
					label: "Log Out"
					iconCode: "logout"
					accentColor: "#FDBA74"
					bgColor: Qt.rgba(0.97, 0.58, 0.11, 0.2)
					onActivated: {
						root.close();
						logoutProc.command = (pluginData && pluginData.logoutCommand ? pluginData.logoutCommand : "loginctl terminate-session $XDG_SESSION_ID").split(" ");
						logoutProc.running = true;
					}
				}

				PowerButton {
					buttonId: "power"
					label: "Power Off"
					iconCode: "power_settings_new"
					isLast: true
					accentColor: "#FCA5A5"
					bgColor: Qt.rgba(0.94, 0.26, 0.26, 0.2)
					isPrimary: true
					onActivated: {
						root.close();
						shutdownProc.running = true;
					}
				}
			}
		}

		// Keyboard handler on overlay background
		Item {
			anchors.fill: parent
			focus: overlay.visible
			Keys.onEscapePressed: root.close()
		}
	}

	// -------------------------------------------------------------------------
	// PROCESSES
	// -------------------------------------------------------------------------

	Process { id: shutdownProc; command: ["systemctl", "poweroff"] }
	Process { id: rebootProc;   command: ["systemctl", "reboot"]   }
	Process { id: suspendProc;  command: ["systemctl", "suspend"]  }
	Process { id: logoutProc   }
	Process { id: lockProc     }

	// -------------------------------------------------------------------------
	// POWER BUTTON COMPONENT
	// -------------------------------------------------------------------------

	component PowerButton: Item {
		property string buttonId: ""
		property string label: ""
		property string iconCode: ""
		property color accentColor: "#D0BCFF"
		property color bgColor: Qt.rgba(1, 1, 1, 0.1)
		property bool isPrimary: false
		property bool isFirst: false
		property bool isLast: false

		signal activated()

		implicitWidth: 120
		implicitHeight: 120

		// Top level transforms for hover shift and click scale
		transform: [
			Translate {
				id: hoverTranslate
				y: ma.containsMouse ? -12 : 0
				Behavior on y { NumberAnimation { duration: 400; easing.type: Easing.OutBack; easing.overshoot: 1.5 } }
			},
			Scale {
				id: clickScale
				origin.x: width / 2
				origin.y: height / 2
				xScale: ma.pressed ? 0.92 : 1.0
				yScale: xScale
				Behavior on xScale { NumberAnimation { duration: 250; easing.type: Easing.OutBack } }
			}
		]

		Canvas {
			id: btnBg
			anchors.fill: parent

			property real defaultRadius: isPrimary ? 24 : 16
			property real hoverRadius: 28

			property real tlr: ma.containsMouse ? hoverRadius : (isFirst ? 28 : defaultRadius)
			property real tlrAnim: tlr
			Behavior on tlrAnim { NumberAnimation { duration: 400; easing.type: Easing.OutBack } }

			property real trr: ma.containsMouse ? hoverRadius : (isLast ? 28 : defaultRadius)
			property real trrAnim: trr
			Behavior on trrAnim { NumberAnimation { duration: 400; easing.type: Easing.OutBack } }

			property real brr: ma.containsMouse ? hoverRadius : (isLast ? 28 : defaultRadius)
			property real brrAnim: brr
			Behavior on brrAnim { NumberAnimation { duration: 400; easing.type: Easing.OutBack } }

			property real blr: ma.containsMouse ? hoverRadius : (isFirst ? 28 : defaultRadius)
			property real blrAnim: blr
			Behavior on blrAnim { NumberAnimation { duration: 400; easing.type: Easing.OutBack } }

			property color paintColor: isPrimary 
				? (ma.containsMouse ? Qt.rgba(bgColor.r, bgColor.g, bgColor.b, bgColor.a + 0.2) : bgColor)
				: (ma.containsMouse ? bgColor : Qt.rgba(1, 1, 1, 0.05))

			property color paintBorder: isPrimary 
				? Qt.rgba(0.94, 0.26, 0.26, 0.3) 
				: (ma.containsMouse ? Qt.rgba(accentColor.r, accentColor.g, accentColor.b, 0.3) : Qt.rgba(1, 1, 1, 0.1))

			Behavior on paintColor  { ColorAnimation { duration: 300 } }
			Behavior on paintBorder { ColorAnimation { duration: 300 } }

			onTlrAnimChanged: btnBg.requestPaint()
			onTrrAnimChanged: btnBg.requestPaint()
			onBrrAnimChanged: btnBg.requestPaint()
			onBlrAnimChanged: btnBg.requestPaint()
			onPaintColorChanged: btnBg.requestPaint()
			onPaintBorderChanged: btnBg.requestPaint()

			onPaint: {
				var ctx = getContext("2d");
				ctx.clearRect(0, 0, width, height);
				ctx.fillStyle = paintColor;
				ctx.strokeStyle = paintBorder;
				ctx.lineWidth = 1;
				
				ctx.beginPath();
				ctx.moveTo(tlrAnim, 0);
				ctx.lineTo(width - trrAnim, 0);
				ctx.arcTo(width, 0, width, trrAnim, trrAnim);
				ctx.lineTo(width, height - brrAnim);
				ctx.arcTo(width, height, width - brrAnim, height, brrAnim);
				ctx.lineTo(blrAnim, height);
				ctx.arcTo(0, height, 0, height - blrAnim, blrAnim);
				ctx.lineTo(0, tlrAnim);
				ctx.arcTo(0, 0, tlrAnim, 0, tlrAnim);
				ctx.closePath();
				ctx.fill();
				ctx.stroke();
			}

			ColumnLayout {
				anchors.centerIn: parent
				spacing: 8

				Item {
					width: 56
					height: 56
					Layout.alignment: Qt.AlignHCenter

					// Inner Morphing Pill
					Rectangle {
						id: morphPill
						anchors.centerIn: parent
						width: 48
						height: 48
						
						radius: ma.containsMouse ? width * 0.35 : width * 0.5
						color: isPrimary ? Qt.rgba(0.94, 0.26, 0.26, 0.3) : Qt.rgba(1, 1, 1, 0.1)
						
						// Continuous rotation while hovered
						RotationAnimation on rotation {
							loops: Animation.Infinite
							from: 0; to: 360
							duration: 2000
							running: ma.containsMouse
						}

						// Animate baseline radius for morphing effect
						Behavior on radius { NumberAnimation { duration: 400; easing.type: Easing.OutBack } }
					}

					// Dynamic Icon wrapper based on buttonId
					Item {
						anchors.centerIn: parent
						width: 32
						height: 32

						Text {
							id: btnIcon
							anchors.centerIn: parent
							text: iconCode
							font.family: "Material Symbols Rounded"
							font.pixelSize: 32
							color: ma.containsMouse ? accentColor : (isPrimary ? Qt.rgba(1, 0.7, 0.7, 1) : Qt.rgba(1, 1, 1, 0.9))
							Behavior on color { ColorAnimation { duration: 300 } }

							// Custom Animations based on buttonId
							transform: [
								Rotation {
									id: iconRotation
									origin.x: 16; origin.y: 16
									angle: ma.containsMouse ? (buttonId === "sleep" ? -20 : (buttonId === "restart" ? 180 : (buttonId === "power" ? 90 : 0))) : 0
									Behavior on angle {
										enabled: buttonId !== "lock"
										NumberAnimation { duration: ma.containsMouse ? 500 : 300; easing.type: Easing.OutBack }
									}
								},
								Scale {
									id: iconScale
									origin.x: 16; origin.y: 16
									xScale: ma.containsMouse && buttonId !== "lock" ? (buttonId === "power" ? 1.2 : 1.1) : 1.0
									yScale: xScale
									Behavior on xScale { NumberAnimation { duration: 300; easing.type: Easing.OutBack } }
								},
								Translate {
									id: iconTranslate
									x: ma.containsMouse && buttonId === "logout" ? 6 : 0
									Behavior on x { NumberAnimation { duration: 300; easing.type: Easing.OutBack } }
								}
							]
						}

						SequentialAnimation {
							id: lockShakeAnim
							running: ma.containsMouse && buttonId === "lock"
							loops: Animation.Infinite
							NumberAnimation { target: iconRotation; property: "angle"; to: -15; duration: 80; easing.type: Easing.InOutQuad }
							NumberAnimation { target: iconRotation; property: "angle"; to: 15; duration: 80; easing.type: Easing.InOutQuad }
							NumberAnimation { target: iconRotation; property: "angle"; to: -10; duration: 80; easing.type: Easing.InOutQuad }
							NumberAnimation { target: iconRotation; property: "angle"; to: 10; duration: 80; easing.type: Easing.InOutQuad }
							NumberAnimation { target: iconRotation; property: "angle"; to: 0; duration: 80; easing.type: Easing.InOutQuad }
							PauseAnimation { duration: 1500 }
							onRunningChanged: {
								if (!running) iconRotation.angle = 0;
							}
						}
					}
				}

				Text {
					text: label
					color: ma.containsMouse ? "white" : (isPrimary ? Qt.rgba(1, 0.8, 0.8, 1) : Qt.rgba(1, 1, 1, 0.7))
					font.pixelSize: 13
					font.weight: Font.Medium
					Layout.alignment: Qt.AlignHCenter
					Behavior on color { ColorAnimation { duration: 300 } }
				}
			}

			MouseArea {
				id: ma
				anchors.fill: parent
				hoverEnabled: true
				cursorShape: Qt.PointingHandCursor
				onClicked: parent.parent.activated()
			}
		}
	}

	Component.onCompleted: {
		console.info("dmsFullScreenPowerMenu: daemon loaded — use 'dms ipc dmsFullScreenPowerMenu toggle' to open");
	}
}

