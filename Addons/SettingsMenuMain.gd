extends Control

# Signals for when settings are applied
signal settings_applied()
signal settings_closed()

# References to UI elements
@onready var main_panel = $MainPanel
@onready var tab_container = $MainPanel/VBoxContainer/TabContainer

# Graphics Tab References
@onready var resolution_option = $MainPanel/VBoxContainer/TabContainer/Graphics/GraphicsContainer/DisplaySection/ResolutionContainer/ResolutionOption
@onready var window_mode_option = $MainPanel/VBoxContainer/TabContainer/Graphics/GraphicsContainer/DisplaySection/WindowModeContainer/WindowModeOption
@onready var refresh_rate_option = $MainPanel/VBoxContainer/TabContainer/Graphics/GraphicsContainer/DisplaySection/RefreshRateContainer/RefreshRateOption
@onready var graphics_preset_option = $MainPanel/VBoxContainer/TabContainer/Graphics/GraphicsContainer/QualitySection/GraphicsPresetContainer/GraphicsPresetOption
@onready var texture_quality_slider = $MainPanel/VBoxContainer/TabContainer/Graphics/GraphicsContainer/QualitySection/TextureQualityContainer/TextureQualitySlider
@onready var texture_quality_value = $MainPanel/VBoxContainer/TabContainer/Graphics/GraphicsContainer/QualitySection/TextureQualityContainer/TextureQualityValue
@onready var shadow_quality_slider = $MainPanel/VBoxContainer/TabContainer/Graphics/GraphicsContainer/QualitySection/ShadowQualityContainer/ShadowQualitySlider
@onready var shadow_quality_value = $MainPanel/VBoxContainer/TabContainer/Graphics/GraphicsContainer/QualitySection/ShadowQualityContainer/ShadowQualityValue
@onready var anti_aliasing_option = $MainPanel/VBoxContainer/TabContainer/Graphics/GraphicsContainer/QualitySection/AntiAliasingContainer/AntiAliasingOption
@onready var vsync_checkbox = $MainPanel/VBoxContainer/TabContainer/Graphics/GraphicsContainer/QualitySection/VSyncContainer/VSyncCheckBox

# Audio Tab References
@onready var master_volume_slider = $MainPanel/VBoxContainer/TabContainer/Audio/AudioContainer/AudioSection/MasterVolumeContainer/MasterVolumeSlider
@onready var master_volume_value = $MainPanel/VBoxContainer/TabContainer/Audio/AudioContainer/AudioSection/MasterVolumeContainer/MasterVolumeValue
@onready var game_volume_slider = $MainPanel/VBoxContainer/TabContainer/Audio/AudioContainer/AudioSection/GameVolumeContainer/GameVolumeSlider
@onready var game_volume_value = $MainPanel/VBoxContainer/TabContainer/Audio/AudioContainer/AudioSection/GameVolumeContainer/GameVolumeValue
@onready var voice_chat_volume_slider = $MainPanel/VBoxContainer/TabContainer/Audio/AudioContainer/AudioSection/VoiceChatVolumeContainer/VoiceChatVolumeSlider
@onready var voice_chat_volume_value = $MainPanel/VBoxContainer/TabContainer/Audio/AudioContainer/AudioSection/VoiceChatVolumeContainer/VoiceChatVolumeValue
@onready var voice_chat_enabled_checkbox = $MainPanel/VBoxContainer/TabContainer/Audio/AudioContainer/VoiceChatSection/VoiceChatEnabledContainer/VoiceChatEnabledCheckBox
@onready var push_to_talk_checkbox = $MainPanel/VBoxContainer/TabContainer/Audio/AudioContainer/VoiceChatSection/PushToTalkContainer/PushToTalkCheckBox

# Input Tab References
@onready var mouse_sensitivity_slider = $MainPanel/VBoxContainer/TabContainer/InputDevice/InputContainer/MouseSection/MouseSensitivityContainer/MouseSensitivitySlider
@onready var mouse_sensitivity_value = $MainPanel/VBoxContainer/TabContainer/InputDevice/InputContainer/MouseSection/MouseSensitivityContainer/MouseSensitivityValue
@onready var mouse_invert_y_checkbox = $MainPanel/VBoxContainer/TabContainer/InputDevice/InputContainer/MouseSection/MouseInvertYContainer/MouseInvertYCheckBox
@onready var mouse_acceleration_checkbox = $MainPanel/VBoxContainer/TabContainer/InputDevice/InputContainer/MouseSection/MouseAccelerationContainer/MouseAccelerationCheckBox
@onready var gamepad_enabled_checkbox = $MainPanel/VBoxContainer/TabContainer/InputDevice/InputContainer/GamepadSection/GamepadEnabledContainer/GamepadEnabledCheckBox
@onready var gamepad_sensitivity_slider = $MainPanel/VBoxContainer/TabContainer/InputDevice/InputContainer/GamepadSection/GamepadSensitivityContainer/GamepadSensitivitySlider
@onready var gamepad_sensitivity_value = $MainPanel/VBoxContainer/TabContainer/InputDevice/InputContainer/GamepadSection/GamepadSensitivityContainer/GamepadSensitivityValue
@onready var gamepad_vibration_checkbox = $MainPanel/VBoxContainer/TabContainer/InputDevice/InputContainer/GamepadSection/GamepadVibrationContainer/GamepadVibrationCheckBox

# Network Tab References
@onready var player_name_line_edit = $MainPanel/VBoxContainer/TabContainer/Network/NetworkContainer/ConnectionSection/PlayerNameContainer/PlayerNameLineEdit
@onready var region_option = $MainPanel/VBoxContainer/TabContainer/Network/NetworkContainer/ConnectionSection/RegionContainer/RegionOption
@onready var max_ping_slider = $MainPanel/VBoxContainer/TabContainer/Network/NetworkContainer/ConnectionSection/MaxPingContainer/MaxPingSlider
@onready var max_ping_value = $MainPanel/VBoxContainer/TabContainer/Network/NetworkContainer/ConnectionSection/MaxPingContainer/MaxPingValue
@onready var show_ping_checkbox = $MainPanel/VBoxContainer/TabContainer/Network/NetworkContainer/GameplayNetworkSection/ShowPingContainer/ShowPingCheckBox
@onready var show_player_names_checkbox = $MainPanel/VBoxContainer/TabContainer/Network/NetworkContainer/GameplayNetworkSection/ShowPlayerNamesContainer/ShowPlayerNamesCheckBox

# Settings data
var settings_data = {
	# Graphics
	"resolution": 1,
	"window_mode": 0,
	"refresh_rate": 1,
	"graphics_preset": 1,
	"texture_quality": 2,
	"shadow_quality": 2,
	"anti_aliasing": 1,
	"vsync": true,
	
	# Audio
	"master_volume": 75,
	"game_volume": 80,
	"voice_chat_volume": 70,
	"voice_chat_enabled": true,
	"push_to_talk": false,
	
	# Input
	"mouse_sensitivity": 1.0,
	"mouse_invert_y": false,
	"mouse_acceleration": false,
	"gamepad_enabled": true,
	"gamepad_sensitivity": 1.0,
	"gamepad_vibration": true,
	
	# Network
	"player_name": "Player",
	"region": 1,
	"max_ping": 100,
	"show_ping": true,
	"show_player_names": true
}

# Default settings backup
var default_settings = {}

# Keybinding data
var keybinds = {
	"move_forward": KEY_W,
	"move_backward": KEY_S,
	"move_left": KEY_A,
	"move_right": KEY_D,
	"jump": KEY_SPACE,
	"primary_attack": MOUSE_BUTTON_LEFT,
	"secondary_attack": MOUSE_BUTTON_RIGHT,
	"reload": KEY_R,
	"voice_chat": KEY_V,
	"chat": KEY_T
}

var default_keybinds = {}
var currently_remapping = ""
var awaiting_input = false

# Animation tweens
var fade_tween: Tween
var scale_tween: Tween

# Quality level names
var quality_names = ["Low", "Medium", "High", "Ultra"]

func _ready():
	# Set up initial state
	modulate.a = 0.0
	main_panel.scale = Vector2(0.8, 0.8)
	
	# Store defaults
	default_settings = settings_data.duplicate(true)
	default_keybinds = keybinds.duplicate()
	
	# Load settings
	load_settings()
	load_keybinds()
	update_ui_from_settings()
	
	# Animate entrance
	show_settings_menu()

func show_settings_menu():
	show()
	
	# Fade in background
	fade_tween = create_tween()
	fade_tween.tween_property(self, "modulate:a", 1.0, 0.3)
	
	# Scale in panel with bounce effect
	scale_tween = create_tween()
	scale_tween.set_ease(Tween.EASE_OUT)
	scale_tween.set_trans(Tween.TRANS_BACK)
	scale_tween.tween_property(main_panel, "scale", Vector2(1.0, 1.0), 0.4)

func hide_settings_menu():
	# Fade out and scale down
	fade_tween = create_tween()
	fade_tween.tween_property(self, "modulate:a", 0.0, 0.2)
	
	scale_tween = create_tween()
	scale_tween.set_ease(Tween.EASE_IN)
	scale_tween.set_trans(Tween.TRANS_BACK)
	scale_tween.tween_property(main_panel, "scale", Vector2(0.8, 0.8), 0.2)
	
	# Hide after animation
	await scale_tween.finished
	hide()

func load_settings():
	var config = ConfigFile.new()
	var err = config.load("user://multiplayer_settings.cfg")
	
	if err == OK:
		# Graphics
		settings_data["resolution"] = config.get_value("graphics", "resolution", default_settings["resolution"])
		settings_data["window_mode"] = config.get_value("graphics", "window_mode", default_settings["window_mode"])
		settings_data["refresh_rate"] = config.get_value("graphics", "refresh_rate", default_settings["refresh_rate"])
		settings_data["graphics_preset"] = config.get_value("graphics", "graphics_preset", default_settings["graphics_preset"])
		settings_data["texture_quality"] = config.get_value("graphics", "texture_quality", default_settings["texture_quality"])
		settings_data["shadow_quality"] = config.get_value("graphics", "shadow_quality", default_settings["shadow_quality"])
		settings_data["anti_aliasing"] = config.get_value("graphics", "anti_aliasing", default_settings["anti_aliasing"])
		settings_data["vsync"] = config.get_value("graphics", "vsync", default_settings["vsync"])
		
		# Audio
		settings_data["master_volume"] = config.get_value("audio", "master_volume", default_settings["master_volume"])
		settings_data["game_volume"] = config.get_value("audio", "game_volume", default_settings["game_volume"])
		settings_data["voice_chat_volume"] = config.get_value("audio", "voice_chat_volume", default_settings["voice_chat_volume"])
		settings_data["voice_chat_enabled"] = config.get_value("audio", "voice_chat_enabled", default_settings["voice_chat_enabled"])
		settings_data["push_to_talk"] = config.get_value("audio", "push_to_talk", default_settings["push_to_talk"])
		
		# Input
		settings_data["mouse_sensitivity"] = config.get_value("input", "mouse_sensitivity", default_settings["mouse_sensitivity"])
		settings_data["mouse_invert_y"] = config.get_value("input", "mouse_invert_y", default_settings["mouse_invert_y"])
		settings_data["mouse_acceleration"] = config.get_value("input", "mouse_acceleration", default_settings["mouse_acceleration"])
		settings_data["gamepad_enabled"] = config.get_value("input", "gamepad_enabled", default_settings["gamepad_enabled"])
		settings_data["gamepad_sensitivity"] = config.get_value("input", "gamepad_sensitivity", default_settings["gamepad_sensitivity"])
		settings_data["gamepad_vibration"] = config.get_value("input", "gamepad_vibration", default_settings["gamepad_vibration"])
		
		# Network
		settings_data["player_name"] = config.get_value("network", "player_name", default_settings["player_name"])
		settings_data["region"] = config.get_value("network", "region", default_settings["region"])
		settings_data["max_ping"] = config.get_value("network", "max_ping", default_settings["max_ping"])
		settings_data["show_ping"] = config.get_value("network", "show_ping", default_settings["show_ping"])
		settings_data["show_player_names"] = config.get_value("network", "show_player_names", default_settings["show_player_names"])
	else:
		print("Failed to load settings, using defaults")

func save_settings():
	var config = ConfigFile.new()
	
	# Graphics
	config.set_value("graphics", "resolution", settings_data["resolution"])
	config.set_value("graphics", "window_mode", settings_data["window_mode"])
	config.set_value("graphics", "refresh_rate", settings_data["refresh_rate"])
	config.set_value("graphics", "graphics_preset", settings_data["graphics_preset"])
	config.set_value("graphics", "texture_quality", settings_data["texture_quality"])
	config.set_value("graphics", "shadow_quality", settings_data["shadow_quality"])
	config.set_value("graphics", "anti_aliasing", settings_data["anti_aliasing"])
	config.set_value("graphics", "vsync", settings_data["vsync"])
	
	# Audio
	config.set_value("audio", "master_volume", settings_data["master_volume"])
	config.set_value("audio", "game_volume", settings_data["game_volume"])
	config.set_value("audio", "voice_chat_volume", settings_data["voice_chat_volume"])
	config.set_value("audio", "voice_chat_enabled", settings_data["voice_chat_enabled"])
	config.set_value("audio", "push_to_talk", settings_data["push_to_talk"])
	
	# Input
	config.set_value("input", "mouse_sensitivity", settings_data["mouse_sensitivity"])
	config.set_value("input", "mouse_invert_y", settings_data["mouse_invert_y"])
	config.set_value("input", "mouse_acceleration", settings_data["mouse_acceleration"])
	config.set_value("input", "gamepad_enabled", settings_data["gamepad_enabled"])
	config.set_value("input", "gamepad_sensitivity", settings_data["gamepad_sensitivity"])
	config.set_value("input", "gamepad_vibration", settings_data["gamepad_vibration"])
	
	# Network
	config.set_value("network", "player_name", settings_data["player_name"])
	config.set_value("network", "region", settings_data["region"])
	config.set_value("network", "max_ping", settings_data["max_ping"])
	config.set_value("network", "show_ping", settings_data["show_ping"])
	config.set_value("network", "show_player_names", settings_data["show_player_names"])
	
	var err = config.save("user://multiplayer_settings.cfg")
	if err != OK:
		print("Failed to save settings")

func load_keybinds():
	var config = ConfigFile.new()
	var err = config.load("user://keybinds.cfg")
	
	if err == OK:
		for action in keybinds.keys():
			keybinds[action] = config.get_value("keybinds", action, default_keybinds[action])
	else:
		print("Failed to load keybinds, using defaults")

func save_keybinds():
	var config = ConfigFile.new()
	
	for action in keybinds.keys():
		config.set_value("keybinds", action, keybinds[action])
	
	var err = config.save("user://keybinds.cfg")
	if err != OK:
		print("Failed to save keybinds")

func update_ui_from_settings():
	# Graphics
	resolution_option.selected = settings_data["resolution"]
	window_mode_option.selected = settings_data["window_mode"]
	refresh_rate_option.selected = settings_data["refresh_rate"]
	graphics_preset_option.selected = settings_data["graphics_preset"]
	texture_quality_slider.value = settings_data["texture_quality"]
	texture_quality_value.text = quality_names[settings_data["texture_quality"]]
	shadow_quality_slider.value = settings_data["shadow_quality"]
	shadow_quality_value.text = quality_names[settings_data["shadow_quality"]]
	anti_aliasing_option.selected = settings_data["anti_aliasing"]
	vsync_checkbox.button_pressed = settings_data["vsync"]
	
	# Audio
	master_volume_slider.value = settings_data["master_volume"]
	master_volume_value.text = str(settings_data["master_volume"]) + "%"
	game_volume_slider.value = settings_data["game_volume"]
	game_volume_value.text = str(settings_data["game_volume"]) + "%"
	voice_chat_volume_slider.value = settings_data["voice_chat_volume"]
	voice_chat_volume_value.text = str(settings_data["voice_chat_volume"]) + "%"
	voice_chat_enabled_checkbox.button_pressed = settings_data["voice_chat_enabled"]
	push_to_talk_checkbox.button_pressed = settings_data["push_to_talk"]
	
	# Input
	mouse_sensitivity_slider.value = settings_data["mouse_sensitivity"]
	mouse_sensitivity_value.text = str(settings_data["mouse_sensitivity"])
	mouse_invert_y_checkbox.button_pressed = settings_data["mouse_invert_y"]
	mouse_acceleration_checkbox.button_pressed = settings_data["mouse_acceleration"]
	gamepad_enabled_checkbox.button_pressed = settings_data["gamepad_enabled"]
	gamepad_sensitivity_slider.value = settings_data["gamepad_sensitivity"]
	gamepad_sensitivity_value.text = str(settings_data["gamepad_sensitivity"])
	gamepad_vibration_checkbox.button_pressed = settings_data["gamepad_vibration"]
	
	# Network
	player_name_line_edit.text = settings_data["player_name"]
	region_option.selected = settings_data["region"]
	max_ping_slider.value = settings_data["max_ping"]
	max_ping_value.text = str(settings_data["max_ping"]) + "ms"
	show_ping_checkbox.button_pressed = settings_data["show_ping"]
	show_player_names_checkbox.button_pressed = settings_data["show_player_names"]
	
	# Update keybind buttons
	update_keybind_buttons()

func update_keybind_buttons():
	var keybind_buttons = {
		"move_forward": $MainPanel/VBoxContainer/TabContainer/Keybinds/KeybindsContainer/MovementSection/MoveForwardContainer/MoveForwardButton,
		"move_backward": $MainPanel/VBoxContainer/TabContainer/Keybinds/KeybindsContainer/MovementSection/MoveBackwardContainer/MoveBackwardButton,
		"move_left": $MainPanel/VBoxContainer/TabContainer/Keybinds/KeybindsContainer/MovementSection/MoveLeftContainer/MoveLeftButton,
		"move_right": $MainPanel/VBoxContainer/TabContainer/Keybinds/KeybindsContainer/MovementSection/MoveRightContainer/MoveRightButton,
		"jump": $MainPanel/VBoxContainer/TabContainer/Keybinds/KeybindsContainer/MovementSection/JumpContainer/JumpButton,
		"primary_attack": $MainPanel/VBoxContainer/TabContainer/Keybinds/KeybindsContainer/CombatSection/PrimaryAttackContainer/PrimaryAttackButton,
		"secondary_attack": $MainPanel/VBoxContainer/TabContainer/Keybinds/KeybindsContainer/CombatSection/SecondaryAttackContainer/SecondaryAttackButton,
		"reload": $MainPanel/VBoxContainer/TabContainer/Keybinds/KeybindsContainer/CombatSection/ReloadContainer/ReloadButton,
		"voice_chat": $MainPanel/VBoxContainer/TabContainer/Keybinds/KeybindsContainer/CommunicationSection/VoiceChatContainer/VoiceChatButton,
		"chat": $MainPanel/VBoxContainer/TabContainer/Keybinds/KeybindsContainer/CommunicationSection/ChatContainer/ChatButton
	}
	
	for action in keybind_buttons.keys():
		keybind_buttons[action].text = get_key_name(keybinds[action])

func get_key_name(key_code: int) -> String:
	if key_code == MOUSE_BUTTON_LEFT:
		return "Left Mouse"
	elif key_code == MOUSE_BUTTON_RIGHT:
		return "Right Mouse"
	elif key_code == MOUSE_BUTTON_MIDDLE:
		return "Middle Mouse"
	else:
		return OS.get_keycode_string(key_code)

func apply_settings():
	# Apply graphics settings
	match settings_data["resolution"]:
		0: get_window().size = Vector2i(1280, 720)    # 720p (HD)
		1: get_window().size = Vector2i(1600, 900)    # 900p
		2: get_window().size = Vector2i(1920, 1080)   # 1080p (Full HD)
		3: get_window().size = Vector2i(2560, 1440)   # 1440p (2K)
		4: get_window().size = Vector2i(3440, 1440)   # UltraWide 1440p
		5: get_window().size = Vector2i(3840, 2160)   # 4K (UHD)
		6: get_window().size = Vector2i(5120, 2880)   # 5K
		7: get_window().size = Vector2i(7680, 4320)   # 8K

	
	match settings_data["window_mode"]:
		0: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		1: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		2: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	
	# Apply V-Sync
	if settings_data["vsync"]:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	
	# Apply audio settings
	AudioServer.set_bus_volume_db(0, linear_to_db(settings_data["master_volume"] / 100.0))
	
	# Save all settings
	save_settings()
	save_keybinds()
	
	# Emit signal
	settings_applied.emit()
	
	# Show confirmation
	show_confirmation("Settings Applied!")

func reset_to_defaults():
	settings_data = default_settings.duplicate(true)
	keybinds = default_keybinds.duplicate()
	update_ui_from_settings()
	show_confirmation("Reset to Defaults!")

func show_confirmation(text: String):
	var confirmation = Label.new()
	confirmation.text = text
	confirmation.add_theme_color_override("font_color", Color(0.8, 1, 0.8, 1))
	confirmation.add_theme_font_size_override("font_size", 20)
	confirmation.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	confirmation.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	confirmation.position = Vector2(400, 300)
	confirmation.size = Vector2(200, 50)
	main_panel.add_child(confirmation)
	
	# Animate confirmation
	confirmation.modulate.a = 0.0
	var conf_tween = create_tween()
	conf_tween.tween_property(confirmation, "modulate:a", 1.0, 0.2)
	conf_tween.tween_interval(1.5)  # Changed from tween_delay to tween_interval
	conf_tween.tween_property(confirmation, "modulate:a", 0.0, 0.3)
	conf_tween.tween_callback(confirmation.queue_free)
	
	
# Input handling
func _input(event):
	if awaiting_input and event is InputEventKey and event.pressed:
		keybinds[currently_remapping] = event.keycode
		update_keybind_buttons()
		awaiting_input = false
		currently_remapping = ""
	elif awaiting_input and event is InputEventMouseButton and event.pressed:
		keybinds[currently_remapping] = event.button_index
		update_keybind_buttons()
		awaiting_input = false
		currently_remapping = ""
	elif event.is_action_pressed("ui_cancel") and not awaiting_input:
		_on_close_button_pressed()

# Signal callbacks - Graphics
func _on_resolution_selected(index):
	settings_data["resolution"] = index

func _on_window_mode_selected(index):
	settings_data["window_mode"] = index

func _on_refresh_rate_selected(index):
	settings_data["refresh_rate"] = index

func _on_graphics_preset_selected(index):
	settings_data["graphics_preset"] = index
	# Auto-adjust other settings based on preset
	match index:
		0: # Low
			texture_quality_slider.value = 0
			shadow_quality_slider.value = 0
			anti_aliasing_option.selected = 0
		1: # Medium
			texture_quality_slider.value = 1
			shadow_quality_slider.value = 1
			anti_aliasing_option.selected = 1
		2: # High
			texture_quality_slider.value = 2
			shadow_quality_slider.value = 2
			anti_aliasing_option.selected = 2
		3: # Ultra
			texture_quality_slider.value = 3
			shadow_quality_slider.value = 3
			anti_aliasing_option.selected = 3
	
	_on_texture_quality_changed(texture_quality_slider.value)
	_on_shadow_quality_changed(shadow_quality_slider.value)
	_on_anti_aliasing_selected(anti_aliasing_option.selected)

func _on_texture_quality_changed(value):
	settings_data["texture_quality"] = int(value)
	texture_quality_value.text = quality_names[int(value)]

func _on_shadow_quality_changed(value):
	settings_data["shadow_quality"] = int(value)
	shadow_quality_value.text = quality_names[int(value)]

func _on_anti_aliasing_selected(index):
	settings_data["anti_aliasing"] = index

func _on_vsync_toggled(button_pressed):
	settings_data["vsync"] = button_pressed

# Signal callbacks - Audio
func _on_master_volume_changed(value):
	settings_data["master_volume"] = int(value)
	master_volume_value.text = str(int(value)) + "%"
	AudioServer.set_bus_volume_db(0, linear_to_db(value / 100.0))

func _on_game_volume_changed(value):
	settings_data["game_volume"] = int(value)
	game_volume_value.text = str(int(value)) + "%"

func _on_voice_chat_volume_changed(value):
	settings_data["voice_chat_volume"] = int(value)
	voice_chat_volume_value.text = str(int(value)) + "%"

func _on_voice_chat_enabled_toggled(button_pressed):
	settings_data["voice_chat_enabled"] = button_pressed

func _on_push_to_talk_toggled(button_pressed):
	settings_data["push_to_talk"] = button_pressed

# Signal callbacks - Input
func _on_mouse_sensitivity_changed(value):
	settings_data["mouse_sensitivity"] = value
	mouse_sensitivity_value.text = str(stepify(value, 0.1))

func _on_mouse_invert_y_toggled(button_pressed):
	settings_data["mouse_invert_y"] = button_pressed

func _on_mouse_acceleration_toggled(button_pressed):
	settings_data["mouse_acceleration"] = button_pressed

func _on_gamepad_enabled_toggled(button_pressed):
	settings_data["gamepad_enabled"] = button_pressed

func _on_gamepad_sensitivity_changed(value):
	settings_data["gamepad_sensitivity"] = value
	gamepad_sensitivity_value.text = str(stepify(value, 0.1))

func _on_gamepad_vibration_toggled(button_pressed):
	settings_data["gamepad_vibration"] = button_pressed

# Signal callbacks - Keybinds
func _on_keybind_button_pressed(action: String):
	if awaiting_input:
		return
	
	currently_remapping = action
	awaiting_input = true
	
	# Get the button and change its text
	var button_path = ""
	match action:
		"move_forward":
			button_path = "MainPanel/VBoxContainer/TabContainer/Keybinds/KeybindsContainer/MovementSection/MoveForwardContainer/MoveForwardButton"
		"move_backward":
			button_path = "MainPanel/VBoxContainer/TabContainer/Keybinds/KeybindsContainer/MovementSection/MoveBackwardContainer/MoveBackwardButton"
		"move_left":
			button_path = "MainPanel/VBoxContainer/TabContainer/Keybinds/KeybindsContainer/MovementSection/MoveLeftContainer/MoveLeftButton"
		"move_right":
			button_path = "MainPanel/VBoxContainer/TabContainer/Keybinds/KeybindsContainer/MovementSection/MoveRightContainer/MoveRightButton"
		"jump":
			button_path = "MainPanel/VBoxContainer/TabContainer/Keybinds/KeybindsContainer/MovementSection/JumpContainer/JumpButton"
		"primary_attack":
			button_path = "MainPanel/VBoxContainer/TabContainer/Keybinds/KeybindsContainer/CombatSection/PrimaryAttackContainer/PrimaryAttackButton"
		"secondary_attack":
			button_path = "MainPanel/VBoxContainer/TabContainer/Keybinds/KeybindsContainer/CombatSection/SecondaryAttackContainer/SecondaryAttackButton"
		"reload":
			button_path = "MainPanel/VBoxContainer/TabContainer/Keybinds/KeybindsContainer/CombatSection/ReloadContainer/ReloadButton"
		"voice_chat":
			button_path = "MainPanel/VBoxContainer/TabContainer/Keybinds/KeybindsContainer/CommunicationSection/VoiceChatContainer/VoiceChatButton"
		"chat":
			button_path = "MainPanel/VBoxContainer/TabContainer/Keybinds/KeybindsContainer/CommunicationSection/ChatContainer/ChatButton"
	
	if button_path != "":
		var button = get_node(button_path)
		button.text = "Press any key..."
		
		# Create a timer to timeout the remapping
		var timer = Timer.new()
		timer.wait_time = 10.0
		timer.one_shot = true
		add_child(timer)
		timer.start()
		timer.timeout.connect(_on_remap_timeout.bind(button, action, timer))

func _on_remap_timeout(button: Button, action: String, timer: Timer):
	if awaiting_input and currently_remapping == action:
		awaiting_input = false
		currently_remapping = ""
		button.text = get_key_name(keybinds[action])
	timer.queue_free()

# Signal callbacks - Network
func _on_player_name_changed(new_text: String):
	settings_data["player_name"] = new_text

func _on_region_selected(index):
	settings_data["region"] = index

func _on_max_ping_changed(value):
	settings_data["max_ping"] = int(value)
	max_ping_value.text = str(int(value)) + "ms"

func _on_show_ping_toggled(button_pressed):
	settings_data["show_ping"] = button_pressed

func _on_show_player_names_toggled(button_pressed):
	settings_data["show_player_names"] = button_pressed

# Button callbacks
func _on_close_button_pressed():
	settings_closed.emit()
	hide_settings_menu()

func _on_reset_button_pressed():
	reset_to_defaults()

func _on_apply_button_pressed():
	apply_settings()

# Utility functions
func get_setting(key: String):
	return settings_data.get(key)

func set_setting(key: String, value):
	settings_data[key] = value
	update_ui_from_settings()

func get_all_settings():
	return settings_data.duplicate()

func set_all_settings(new_settings: Dictionary):
	settings_data = new_settings.duplicate()
	update_ui_from_settings()

func get_keybind(action: String):
	return keybinds.get(action)

func set_keybind(action: String, key_code: int):
	keybinds[action] = key_code
	update_keybind_buttons()

func get_all_keybinds():
	return keybinds.duplicate()

# Helper function for rounding values (since stepify is deprecated)
func stepify(value: float, step: float) -> float:
	return round(value / step) * step
