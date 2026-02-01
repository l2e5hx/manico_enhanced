# Manico Enhanced for Windows

一个类似 macOS Manico 的 Windows 应用快速切换工具，使用 AutoHotkey v2 编写。
![Demo](2026-02-01_11-28-02.gif)

## 功能特点

- **快捷键切换应用** - 按住 Alt + 对应按键快速切换到指定应用
- **自动启动应用** - 如果应用未运行，自动启动并切换
- **智能隐藏** - 如果应用已激活，再按一次快捷键最小化窗口
- **悬浮图标栏** - 按住 Alt 显示横向图标栏，展示所有配置的应用
- **静默模式** - 可选择不显示悬浮框，直接切换

## 安装要求

- Windows 10/11
- [AutoHotkey v2.0](https://www.autohotkey.com/) 或更高版本

## 配置说明

### 基础配置

编辑脚本顶部的 `Config` 对象：

```autohotkey
global Config := {
    TriggerKey: "LAlt",      ; 触发键：LAlt, RAlt, LCtrl, CapsLock 等
    ShowDelay: 100,          ; 显示延迟（毫秒）
    Silent: false,           ; 静默模式：true 不显示悬浮框
    IconSize: 48,            ; 图标大小
    Opacity: 245,            ; 透明度 (0-255)
    ...
}
```

### 应用快捷键配置

编辑 `AppShortcuts` 配置：

```autohotkey
global AppShortcuts := Map(
    "按键", { exe: "进程名.exe", path: "启动路径", icon: "图标路径" },
)
```

| 字段 | 说明 |
|------|------|
| 按键 | 按住触发键时按的键，如 `"1"`, `"2"`, `"a"`, `"i"` 等 |
| exe | 进程名，用于检测应用是否运行 |
| path | 应用启动路径 |
| icon | 图标文件路径（.ico 或 .exe 文件） |

### 配置示例

```autohotkey
global AppShortcuts := Map(
    "i", { exe: "WindowsTerminal.exe", path: "C:\Users\Administrator\AppData\Local\Microsoft\WindowsApps\wt.exe", icon: "D:\tools\terminal.ico" },
    "3", { exe: "explorer.exe", path: "explorer.exe", icon: "C:\Windows\explorer.exe" },
    "c", { exe: "chrome.exe", path: "C:\Program Files\Google\Chrome\Application\chrome.exe", icon: "C:\Program Files\Google\Chrome\Application\chrome.exe" },
    "v", { exe: "Code.exe", path: "C:\Program Files\Microsoft VS Code\Code.exe", icon: "C:\Program Files\Microsoft VS Code\Code.exe" },
)
```

## 使用方法

1. **启动脚本** - 双击 `manico_enhanced.ahk` 运行
2. **显示悬浮框** - 按住 Alt 键（或配置的触发键）
3. **切换应用** - 按住 Alt 同时按对应的快捷键
4. **隐藏悬浮框** - 松开 Alt 键
5. **最小化应用** - 对已激活的应用再按一次快捷键

## 开机自启

1. 按 `Win + R` 打开运行对话框
2. 输入 `shell:startup` 回车，打开启动文件夹
3. 将 `manico_enhanced.ahk` 的快捷方式放入该文件夹
4. 重启电脑后脚本会自动运行

## 托盘菜单

右键点击系统托盘图标：

- **配置说明** - 查看配置帮助
- **使用帮助** - 查看使用说明
- **重新加载** - 修改配置后重新加载脚本
- **退出** - 退出程序

## 获取应用路径

如果不确定应用的路径：

1. 运行目标应用
2. 打开任务管理器
3. 找到应用进程，右键点击
4. 选择「打开文件位置」
5. 复制文件路径

## 常见问题

### 图标不显示

- 确保 `icon` 路径正确且文件存在
- 支持 `.ico` 和 `.exe` 文件作为图标源

### 快捷键冲突

- 避免使用系统已占用的快捷键
- 可以修改 `TriggerKey` 使用其他触发键

### 应用无法切换

- 检查 `exe` 进程名是否正确（可在任务管理器中查看）
- 检查 `path` 路径是否正确

## 开发说明

本项目由 [Claude Code](https://claude.ai/claude-code) 辅助开发。

## License

MIT License
