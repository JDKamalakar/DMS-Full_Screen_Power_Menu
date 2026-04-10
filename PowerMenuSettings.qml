import QtQuick
import Quickshell

import qs.Common
import qs.Widgets
import qs.Modules.Plugins

PluginSettings {
    id: root
    pluginId: "dmsFullScreenPowerMenu"

    Rectangle {
        width: parent.width
        height: generalGroup.implicitHeight + Theme.spacingM * 2
        color: Theme.surfaceContainer
        radius: Theme.cornerRadius
        border.color: Theme.outline
        border.width: 1
        opacity: 0.8

        function loadValue() {
            for (var i = 0; i < generalGroup.children.length; i++) {
                var item = generalGroup.children[i];
                if (item.loadValue) item.loadValue();
                else if (item.children) {
                    for (var j = 0; j < item.children.length; j++) {
                        var subItem = item.children[j];
                        if (subItem.loadValue) subItem.loadValue();
                    }
                }
            }
        }

        Column {
            id: generalGroup
            anchors.fill: parent
            anchors.margins: Theme.spacingM
            spacing: Theme.spacingM

            // -----------------------------------------------------------------
            // Menu Transparency
            // -----------------------------------------------------------------
            Column {
                width: parent.width
                spacing: Theme.spacingXS
                Row {
                    width: parent.width
                    spacing: Theme.spacingM
                    DankIcon { name: "visibility"; size: 22; anchors.verticalCenter: parent.verticalCenter; opacity: 0.8 }
                    Column {
                        width: parent.width - 22 - Theme.spacingM
                        StyledText { text: "Menu Transparency"; font.pixelSize: Theme.fontSizeMedium; font.weight: Font.Medium; color: Theme.surfaceText }
                        StyledText { text: "Opacity of the power menu floating container."; font.pixelSize: Theme.fontSizeSmall; color: Theme.surfaceVariantText; width: parent.width; wrapMode: Text.WordWrap }
                    }
                }
                SliderSetting {
                    width: parent.width
                    settingKey: "menuOpacity"
                    label: ""
                    description: ""
                    defaultValue: 10
                    minimum: 0
                    maximum: 100
                    unit: "%"
                }
            }

            // -----------------------------------------------------------------
            // Dim Intensity
            // -----------------------------------------------------------------
            Column {
                width: parent.width
                spacing: Theme.spacingXS
                Row {
                    width: parent.width
                    spacing: Theme.spacingM
                    DankIcon { name: "opacity"; size: 22; anchors.verticalCenter: parent.verticalCenter; opacity: 0.8 }
                    Column {
                        width: parent.width - 22 - Theme.spacingM
                        StyledText { text: "Background Dim Intensity"; font.pixelSize: Theme.fontSizeMedium; font.weight: Font.Medium; color: Theme.surfaceText }
                        StyledText { text: "How dark the background dims when the menu is open."; font.pixelSize: Theme.fontSizeSmall; color: Theme.surfaceVariantText; width: parent.width; wrapMode: Text.WordWrap }
                    }
                }
                SliderSetting {
                    width: parent.width
                    settingKey: "dimOpacity"
                    label: ""
                    description: ""
                    defaultValue: 90
                    minimum: 0
                    maximum: 100
                    unit: "%"
                }
            }

            // -----------------------------------------------------------------
            // Shutdown Cmd
            // -----------------------------------------------------------------
            Column {
                width: parent.width
                spacing: Theme.spacingXS
                Row {
                    width: parent.width
                    spacing: Theme.spacingM
                    DankIcon { name: "power_settings_new"; size: 22; anchors.verticalCenter: parent.verticalCenter; opacity: 0.8 }
                    Column {
                        width: parent.width - 22 - Theme.spacingM
                        StyledText { text: "Shutdown Command"; font.pixelSize: Theme.fontSizeMedium; font.weight: Font.Medium; color: Theme.surfaceText }
                        StyledText { text: "Command executed to power off the machine."; font.pixelSize: Theme.fontSizeSmall; color: Theme.surfaceVariantText; width: parent.width; wrapMode: Text.WordWrap }
                    }
                }
                StringSetting {
                    width: parent.width
                    settingKey: "shutdownCommand"
                    label: ""
                    description: ""
                    defaultValue: "systemctl poweroff"
                }
            }

            // -----------------------------------------------------------------
            // Restart Cmd
            // -----------------------------------------------------------------
            Column {
                width: parent.width
                spacing: Theme.spacingXS
                Row {
                    width: parent.width
                    spacing: Theme.spacingM
                    DankIcon { name: "restart_alt"; size: 22; anchors.verticalCenter: parent.verticalCenter; opacity: 0.8 }
                    Column {
                        width: parent.width - 22 - Theme.spacingM
                        StyledText { text: "Restart Command"; font.pixelSize: Theme.fontSizeMedium; font.weight: Font.Medium; color: Theme.surfaceText }
                        StyledText { text: "Command executed to reboot the machine."; font.pixelSize: Theme.fontSizeSmall; color: Theme.surfaceVariantText; width: parent.width; wrapMode: Text.WordWrap }
                    }
                }
                StringSetting {
                    width: parent.width
                    settingKey: "rebootCommand"
                    label: ""
                    description: ""
                    defaultValue: "systemctl reboot"
                }
            }

            // -----------------------------------------------------------------
            // Suspend Cmd
            // -----------------------------------------------------------------
            Column {
                width: parent.width
                spacing: Theme.spacingXS
                Row {
                    width: parent.width
                    spacing: Theme.spacingM
                    DankIcon { name: "bedtime"; size: 22; anchors.verticalCenter: parent.verticalCenter; opacity: 0.8 }
                    Column {
                        width: parent.width - 22 - Theme.spacingM
                        StyledText { text: "Suspend Command"; font.pixelSize: Theme.fontSizeMedium; font.weight: Font.Medium; color: Theme.surfaceText }
                        StyledText { text: "Command executed to sleep/suspend the machine."; font.pixelSize: Theme.fontSizeSmall; color: Theme.surfaceVariantText; width: parent.width; wrapMode: Text.WordWrap }
                    }
                }
                StringSetting {
                    width: parent.width
                    settingKey: "suspendCommand"
                    label: ""
                    description: ""
                    defaultValue: "systemctl suspend"
                }
            }

            // -----------------------------------------------------------------
            // Logout Cmd
            // -----------------------------------------------------------------
            Column {
                width: parent.width
                spacing: Theme.spacingXS
                Row {
                    width: parent.width
                    spacing: Theme.spacingM
                    DankIcon { name: "logout"; size: 22; anchors.verticalCenter: parent.verticalCenter; opacity: 0.8 }
                    Column {
                        width: parent.width - 22 - Theme.spacingM
                        StyledText { text: "Log Out Command"; font.pixelSize: Theme.fontSizeMedium; font.weight: Font.Medium; color: Theme.surfaceText }
                        StyledText { text: "Command to log out of the session."; font.pixelSize: Theme.fontSizeSmall; color: Theme.surfaceVariantText; width: parent.width; wrapMode: Text.WordWrap }
                    }
                }
                StringSetting {
                    width: parent.width
                    settingKey: "logoutCommand"
                    label: ""
                    description: ""
                    defaultValue: "loginctl terminate-session"
                }
            }

            // -----------------------------------------------------------------
            // Lock Screen Cmd
            // -----------------------------------------------------------------
            Column {
                width: parent.width
                spacing: Theme.spacingXS
                Row {
                    width: parent.width
                    spacing: Theme.spacingM
                    DankIcon { name: "lock"; size: 22; anchors.verticalCenter: parent.verticalCenter; opacity: 0.8 }
                    Column {
                        width: parent.width - 22 - Theme.spacingM
                        StyledText { text: "Lock Screen Command"; font.pixelSize: Theme.fontSizeMedium; font.weight: Font.Medium; color: Theme.surfaceText }
                        StyledText { text: "Command to lock the screen."; font.pixelSize: Theme.fontSizeSmall; color: Theme.surfaceVariantText; width: parent.width; wrapMode: Text.WordWrap }
                    }
                }
                StringSetting {
                    width: parent.width
                    settingKey: "lockCommand"
                    label: ""
                    description: ""
                    defaultValue: "loginctl lock-session"
                }
            }

            // -----------------------------------------------------------------
            // DMS Restart Cmd
            // -----------------------------------------------------------------
            Column {
                width: parent.width
                spacing: Theme.spacingXS
                Row {
                    width: parent.width
                    spacing: Theme.spacingM
                    DankIcon { name: "terminal"; size: 22; anchors.verticalCenter: parent.verticalCenter; opacity: 0.8 }
                    Column {
                        width: parent.width - 22 - Theme.spacingM
                        StyledText { text: "Restart DMS Command"; font.pixelSize: Theme.fontSizeMedium; font.weight: Font.Medium; color: Theme.surfaceText }
                        StyledText { text: "Command to restart the shell."; font.pixelSize: Theme.fontSizeSmall; color: Theme.surfaceVariantText; width: parent.width; wrapMode: Text.WordWrap }
                    }
                }
                StringSetting {
                    width: parent.width
                    settingKey: "dmsRestartCommand"
                    label: ""
                    description: ""
                    defaultValue: "dms restart"
                }
            }
        }
    }
}
