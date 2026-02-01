# Manico Enhanced for Windows

macOS Manico와 유사한 Windows 애플리케이션 빠른 전환 도구로, AutoHotkey v2로 작성되었습니다.

![Demo](2026-02-01_11-28-02.gif)

## 기능

- **단축키 앱 전환** - Alt + 해당 키를 눌러 특정 애플리케이션으로 빠르게 전환
- **같은 앱 창 전환** - Alt+=를 눌러 같은 애플리케이션의 여러 창 간 순환 전환
- **자동 앱 실행** - 앱이 실행되지 않은 경우 자동으로 실행 후 전환
- **스마트 숨기기** - 활성화된 앱에서 단축키를 다시 누르면 창 최소화
- **플로팅 아이콘 바** - Alt를 누르면 설정된 모든 앱을 표시하는 가로 아이콘 바 표시
- **무음 모드** - 플로팅 바 없이 직접 앱 전환 가능

## 요구 사항

- Windows 10/11
- [AutoHotkey v2.0](https://www.autohotkey.com/) 이상

## 설정

### 기본 설정

스크립트 상단의 `Config` 객체를 편집하세요:

```autohotkey
global Config := {
    TriggerKey: "LAlt",      ; 트리거 키: LAlt, RAlt, LCtrl, CapsLock 등
    ShowDelay: 100,          ; 표시 지연 (밀리초)
    Silent: false,           ; 무음 모드: true로 설정하면 플로팅 바 숨김
    IconSize: 48,            ; 아이콘 크기
    Opacity: 245,            ; 불투명도 (0-255)
    ...
}
```

### 앱 단축키 설정

`AppShortcuts` 설정을 편집하세요:

```autohotkey
global AppShortcuts := Map(
    "키", { exe: "프로세스.exe", path: "실행 경로", icon: "아이콘 경로" },
)
```

| 필드 | 설명 |
|------|------|
| 키 | 트리거 키를 누른 상태에서 누를 키, 예: `"1"`, `"2"`, `"a"`, `"i"` |
| exe | 프로세스 이름, 앱 실행 여부 감지에 사용 |
| path | 애플리케이션 실행 경로 |
| icon | 아이콘 파일 경로 (.ico 또는 .exe 파일) |

### 설정 예시

```autohotkey
global AppShortcuts := Map(
    "i", { exe: "WindowsTerminal.exe", path: "C:\Users\Administrator\AppData\Local\Microsoft\WindowsApps\wt.exe", icon: "D:\work\src\tool\manico\terminal.ico" },
    "3", { exe: "explorer.exe", path: "explorer.exe", icon: "C:\Windows\explorer.exe" },
    "e", { exe: "Thorium.exe", path: "C:\Users\Administrator\AppData\Local\Thorium\Application\thorium.exe", icon: "C:\Users\Administrator\AppData\Local\Thorium\Application\thorium.exe" },
    "q", { exe: "1Password.exe", path: "C:\Users\Administrator\AppData\Local\Microsoft\WindowsApps\1Password.exe", icon: "C:\Program Files\WindowsApps\Agilebits.1Password_8.12.1.3_x64__amwd9z03whsfe\1Password.exe" },
    "w", { exe: "idea64.exe", path: "C:\Users\Administrator\AppData\Local\Programs\IntelliJ IDEA\bin\idea64.exe", icon: "C:\Users\Administrator\AppData\Local\Programs\IntelliJ IDEA\bin\idea64.exe" },
)
```

## 사용법

1. **스크립트 실행** - `manico_enhanced.ahk`를 더블클릭하여 실행
2. **플로팅 바 표시** - Alt 키 (또는 설정된 트리거 키)를 누름
3. **앱 전환** - Alt를 누른 상태에서 해당 단축키 누름
4. **플로팅 바 숨기기** - Alt 키를 놓음
5. **앱 최소화** - 활성화된 앱에서 단축키를 다시 누름
6. **같은 앱 창 전환** - Alt+=를 눌러 같은 앱의 여러 창 간 전환 (예: 여러 브라우저 창)

## 부팅 시 자동 시작

1. `Win + R`을 눌러 실행 대화상자 열기
2. `shell:startup`을 입력하고 Enter를 눌러 시작 프로그램 폴더 열기
3. `manico_enhanced.ahk`의 바로가기를 이 폴더에 넣기
4. 컴퓨터 재시작 후 스크립트가 자동으로 실행됨

## 트레이 메뉴

시스템 트레이 아이콘을 우클릭:

- **설정 도움말** - 설정 안내 보기
- **사용 도움말** - 사용법 안내 보기
- **새로고침** - 설정 수정 후 스크립트 새로고침
- **종료** - 프로그램 종료

## 애플리케이션 경로 찾기

애플리케이션 경로를 모르는 경우:

1. 대상 애플리케이션 실행
2. 작업 관리자 열기
3. 애플리케이션 프로세스를 찾아 우클릭
4. "파일 위치 열기" 선택
5. 파일 경로 복사

## 문제 해결

### 아이콘이 표시되지 않음

- `icon` 경로가 정확하고 파일이 존재하는지 확인
- `.ico`와 `.exe` 파일 모두 아이콘 소스로 지원됨

### 단축키 충돌

- 시스템에서 이미 사용 중인 단축키 사용 피하기
- `TriggerKey`를 수정하여 다른 트리거 키 사용 가능

### 앱이 전환되지 않음

- `exe` 프로세스 이름이 정확한지 확인 (작업 관리자에서 확인 가능)
- `path`가 정확한지 확인

## 개발

이 프로젝트는 [Claude Code](https://claude.ai/claude-code)의 도움으로 개발되었습니다.

## License

MIT License
