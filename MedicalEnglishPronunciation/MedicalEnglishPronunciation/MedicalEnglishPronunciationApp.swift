import SwiftUI

@main
struct MedicalEnglishPronunciationApp: App {
    @StateObject private var contentStore = ContentStore()
    @StateObject private var speechService = SpeechService()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(contentStore)
                .environmentObject(speechService)
        }
    }
}
