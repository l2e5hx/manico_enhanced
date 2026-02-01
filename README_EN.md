# Manico Enhanced for Windows

A Windows application quick switcher similar to macOS Manico, written in AutoHotkey v2.

![Demo](2026-02-01_11-28-02.gif)

## Features

- **Hotkey App Switching** - Hold Alt + corresponding key to quickly switch to a specific application
- **Auto Launch Apps** - Automatically launch and switch to an app if it's not running
- **Smart Hide** - Press the hotkey again on an active app to minimize the window
- **Floating Icon Bar** - Hold Alt to display a horizontal icon bar showing all configured apps
- **Silent Mode** - Option to switch apps directly without showing the floating bar

## Requirements

- Windows 10/11
- [AutoHotkey v2.0](https://www.autohotkey.com/) or higher

## Configuration

### Basic Configuration

Edit the `Config` object at the top of the script:

```autohotkey
global Config := {
    TriggerKey: "LAlt",      ; Trigger key: LAlt, RAlt, LCtrl, CapsLock, etc.
    ShowDelay: 100,          ; Display delay (milliseconds)
    Silent: false,           ; Silent mode: true to hide floating bar
    IconSize: 48,            ; Icon size
    Opacity: 245,            ; Opacity (0-255)
    ...
}
```

### App Shortcut Configuration

Edit the `AppShortcuts` configuration:

```autohotkey
global AppShortcuts := Map(
    "key", { exe: "process.exe", path: "launch path", icon: "icon path" },
)
```

| Field | Description |
|-------|-------------|
| key | Key to press while holding the trigger key, e.g., `"1"`, `"2"`, `"a"`, `"i"` |
| exe | Process name, used to detect if the app is running |
| path | Application launch path |
| icon | Icon file path (.ico or .exe file) |

### Configuration Example

```autohotkey
global AppShortcuts := Map(
    "i", { exe: "WindowsTerminal.exe", path: "C:\Users\Administrator\AppData\Local\Microsoft\WindowsApps\wt.exe", icon: "D:\tools\terminal.ico" },
    "3", { exe: "explorer.exe", path: "explorer.exe", icon: "C:\Windows\explorer.exe" },
    "c", { exe: "chrome.exe", path: "C:\Program Files\Google\Chrome\Application\chrome.exe", icon: "C:\Program Files\Google\Chrome\Application\chrome.exe" },
    "v", { exe: "Code.exe", path: "C:\Program Files\Microsoft VS Code\Code.exe", icon: "C:\Program Files\Microsoft VS Code\Code.exe" },
)
```

## Usage

1. **Launch Script** - Double-click `manico_enhanced.ahk` to run
2. **Show Floating Bar** - Hold the Alt key (or configured trigger key)
3. **Switch Apps** - While holding Alt, press the corresponding shortcut key
4. **Hide Floating Bar** - Release the Alt key
5. **Minimize App** - Press the shortcut key again on an active app

## Auto Start on Boot

1. Press `Win + R` to open the Run dialog
2. Type `shell:startup` and press Enter to open the Startup folder
3. Place a shortcut to `manico_enhanced.ahk` in this folder
4. The script will run automatically after restarting your computer

## Tray Menu

Right-click the system tray icon:

- **Configuration Help** - View configuration instructions
- **Usage Help** - View usage instructions
- **Reload** - Reload the script after modifying configuration
- **Exit** - Exit the program

## Finding Application Paths

If you're unsure of an application's path:

1. Run the target application
2. Open Task Manager
3. Find the application process and right-click
4. Select "Open file location"
5. Copy the file path

## Troubleshooting

### Icons Not Displaying

- Ensure the `icon` path is correct and the file exists
- Both `.ico` and `.exe` files are supported as icon sources

### Hotkey Conflicts

- Avoid using system-reserved hotkeys
- You can modify `TriggerKey` to use a different trigger key

### App Won't Switch

- Check if the `exe` process name is correct (can be found in Task Manager)
- Check if the `path` is correct

## Development

This project was developed with assistance from [Claude Code](https://claude.ai/claude-code).

## License

MIT License
