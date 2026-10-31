# ShiftLock

CapsLock 키를 **Shift / Alt / Ctrl 수정키의 토글(고정) 키**로 바꿔 주는 Windows 트레이 프로그램입니다.
CapsLock을 한 번 누르면 선택한 수정키가 눌린 상태로 고정되고, 다시 누르면 해제됩니다.

## 다운로드

[`release/`](release/) 폴더에서 최신 버전의 `ShiftLock_<버전>.exe`를 받으세요.

## 요구 사항

- Windows 10 / 11
- .NET Framework 4.8 (Windows 10 1903 이상에는 기본 포함)

설치는 필요 없습니다. exe를 원하는 위치에 두고 실행하면 됩니다.

## 사용법

1. `ShiftLock_<버전>.exe`를 실행합니다. 창은 뜨지 않고 작업 표시줄 오른쪽 **트레이**에 아이콘이 나타납니다. (보이지 않으면 `^` 숨겨진 아이콘을 확인하세요.)
2. 아이콘에는 대상 키 약어가 표시됩니다.

   | 약어 | 키 |
   |------|----|
   | LS / RS | Left Shift / Right Shift |
   | LA / RA | Left Alt / Right Alt |
   | LC / RC | Left Ctrl / Right Ctrl |

3. **CapsLock**을 누르면 대상 키가 눌린 상태로 고정(`LOCKED`)되고, 한 번 더 누르면 해제됩니다.
4. 아이콘이 파란색이면 켜짐(ON), 회색이면 꺼짐(OFF)입니다. 꺼져 있으면 CapsLock을 눌러도 아무 동작도 하지 않습니다.

> 이 프로그램이 실행 중이면 CapsLock 키의 원래 기능(대문자 고정)은 사용할 수 없습니다.

### 트레이 메뉴

아이콘을 **우클릭**하면 메뉴가 열립니다.

| 메뉴 | 설명 |
|------|------|
| Set / Unset | 기능 켜기 / 끄기 |
| Setup | 대상 키, 언어, 자동 실행, 자동 업그레이드 설정 |
| Check for updates... | 새 버전 확인 (있으면 확인 후 업데이트) |
| About ShiftLock... | 프로그램 정보 |
| Status | 현재 상태 (`OFF` / `ON` / `LOCKED`) |
| Exit | 종료 (고정된 키는 자동으로 해제됨) |

### 설정 (Setup)

- **대상 키**: CapsLock으로 토글할 수정키 (기본값 Left Shift)
- **언어**: English / 한국어
- **Windows 시작 시 자동 실행**: 로그인할 때 자동으로 실행
- **최신 버전으로 자동 업그레이드**: 켜면 실행할 때(24시간마다) 최신 릴리스를 확인해 새 버전으로 교체한 뒤 다시 시작합니다. 받은 파일은 크기와 SHA-256을 검증한 뒤에만 교체합니다. 꺼 두면 트레이 메뉴의 **Check for updates...**로 직접 확인할 수 있습니다.

설정은 저장되어 다음 실행 때 그대로 복원됩니다.

### 언어 파일

언어 목록과 문구는 exe와 같은 폴더의 `ShiftLock_len.json`에서 읽습니다. 이 파일이 없으면 내장 영어 문구만 사용합니다. 파일을 편집해 언어를 추가하거나 문구를 바꿀 수 있습니다.

### 설정 파일 (INI)

설정은 exe와 **같은 폴더, 같은 이름의 `.ini` 파일**(예: `ShiftLock_0.8.4.exe` → `ShiftLock_0.8.4.ini`)에 저장됩니다. 파일이 없으면 처음 실행할 때 만들어집니다. 직접 편집해도 되며, 프로그램을 종료한 상태에서 편집하세요. 폴더에 쓸 수 없으면(예: `Program Files`) 이번 실행 동안만 값이 유지됩니다.

```ini
[ShiftLock]
Enabled=True
TargetKey=LeftShift
AutoStart=False
AutoUpgrade=False
LastUpdateCheck=
Language=en
Test=False
TestKey=
```

| 키 | 값 | 기본값 | 설명 |
|----|----|--------|------|
| `Enabled` | `True` / `False` | `True` | CapsLock 변환 켜기 / 끄기 |
| `TargetKey` | `LeftShift` `RightShift` `LeftAlt` `RightAlt` `LeftCtrl` `RightCtrl` | `LeftShift` | CapsLock으로 토글할 수정키 |
| `AutoStart` | `True` / `False` | `False` | Windows 시작 시 자동 실행 |
| `AutoUpgrade` | `True` / `False` | `False` | 최신 릴리스로 자동 업그레이드 |
| `LastUpdateCheck` | 시각 문자열 | (빈 값) | 마지막 업데이트 확인 시각. 프로그램이 관리하므로 직접 고칠 필요 없음 |
| `Language` | `en` / `ko` 등 | `en` | 표시 언어 (언어 목록은 `ShiftLock_len.json`) |
| `Test` | `True` / `False` | `False` | 시작할 때 `--test` 콘솔 모드로 실행 |
| `TestKey` | 대상 키 이름 | (빈 값) | 테스트 모드의 대상 키. 비우면 `LeftShift` |

작성 규칙:

- 모든 항목은 `[ShiftLock]` 섹션 아래에 한 줄에 하나씩 `Key=Value` 형식으로 씁니다.
- 키는 대소문자를 구분하지 않고, 참/거짓은 `True` 또는 `False`입니다.
- 빈 줄과 `;` 또는 `#`로 시작하는 줄은 무시됩니다. 다만 프로그램이 설정을 저장할 때 파일을 다시 쓰므로 주석은 지워집니다.
- 잘못되었거나 없는 값은 기본값을 사용합니다.
- 명령줄 옵션(`--test <키>`)이 INI보다 우선합니다.

> exe 파일 이름이 바뀌면 다른 INI를 사용합니다. 새 버전 exe를 직접 받아 실행하면 이전 INI의 설정이 이어지지 않으니, 필요하면 INI 파일을 새 exe 이름으로 복사하세요. 자동 업그레이드로 교체한 경우에는 exe 이름이 그대로라 설정이 유지됩니다.

## 명령줄 옵션

```powershell
ShiftLock_<버전>.exe --test [LeftShift|RightShift|LeftAlt|RightAlt|LeftCtrl|RightCtrl]
ShiftLock_<버전>.exe --help
```

`--test`는 콘솔 창에서 동작을 확인하는 테스트 모드입니다. CapsLock을 누를 때마다 `LOCKED` / `UNLOCKED`가 출력되고, Enter를 누르면 종료됩니다. INI의 `Test=True` / `TestKey=`로도 같은 모드로 시작할 수 있고, 명령줄이 INI보다 우선합니다.

`--help`는 INI 작성 규칙과 키 목록도 함께 보여 줍니다.

## 문제 해결

- **관리자 권한 프로그램에서 동작하지 않음**: 관리자 권한으로 실행 중인 창에는 입력이 전달되지 않을 수 있습니다. ShiftLock도 관리자 권한으로 실행하세요.
- **수정키가 눌린 채로 남음**: 고정 상태에서 비정상 종료되면 발생할 수 있습니다. 해당 키를 직접 한 번 누르면 풀립니다.
- **보안 프로그램 경고**: 저수준 키보드 훅을 사용하기 때문에 일부 보안 프로그램이 경고할 수 있습니다.
- **중복 실행**: 이미 실행 중이면 새로 실행해도 아무 일도 일어나지 않습니다. 트레이 아이콘을 확인하세요.
- **완전히 제거**: 트레이 메뉴에서 Exit로 종료한 뒤 exe를 삭제하세요. 자동 실행을 켰다면 먼저 Setup에서 해제하세요.

## 버전 히스토리

새 버전은 이전 버전 **위쪽**에 `### <버전>` 제목으로 추가합니다. (최신 버전이 맨 위)
`push-release.ps1`은 이 섹션(`## 버전 히스토리`)에서 배포하는 exe 버전과 같은 `### <버전>` 항목의 내용을 GitHub 릴리스 노트로 사용합니다.
제목은 `### 0.8.1` 또는 `### 0.8.1 (2026-10-30)` 형식으로 쓰고, 내용은 다음 `###` 제목 전까지입니다.

### 0.8.5 (2026-10-31)

- CapsLock 버그 수정: 종료 시 키 훅을 제거한 뒤 수정키 해제를 한 번 더 보내, 고정 상태에서 종료해도 수정키가 눌린 채 남지 않도록 함

### 0.8.4

- 자동 업그레이드 추가: Setup의 "최신 버전으로 자동 업그레이드"를 켜면 GitHub 최신 릴리스를 확인해 새 버전으로 교체 후 다시 시작 (실행 시 24시간마다 확인)
- 트레이 메뉴에 "업데이트 확인..." 추가 (새 버전이 있으면 확인 후 업데이트)
- 내려받은 파일은 크기와 SHA-256을 검증한 뒤에만 교체
- 설정을 exe와 같은 폴더의 `.ini` 파일에 저장 (이전 버전 설정은 처음 한 번 가져옴)
- INI의 `Test` / `TestKey`로 `--test` 모드를 지정할 수 있음 (명령줄이 우선)
- `--help`에 INI 작성 규칙과 키 목록 표시
- 언어 파일 이름을 `ShiftLock_len.json`으로 변경
- Setup 창 높이를 내용에 맞춰 조정 (영문에서 체크박스가 잘리던 문제 수정)
- 트레이 메뉴에 "정보" 추가

### 0.8.3

- 다국어 지원 추가: English / 한국어 (Setup에서 언어 선택, 선택값은 저장됨)
- 언어 목록을 exe와 같은 폴더의 `language.json`에서 읽음 (파일이 없으면 영어만 사용)
- Setup 대화상자와 트레이 메뉴 문구를 선택한 언어로 표시
- 소스 코드에 한글 주석 추가 (동작 변경 없음)

### 0.8.1

- CapsLock을 Shift / Alt / Ctrl 수정키의 토글(고정) 키로 사용하는 트레이 프로그램 최초 공개
- 대상 키 선택 (Left/Right Shift, Alt, Ctrl)
- Windows 시작 시 자동 실행 옵션
