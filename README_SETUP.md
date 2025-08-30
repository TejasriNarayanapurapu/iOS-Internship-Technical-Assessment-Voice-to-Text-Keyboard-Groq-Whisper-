# Setup Steps (detailed)

1. Open Xcode 15+.
2. Create a new **iOS App** project:
   - Product Name: VoiceBoard
   - Team: your Apple Developer Team (for device testing)
   - Interface: Storyboard or SwiftUI (we use UIKit sources)
   - Language: Swift
3. Add a **Keyboard Extension** target:
   - File → New → Target → iOS → Custom Keyboard Extension
   - Product Name: VoiceBoardKeyboard
4. Create App Group:
   - Select both targets → Signing & Capabilities → + Capability → App Groups
   - Add group identifier: `group.com.assignment.voiceboard`
   - Update `Shared.appGroupId` in both `Shared.swift` files if you change it.
5. Info.plist keys:
   - Container App Info.plist: add `NSMicrophoneUsageDescription` with a friendly message.
   - Extension Info.plist: set `RequestsOpenAccess` to `YES`.
6. Copy the `VoiceBoard` and `VoiceBoardKeyboard` folders from this bundle into your Xcode project (Add Files to "VoiceBoard"...).
7. Make sure each Swift file target membership includes the correct target (app or extension).
8. Build & Run the container app on your device, paste your Groq API key in the UI and Save.
9. On device: Settings → General → Keyboard → Add New Keyboard → VoiceBoard → Allow Full Access.
10. Open Notes or Messages, switch to VoiceBoard keyboard, press-and-hold the button, speak, release to transcribe.

## Notes
- Keyboard extensions require "Full Access" for network and shared container. Use carefully when testing.
- For production, avoid storing raw API keys in client; use a proxied backend.