# VoiceBoard — iOS Voice-to-Text Keyboard (Starter Project)

This bundle contains the project folder structure and source files for the iOS Internship Technical Assessment:
**Custom keyboard extension** using press-and-hold audio recording → upload complete file → Groq Whisper transcription → insert text.

IMPORTANT: This bundle contains all Swift source files, Info.plist snippets and a detailed README and demo script. 
It does **not** include a generated `.xcodeproj` file; instead you can quickly create a new Xcode project and add these files (instructions below).

## What is included
- `VoiceBoard/` — Container app source files (AppDelegate, RootViewController, SecretsStore, Shared)
- `VoiceBoardKeyboard/` — Keyboard extension source files (KeyboardViewController, AudioRecorder, GroqWhisperService, PulseButton, SpinnerView, Shared)
- `README_SETUP.md` — Exact setup steps to create an Xcode project, configure App Group, and run the app on device.
- `DEMO_SCRIPT.md` — Demo video script and checklist
- `LICENSE` — MIT license

## Quick instructions to open in Xcode
1. Open Xcode → File → New → Project → App. Name it `VoiceBoard` and use Swift + UIKit.
2. Add a new target: **Keyboard Extension** (App Extension → Custom Keyboard). Name it `VoiceBoardKeyboard`.
3. In the project navigator, create the folders `VoiceBoard` and `VoiceBoardKeyboard`. Add the respective `.swift` and `.plist` files from this bundle into each target.
4. Follow `README_SETUP.md` to configure App Groups, entitlements, and Info.plist keys.
5. Build & run the container app on a device (keyboard extensions require a device to test microphone and full access).

If you'd like, I can try to generate a full `.xcodeproj` as well (it is more involved). For now, this bundle lets you create the project quickly by adding the provided files.