# 🎮 Multiplayer Game Settings Menu

A beautifully designed, fully-featured settings menu system for Godot 4 multiplayer games with multiple theme support (Dark, Purple, and White themes).

![Settings Menu Preview](<img width="1920" height="998" alt="image" src="https://github.com/user-attachments/assets/800c2ebf-0b1f-4a3a-94b4-011d69ef173c" />)

## ✨ Features

### 🎨 Multiple Visual Themes
- **Dark Theme** - Default sleek dark interface
- **Purple Theme** - Vibrant purple color scheme
- **White Theme** - Clean light theme alternative

### 📊 Comprehensive Settings Categories

#### Graphics Settings
- **Display Options**: Resolution (720p to 8K), Window Mode, Refresh Rate
- **Quality Presets**: Low, Medium, High, Ultra with automatic configuration
- **Advanced Controls**: Texture Quality, Shadow Quality, Anti-Aliasing, V-Sync

#### 🔊 Audio Settings
- **Volume Controls**: Master, Game, and Voice Chat volume sliders
- **Voice Chat**: Enable/disable voice chat and push-to-talk functionality

#### 🖱️ Input Settings
- **Mouse Configuration**: Sensitivity, Y-axis inversion, acceleration
- **Gamepad Support**: Enable/disable, sensitivity adjustment, vibration control
- **Keybinding System**: Fully customizable control mapping with visual feedback

#### 🌐 Network Settings
- **Connection Options**: Player name, region selection, max ping threshold
- **Gameplay Preferences**: Show ping, display player names

## 🛠️ Technical Implementation

### Code Architecture
```gdscript
extends Control
# Signals for communication with other systems
signal settings_applied()
signal settings_closed()

# Comprehensive settings data structure
var settings_data = {
	"resolution": 1,
	"window_mode": 0,
	"graphics_preset": 1,
	# ... more settings
}
```

### Key Components
- **Animated Transitions**: Smooth fade and scale animations
- **Persistent Storage**: Config file saving/loading system
- **Real-time Preview**: Immediate feedback when adjusting settings
- **Input Remapping**: Dynamic key binding with timeout protection

## 🎯 Usage

### Basic Implementation
```gdscript
# Show the settings menu
$SettingsMenu.show_settings_menu()

# Connect to signals
$SettingsMenu.settings_applied.connect(_on_settings_applied)
$SettingsMenu.settings_closed.connect(_on_settings_closed)
```

### Accessing Settings Programmatically
```gdscript
# Get a specific setting
var sensitivity = $SettingsMenu.get_setting("mouse_sensitivity")

# Get all settings
var all_settings = $SettingsMenu.get_all_settings()

# Set settings programmatically
$SettingsMenu.set_setting("master_volume", 80)
```

## 🎨 Theme System

### Switching Themes
The menu supports three beautiful color schemes:

1. **Dark Theme** (Default): Professional dark interface with blue accents
2. **Purple Theme**: Vibrant purple and magenta color palette
3. **White Theme**: Clean, modern light theme with subtle shadows

### Customization
Easily extend the theme system by modifying the style resources:
```gdscript
# Example theme modification
theme_override_colors/font_color = Color(0.9, 0.9, 0.9, 1)
theme_override_styles/panel = preload("res://themes/purple_theme.tres")
```

## 📱 UI/UX Features

- **Responsive Design**: Adapts to different screen sizes
- **Tab Navigation**: Intuitive category organization
- **Visual Feedback**: Immediate preview of changes
- **Confirmation System**: Visual feedback for applied changes
- **Default Restoration**: One-click reset to default settings

## 🔧 Installation

1. Copy the `SettingsMenu` scene and script to your project
2. Instantiate the menu in your main scene
3. Connect the necessary signals
4. Configure theme files in the `themes/` directory

## 📄 Signals

| Signal | Description |
|--------|-------------|
| `settings_applied()` | Emitted when settings are saved and applied |
| `settings_closed()` | Emitted when the settings menu is closed |

## 🚀 Performance

- **Optimized Rendering**: Efficient control nodes and minimal draw calls
- **Memory Efficient**: Only loads necessary components
- **Smooth Animations**: Hardware-accelerated transitions

## 🤝 Contributing

Feel free to extend this settings menu with:
- Additional setting categories
- New theme variations
- Localization support
- Accessibility options

## 📝 License

This settings menu system is available for use in any Godot project.
