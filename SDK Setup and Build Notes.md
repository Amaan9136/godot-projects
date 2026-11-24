# Godot Android APK — SDK Setup and Build Notes
`> **Configuration Note:** All paths documented here reflect the original developer's environment and configuration and must remain unchanged.`

## Project

- Working directory: `D:\0 AMAAN MAIN\Codes and Tools\My Game Dev\godot-projects\`
- Godot project: `D:\0 AMAAN MAIN\Codes and Tools\My Game Dev\godot-projects\dodge-game\`
- Android preset: `Android`
- APK output: `dodge-game\builds\dodge-game.apk`
- APK signature file: `dodge-game\builds\dodge-game.apk.idsig`
- Package ID: `com.dodgegame.app`
- Version: `1.0.0`
- Architecture: ARM64
- Gradle build: disabled

## Confirmed installed components

Android SDK root:

`C:\Users\Amaan M k\AppData\Local\Android\Sdk\`

- Platform tools / ADB: installed
- Android platform 35: installed
- Build tools 35.0.1: installed
- Android command-line tools: installed
- NDK 28.1.13356709: installed
- CMake 3.10.2.4988404: installed
- Godot Android export templates 4.7.2: installed
- Godot debug keystore: `C:\Users\Amaan M k\AppData\Roaming\Godot\keystores\debug.keystore`
- Godot editor settings: `C:\Users\Amaan M k\AppData\Roaming\Godot\editor_settings-4.7.tres`

The first audit checked the wrong settings filename (`editor_settings-4.tres`) and the default Android debug-keystore location. The correct files already exist; do not generate or download replacements.

## Java

Use the installed Java 17:

`C:\Program Files\Eclipse Adoptium\jdk-17.0.21.10002-hotspot\`

Android Studio's bundled JBR is Java 21, so do not use that as the Godot Java SDK path for this setup.

## Godot settings

Open Godot 4.7.2 → Editor → Editor Settings → Export → Android.

Set:

- Java SDK Path: `C:\Program Files\Eclipse Adoptium\jdk-17.0.21.10002-hotspot`
- Android SDK Path: `C:\Users\Amaan M k\AppData\Local\Android\Sdk\`
- Debug Keystore: `C:\Users\Amaan M k\AppData\Roaming\Godot\keystores\debug.keystore`

The editor settings file exists at:

`C:\Users\Amaan M k\AppData\Roaming\Godot\editor_settings-4.7.tres`

## Find Godot executable (targeted search)

The earlier audit did not find Godot through PATH. This searches the likely locations only:

```powershell
$Roots = @(
    "C:\Program Files",
    "C:\Program Files (x86)",
    "$env:LOCALAPPDATA\Programs",
    "$env:USERPROFILE\Downloads",
    "$env:USERPROFILE\Desktop",
    "D:\0 AMAAN MAIN\Codes and Tools\My Game Dev"
) | Where-Object { Test-Path $_ }

$GodotExe = foreach ($root in $Roots) {
    Get-ChildItem $root -File -Filter "Godot_v4.7.2-stable_win64*.exe" -Recurse -Depth 7 -ErrorAction SilentlyContinue |
        Select-Object -ExpandProperty FullName
}
$GodotExe | Sort-Object -Unique
```

Confirmed Godot executables:

- Console: `D:\0 AMAAN MAIN\Codes and Tools\My Game Dev\Godot\4.7.2\Godot_v4.7.2-stable_win64_console.exe`
- Standard: `D:\0 AMAAN MAIN\Codes and Tools\My Game Dev\Godot\4.7.2\Godot_v4.7.2-stable_win64.exe`

Use the console executable to see export output and errors in PowerShell.

## Build or rebuild the debug APK

Run from the Godot projects working directory:

```powershell
$Project = (Resolve-Path ".\dodge-game").Path
$GodotExe = "D:\0 AMAAN MAIN\Codes and Tools\My Game Dev\Godot\4.7.2\Godot_v4.7.2-stable_win64_console.exe"
$Output = Join-Path $Project "builds\dodge-game.apk"

New-Item -ItemType Directory -Force (Split-Path $Output) | Out-Null

& $GodotExe --headless --path $Project --export-debug "Android" $Output
```

Expected output files:

- `dodge-game\builds\dodge-game.apk` — the actual Android application.
- `dodge-game\builds\dodge-game.apk.idsig` — the APK's additional v4 signature data, used for incremental installation.

### Important: Update both files after every rebuild

Whenever you export a new APK:

1. Run the export command again.
2. Let Godot generate the new `.apk` and corresponding `.apk.idsig`.
3. Replace the previous APK and its corresponding `.idsig` with the newly generated files.
4. Keep the two files from the same export together if you use incremental installation.

Do not manually modify or reuse an old `.idsig` with a newly exported APK.

The `.idsig` is not the game itself. For normal installation, sharing, or transferring the APK to a phone for manual installation, the `.apk` alone is sufficient. The `.idsig` is relevant to APK Signature Scheme v4 incremental installation.

## Install on an Android phone

Connect the phone, enable USB debugging, unlock it, and accept the USB debugging authorization prompt.

```powershell
$Adb = "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe"
& $Adb devices
& $Adb install -r ".\dodge-game\builds\dodge-game.apk"
```

The device must appear as `device` (not `unauthorized`) in the `adb devices` output.

For normal ADB installation, only the APK is required. USB debugging can be turned off afterward if you no longer need ADB.