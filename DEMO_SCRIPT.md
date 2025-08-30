# Demo Video Script (step-by-step)

1. **Setup** (show device Settings)
   - Open Settings → General → Keyboard → Keyboards → Add New Keyboard…
   - Add "VoiceBoard"
   - Tap VoiceBoard → Enable "Allow Full Access" (explain why: network + shared storage)

2. **Launch Container App**
   - Open the VoiceBoard app
   - Paste your Groq API Key into the field and press Save
   - Mention: API key is stored in the App Group and accessible by the keyboard extension

3. **Show the Keyboard & Record**
   - Open Notes (or Messages)
   - Tap the globe to switch to VoiceBoard keyboard
   - Press and *hold* the big button: show pulsing recording state; speak one sentence
   - Release the button: show "Transcribing…" state / spinner

4. **Insert Result**
   - Show the transcribed text inserted at cursor
   - Confirm the text is correct (or show minor edits)

5. **Error Handling**
   - Turn on Airplane Mode
   - Record again: release → show graceful network error toast
   - Re-enable network and transcribe successfully

6. **Wrap-up**
   - Mention App Group ID and where to change keys
   - Mention that real-time streaming isn't used (entire file uploaded after release)