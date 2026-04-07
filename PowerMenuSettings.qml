import QtQuick
import qs.Modules.Plugins

PluginSettings {
	pluginId: "dmsPowerMenu"

	StringSetting {
		name: "logoutCommand"
		description: "Command to log out of the session"
		defaultValue: "loginctl terminate-session"
	}

	StringSetting {
		name: "lockCommand"
		description: "Command to lock the screen"
		defaultValue: "loginctl lock-session"
	}

	SliderSetting {
		name: "blurAmount"
		description: "Background dim intensity (0.0 – 1.0)"
		defaultValue: 0.75
		minimumValue: 0.0
		maximumValue: 1.0
	}
}
