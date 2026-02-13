; Manico Enhanced for Windows - AutoHotkey v2
; 横向图标显示的应用切换器
#Requires AutoHotkey v2.0
#SingleInstance Force

; ============== 配置 ==============
global Config := {
    TriggerKey: "LAlt",          ; 触发键：LAlt, RAlt, LCtrl, RCtrl, CapsLock 等
    ShowDelay: 100,              ; 显示延迟（毫秒）
    Silent: false,               ; 静默模式：true 不显示悬浮框，直接切换
    FontName: "Segoe UI",        ; 字体名称
    BGColor: "202020",           ; 背景颜色
    KeyBGColor: "4a9eff",        ; 快捷键背景色
    KeyTextColor: "ffffff",      ; 快捷键文字色
    IconSize: 48,                ; 图标大小
    Opacity: 245,                ; 透明度 (0-255)
    RoundCorner: 12,             ; 圆角大小
    ItemPadding: 15,             ; 每个图标的内边距
    ItemGap: 10,                 ; 图标之间的间距
}

; ============== 应用快捷键配置 ==============
; 格式: "按键", { exe: "进程名.exe", path: "启动路径", icon: "图标路径" }
; 按键: 在按住触发键时按的键（如 "1", "2", "a", "b" 等）
; exe: 进程名，用于检测应用是否运行
; path: 启动路径（如果应用没运行则启动它）
; icon: 图标文件路径（exe 或 ico 文件）
global AppShortcuts := Map(
    "i", { exe: "WindowsTerminal.exe", path: "C:\Users\Administrator\AppData\Local\Microsoft\WindowsApps\wt.exe", icon: "D:\work\src\tool\manico\terminal.ico" },
    "3", { exe: "explorer.exe", path: "explorer.exe", icon: "C:\Windows\explorer.exe" },
    "e", { exe: "Thorium.exe", path: "C:\Users\Administrator\AppData\Local\Thorium\Application\thorium.exe", icon: "C:\Users\Administrator\AppData\Local\Thorium\Application\thorium.exe" },
    "q", { exe: "1Password.exe", path: "C:\Users\Administrator\AppData\Local\Microsoft\WindowsApps\1Password.exe", icon: "C:\Program Files\WindowsApps\Agilebits.1Password_8.12.1.3_x64__amwd9z03whsfe\1Password.exe" },
    "w", { exe: "idea64.exe", path: "C:\Users\Administrator\AppData\Local\Programs\IntelliJ IDEA\bin\idea64.exe", icon: "C:\Users\Administrator\AppData\Local\Programs\IntelliJ IDEA\bin\idea64.exe" },
    "p", { exe: "Doubao.exe", path: "C:\Users\Administrator\AppData\Local\Doubao\Application\app\Doubao.exe", icon: "C:\Users\Administrator\AppData\Local\Doubao\Application\app\Doubao.exe" },
)


; ============== 全局变量 ==============
global AppGui := ""
global IsVisible := false
global ShowTimer := 0
global TriggerHeld := false

; ============== 初始化 ==============
InitHotkeys()
InitSameAppSwitchHotkeys()

InitHotkeys() {
    triggerKey := Config.TriggerKey

    ; 特殊处理 CapsLock
    if (triggerKey = "CapsLock") {
        Hotkey("*CapsLock", OnTriggerDown)
        Hotkey("*CapsLock Up", OnTriggerUp)
        SetCapsLockState("AlwaysOff")
    } else {
        Hotkey("*" triggerKey, OnTriggerDown)
        Hotkey("*" triggerKey " Up", OnTriggerUp)
    }
}

OnTriggerDown(*) {
    global TriggerHeld, ShowTimer

    if (TriggerHeld)
        return

    TriggerHeld := true

    ; 立即注册应用快捷键，不等待 GUI 显示
    RegisterAppHotkeys()

    ; GUI 显示仍然可以延迟
    ShowTimer := SetTimer(ShowAppSwitcher, -Config.ShowDelay)
}
OnTriggerUp(*) {
    global TriggerHeld, ShowTimer, IsVisible

    TriggerHeld := false

    if (ShowTimer) {
        SetTimer(ShowAppSwitcher, 0)
        ShowTimer := 0
    }

    if (IsVisible) {
        HideAppSwitcher()
    }
}

; ============== 同应用窗口切换 ==============
; Ctrl+Alt+[应用快捷键] 在同一应用的多个窗口间切换
InitSameAppSwitchHotkeys() {
    global AppShortcuts

    for key, appInfo in AppShortcuts {
        try {
            fn := SwitchSameAppWindow.Bind(appInfo.exe)
            Hotkey("^!" key, fn)
        }
    }
}

SwitchSameAppWindow(exe, *) {
    ; 获取该应用的所有窗口
    windows := GetAllWindowsOfProcess(exe)

    ; 如果没有窗口或只有一个窗口，不需要切换
    if (windows.Length <= 1)
        return

    ; 获取当前活动窗口
    try {
        activeHwnd := WinGetID("A")
    } catch {
        activeHwnd := 0
    }

    ; 找到当前窗口在列表中的位置，切换到下一个
    currentIndex := 0
    for i, hwnd in windows {
        if (hwnd = activeHwnd) {
            currentIndex := i
            break
        }
    }

    ; 切换到下一个窗口（循环）
    nextIndex := currentIndex >= windows.Length ? 1 : currentIndex + 1
    nextHwnd := windows[nextIndex]

    ActivateWindow(nextHwnd)
}

GetAllWindowsOfProcess(exe) {
    windows := []
    windowList := WinGetList()

    for hwnd in windowList {
        try {
            processName := WinGetProcessName(hwnd)
            if (StrLower(processName) != StrLower(exe))
                continue

            winTitle := WinGetTitle(hwnd)
            if (winTitle = "")
                continue

            ; 检查窗口样式
            style := WinGetStyle(hwnd)
            exStyle := WinGetExStyle(hwnd)

            ; 必须可见
            if !(style & 0x10000000)
                continue

            ; 跳过工具窗口
            if (exStyle & 0x80) && !(exStyle & 0x40000)
                continue

            windows.Push(hwnd)
        }
    }

    ; 按 hwnd 排序，保证每次调用顺序一致（Z-order 会随激活变化）
    n := windows.Length
    loop n - 1 {
        i := A_Index
        loop n - i {
            j := A_Index
            if (windows[j] > windows[j + 1]) {
                tmp := windows[j]
                windows[j] := windows[j + 1]
                windows[j + 1] := tmp
            }
        }
    }

    return windows
}

; ============== 查找应用窗口 ==============
FindAppWindow(exe) {
    windowList := WinGetList()

    for hwnd in windowList {
        try {
            processName := WinGetProcessName(hwnd)
            if (StrLower(processName) != StrLower(exe))
                continue

            winTitle := WinGetTitle(hwnd)
            if (winTitle = "")
                continue

            ; 检查窗口样式
            style := WinGetStyle(hwnd)
            exStyle := WinGetExStyle(hwnd)

            ; 必须可见
            if !(style & 0x10000000)
                continue

            ; 跳过工具窗口
            if (exStyle & 0x80) && !(exStyle & 0x40000)
                continue

            return hwnd
        }
    }
    return 0
}

; ============== 获取图标路径 ==============
GetIconPath(appInfo) {
    if (appInfo.HasProp("icon") && appInfo.icon != "")
        return appInfo.icon
    return ""
}

; ============== 显示切换界面 ==============
ShowAppSwitcher() {
    global AppGui, IsVisible, AppShortcuts

    if (!TriggerHeld)
        return

    if (AppShortcuts.Count = 0)
        return

    ; 静默模式不显示 GUI
    if (!Config.Silent) {
        CreateAppGui()
    }

    IsVisible := true
    ; 移除这里的 RegisterAppHotkeys()，已在 OnTriggerDown 中调用
}

CreateAppGui() {
    global AppGui, AppShortcuts

    if (AppGui) {
        try AppGui.Destroy()
    }

    ; 计算布局 - 横向排列
    appCount := AppShortcuts.Count
    iconSize := Config.IconSize
    itemPadding := Config.ItemPadding
    itemGap := Config.ItemGap
    keyBadgeW := 38  ; 快捷键标签宽度
    keyBadgeH := 16  ; 快捷键标签高度

    itemSize := iconSize + (itemPadding * 2)
    guiWidth := (itemSize * appCount) + (itemGap * (appCount - 1)) + 20
    guiHeight := itemSize + keyBadgeH + 25

    ; 创建 GUI
    AppGui := Gui("+AlwaysOnTop -Caption +ToolWindow")
    AppGui.BackColor := Config.BGColor
    AppGui.MarginX := 0
    AppGui.MarginY := 0

    ; 遍历配置的应用
    index := 0
    for key, appInfo in AppShortcuts {
        x := 10 + (index * (itemSize + itemGap))
        y := 10

        ; 获取图标路径
        iconPath := GetIconPath(appInfo)

        ; 添加图标
        iconX := x + itemPadding
        iconY := y + itemPadding
        iconLoaded := false

        if (iconPath != "" && FileExist(iconPath)) {
            try {
                hIcon := LoadPicture(iconPath, "w" iconSize " h" iconSize, &imgType)
                if (hIcon) {
                    picType := (imgType = 1) ? "HICON:" : "HBITMAP:"
                    AppGui.AddPicture(
                        "x" iconX " y" iconY " w" iconSize " h" iconSize,
                        picType hIcon
                    )
                    iconLoaded := true
                }
            }
        }

        if (!iconLoaded) {
            ; 没有图标时显示首字母
            AppGui.AddText(
                "x" iconX " y" iconY " w" iconSize " h" iconSize " Center c808080 Background303030 +0x200",
                SubStr(appInfo.exe, 1, 1)
            ).SetFont("s16 Bold", Config.FontName)
        }

        ; 快捷键标签（图标下方）
        keyText := "Alt-" StrUpper(key)
        keyX := x + itemPadding + (iconSize - keyBadgeW) / 2
        keyY := y + itemPadding + iconSize + 5

        keyBG := AppGui.AddText(
            "x" keyX " y" keyY " w" keyBadgeW " h" keyBadgeH " Center Background" Config.KeyBGColor
        )

        keyLabel := AppGui.AddText(
            "x" keyX " y" keyY " w" keyBadgeW " h" keyBadgeH " Center c" Config.KeyTextColor " BackgroundTrans +0x200",
            keyText
        )
        keyLabel.SetFont("s8 Bold", Config.FontName)

        index++
    }

    ; 获取屏幕尺寸并居中
    screenWidth := A_ScreenWidth
    screenHeight := A_ScreenHeight
    xPos := (screenWidth - guiWidth) / 2
    yPos := (screenHeight - guiHeight) / 2

    ; 显示窗口
    AppGui.Show("x" xPos " y" yPos " w" guiWidth " h" guiHeight " NoActivate")
    WinSetTransparent(Config.Opacity, AppGui)

    ; 设置圆角
    if (Config.RoundCorner > 0) {
        try {
            DllCall("dwmapi\DwmSetWindowAttribute",
                "Ptr", AppGui.Hwnd,
                "UInt", 33,
                "UInt*", 2,
                "UInt", 4)
        }
    }
}

; ============== 隐藏切换界面 ==============
HideAppSwitcher() {
    global AppGui, IsVisible

    UnregisterAppHotkeys()

    if (AppGui) {
        try AppGui.Destroy()
        AppGui := ""
    }

    IsVisible := false
}

; ============== 快捷键注册/注销 ==============
RegisterAppHotkeys() {
    global AppShortcuts

    for key, appInfo in AppShortcuts {
        try {
            fn := SwitchOrLaunchApp.Bind(appInfo)
            Hotkey("*" key, fn, "On")
        }
    }

    Hotkey("*Escape", (*) => HideAppSwitcher(), "On")
}

UnregisterAppHotkeys() {
    global AppShortcuts

    for key, appInfo in AppShortcuts {
        try Hotkey("*" key, "Off")
    }

    try Hotkey("*Escape", "Off")
}

; ============== 切换或启动应用 ==============
SwitchOrLaunchApp(appInfo, *) {
    global IsVisible, AppGui

    if (!IsVisible)
        return

    exe := appInfo.exe
    path := appInfo.path

    ; 只隐藏 GUI，不注销快捷键（保持可以继续按键切换）
    if (AppGui) {
        try AppGui.Destroy()
        AppGui := ""
    }

    ; 获取该应用的所有窗口
    windows := GetAllWindowsOfProcess(exe)

    if (windows.Length = 0) {
        ; 应用未运行，启动它
        LaunchAndActivate(path, exe)
        return
    }

    ; 找到当前活动窗口在列表中的位置
    try {
        activeHwnd := WinGetID("A")
    } catch {
        activeHwnd := 0
    }

    currentIndex := 0
    for i, hwnd in windows {
        if (hwnd = activeHwnd) {
            currentIndex := i
            break
        }
    }

    if (currentIndex = 0) {
        ; 当前没有该应用的窗口处于激活状态，切换到第一个
        ActivateWindow(windows[1])
    } else if (windows.Length = 1) {
        ; 只有一个窗口且已激活，最小化它
        WinMinimize(windows[1])
    } else {
        ; 有多个窗口，切换到下一个（循环）
        nextIndex := currentIndex >= windows.Length ? 1 : currentIndex + 1
        ActivateWindow(windows[nextIndex])
    }
}

; ============== 激活窗口 ==============
ActivateWindow(hwnd) {
    try {
        if (WinGetMinMax(hwnd) = -1)
            WinRestore(hwnd)

        WinActivate(hwnd)
        WinMoveTop(hwnd)
    }
}

; ============== 启动应用并激活 ==============
LaunchAndActivate(path, exe) {
    try {
        Run(path)

        timeout := 10000
        startTime := A_TickCount

        while (A_TickCount - startTime < timeout) {
            Sleep(100)
            hwnd := FindAppWindow(exe)
            if (hwnd) {
                Sleep(200)
                ActivateWindow(hwnd)
                return
            }
        }
    } catch as e {
        MsgBox("启动应用失败: " path "`n" e.Message, "错误", "16")
    }
}

; ============== 托盘菜单 ==============
A_TrayMenu.Delete()
A_TrayMenu.Add("配置说明", ShowConfig)
A_TrayMenu.Add("使用帮助", ShowHelp)
A_TrayMenu.Add()
A_TrayMenu.Add("重新加载", (*) => Reload())
A_TrayMenu.Add("退出", (*) => ExitApp())

ShowConfig(*) {
    configText := "
    (
    ═══════════════════════════════════
    应用快捷键配置
    ═══════════════════════════════════

    在 AppShortcuts 中配置：

    格式:
    "按键", { exe: "进程名", path: "路径" }

    示例:
    "1", { exe: "chrome.exe", path: "chrome.exe" },
    "2", { exe: "Code.exe", path: "code" },
    "w", { exe: "WeChat.exe", path: "微信路径" },

    按键可以是: 1-9, 0, a-z

    修改后右键托盘选择"重新加载"
    )"

    MsgBox(configText, "配置说明", "64")
}

ShowHelp(*) {
    helpText := "
    (
    ═══════════════════════════════════
    Manico for Windows 使用说明
    ═══════════════════════════════════

    使用方法：
    ─────────────────────────────────
    1. 按住 Alt 键        显示应用图标
    2. 按对应按键         切换/启动应用
    3. 松开 Alt 键        关闭显示
    4. 按 Esc 键          取消
    5. Ctrl+Alt+按键      在同应用多窗口间切换

    功能特点：
    ─────────────────────────────────
    • 横向显示配置的应用图标
    • 图标下方显示快捷键
    • 应用未运行时自动启动
    • Ctrl+Alt+键 切换同应用多窗口
    • 简洁美观的界面
    )"

    MsgBox(helpText, "使用帮助", "64")
}

; 启动提示
if (AppShortcuts.Count > 0) {
    TrayTip("Manico Enhanced", "按住 " Config.TriggerKey " 键显示应用切换器`n已配置 " AppShortcuts.Count " 个应用", 1)
} else {
    TrayTip("Manico Enhanced", "请先配置 AppShortcuts", 2)
}
