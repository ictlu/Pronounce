import SwiftUI

struct SpeakButton: View {
    @EnvironmentObject private var speechService: SpeechService

    let text: String
    var label: String = "发音"

    private var isActive: Bool {
        speechService.activeText == text && (speechService.isSpeaking || speechService.isPaused)
    }

    var body: some View {
        Button {
            if speechService.isSpeaking, speechService.activeText == text {
                speechService.pause()
            } else {
                speechService.speak(text)
            }
        } label: {
            Label(isActive ? (speechService.isPaused ? "继续" : "暂停") : label, systemImage: isActive ? "pause.circle.fill" : "speaker.wave.2.fill")
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.regular)
        .accessibilityLabel("\(label)：\(text)")
    }
}
