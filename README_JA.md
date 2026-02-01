# Manico Enhanced for Windows

macOS Manicoに似たWindowsアプリケーション高速切り替えツール。AutoHotkey v2で作成されています。

![Demo](2026-02-01_11-28-02.gif)

## 機能

- **ホットキーでアプリ切り替え** - Alt + 対応キーを押して特定のアプリケーションに素早く切り替え
- **同一アプリウィンドウ切り替え** - Alt+=を押して同じアプリケーションの複数ウィンドウ間を循環切り替え
- **アプリ自動起動** - アプリが起動していない場合、自動的に起動して切り替え
- **スマート非表示** - アクティブなアプリでホットキーを再度押すとウィンドウを最小化
- **フローティングアイコンバー** - Altを押すと設定されたすべてのアプリを表示する横型アイコンバーを表示
- **サイレントモード** - フローティングバーを表示せずに直接アプリを切り替え可能

## 動作要件

- Windows 10/11
- [AutoHotkey v2.0](https://www.autohotkey.com/) 以上

## 設定

### 基本設定

スクリプト上部の `Config` オブジェクトを編集してください：

```autohotkey
global Config := {
    TriggerKey: "LAlt",      ; トリガーキー: LAlt, RAlt, LCtrl, CapsLock など
    ShowDelay: 100,          ; 表示遅延（ミリ秒）
    Silent: false,           ; サイレントモード: true でフローティングバーを非表示
    IconSize: 48,            ; アイコンサイズ
    Opacity: 245,            ; 不透明度 (0-255)
    ...
}
```

### アプリショートカット設定

`AppShortcuts` 設定を編集してください：

```autohotkey
global AppShortcuts := Map(
    "キー", { exe: "プロセス名.exe", path: "起動パス", icon: "アイコンパス" },
)
```

| フィールド | 説明 |
|------------|------|
| キー | トリガーキーを押しながら押すキー、例: `"1"`, `"2"`, `"a"`, `"i"` |
| exe | プロセス名、アプリの起動状態検出に使用 |
| path | アプリケーション起動パス |
| icon | アイコンファイルパス（.ico または .exe ファイル） |

### 設定例

```autohotkey
global AppShortcuts := Map(
    "i", { exe: "WindowsTerminal.exe", path: "C:\Users\Administrator\AppData\Local\Microsoft\WindowsApps\wt.exe", icon: "D:\work\src\tool\manico\terminal.ico" },
    "3", { exe: "explorer.exe", path: "explorer.exe", icon: "C:\Windows\explorer.exe" },
    "e", { exe: "Thorium.exe", path: "C:\Users\Administrator\AppData\Local\Thorium\Application\thorium.exe", icon: "C:\Users\Administrator\AppData\Local\Thorium\Application\thorium.exe" },
    "q", { exe: "1Password.exe", path: "C:\Users\Administrator\AppData\Local\Microsoft\WindowsApps\1Password.exe", icon: "C:\Program Files\WindowsApps\Agilebits.1Password_8.12.1.3_x64__amwd9z03whsfe\1Password.exe" },
    "w", { exe: "idea64.exe", path: "C:\Users\Administrator\AppData\Local\Programs\IntelliJ IDEA\bin\idea64.exe", icon: "C:\Users\Administrator\AppData\Local\Programs\IntelliJ IDEA\bin\idea64.exe" },
)
```

## 使用方法

1. **スクリプト起動** - `manico_enhanced.ahk` をダブルクリックして実行
2. **フローティングバー表示** - Alt キー（または設定したトリガーキー）を押す
3. **アプリ切り替え** - Altを押しながら対応するショートカットキーを押す
4. **フローティングバー非表示** - Alt キーを離す
5. **アプリ最小化** - アクティブなアプリでショートカットキーを再度押す
6. **同一アプリウィンドウ切り替え** - Alt+=を押して同じアプリの複数ウィンドウ間を切り替え（例：複数のブラウザウィンドウ）

## 自動起動設定

1. `Win + R` を押して「ファイル名を指定して実行」を開く
2. `shell:startup` と入力してEnterを押し、スタートアップフォルダを開く
3. `manico_enhanced.ahk` のショートカットをこのフォルダに配置
4. コンピュータ再起動後、スクリプトが自動的に実行される

## トレイメニュー

システムトレイアイコンを右クリック：

- **設定ヘルプ** - 設定手順を表示
- **使用ヘルプ** - 使用方法を表示
- **再読み込み** - 設定変更後にスクリプトを再読み込み
- **終了** - プログラムを終了

## アプリケーションパスの確認方法

アプリケーションのパスがわからない場合：

1. 対象のアプリケーションを起動
2. タスクマネージャーを開く
3. アプリケーションのプロセスを見つけて右クリック
4. 「ファイルの場所を開く」を選択
5. ファイルパスをコピー

## トラブルシューティング

### アイコンが表示されない

- `icon` パスが正しく、ファイルが存在することを確認
- `.ico` と `.exe` ファイルの両方がアイコンソースとしてサポートされています

### ホットキーの競合

- システムで既に使用されているホットキーの使用を避ける
- `TriggerKey` を変更して別のトリガーキーを使用可能

### アプリが切り替わらない

- `exe` プロセス名が正しいか確認（タスクマネージャーで確認可能）
- `path` が正しいか確認

## 開発

このプロジェクトは [Claude Code](https://claude.ai/claude-code) の支援を受けて開発されました。

## License

MIT License
