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
                        width: parent.width - 22 - 22 - Theme.spacingM * 2 // Room for both icons + spacing
                        StyledText { text: "Menu Transparency"; font.pixelSize: Theme.fontSizeMedium; font.weight: Font.Medium; color: Theme.surfaceText }
                        StyledText { text: "Opacity of the power menu floating container."; font.pixelSize: Theme.fontSizeSmall; color: Theme.surfaceVariantText; width: parent.width; wrapMode: Text.WordWrap }
                    }
                    DankIcon {
                        name: "restart_alt"
                        size: 22
                        anchors.verticalCenter: parent.verticalCenter
                        opacity: menuOpacitySlider.value !== 20 ? 0.8 : 0.0
                        Behavior on opacity { NumberAnimation { duration: 200 } }
                        MouseArea {
                            anchors.fill: parent
                            enabled: menuOpacitySlider.value !== 20
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                menuOpacitySlider.value = menuOpacitySlider.defaultValue;
                                root.saveValue(menuOpacitySlider.settingKey, menuOpacitySlider.defaultValue);
                            }
                        }
                    }
                }
                DankSlider {
                    id: menuOpacitySlider
                    property int defaultValue: 20
                    property string settingKey: "menuOpacity"
                    width: parent.width
                    minimum: 0
                    maximum: 100
                    unit: "%"
                    function loadValue() {
                        var settings = root;
                        if (settings) {
                            value = settings.loadValue(settingKey, defaultValue);
                        }
                    }
                    Component.onCompleted: loadValue()
                    onSliderValueChanged: newValue => {
                        value = newValue;
                        root.saveValue(settingKey, newValue);
                    }
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
                        width: parent.width - 22 - 22 - Theme.spacingM * 2 // Room for both icons + spacing
                        StyledText { text: "Background Dim Intensity"; font.pixelSize: Theme.fontSizeMedium; font.weight: Font.Medium; color: Theme.surfaceText }
                        StyledText { text: "How dark the background dims when the menu is open."; font.pixelSize: Theme.fontSizeSmall; color: Theme.surfaceVariantText; width: parent.width; wrapMode: Text.WordWrap }
                    }
                    DankIcon {
                        name: "restart_alt"
                        size: 22
                        anchors.verticalCenter: parent.verticalCenter
                        opacity: dimOpacitySlider.value !== 90 ? 0.8 : 0.0
                        Behavior on opacity { NumberAnimation { duration: 200 } }
                        MouseArea {
                            anchors.fill: parent
                            enabled: dimOpacitySlider.value !== 90
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                dimOpacitySlider.value = dimOpacitySlider.defaultValue;
                                root.saveValue(dimOpacitySlider.settingKey, dimOpacitySlider.defaultValue);
                            }
                        }
                    }
                }
                DankSlider {
                    id: dimOpacitySlider
                    property int defaultValue: 90
                    property string settingKey: "dimOpacity"
                    width: parent.width
                    minimum: 0
                    maximum: 100
                    unit: "%"
                    function loadValue() {
                        var settings = root;
                        if (settings) {
                            value = settings.loadValue(settingKey, defaultValue);
                        }
                    }
                    Component.onCompleted: loadValue()
                    onSliderValueChanged: newValue => {
                        value = newValue;
                        root.saveValue(settingKey, newValue);
                    }
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
