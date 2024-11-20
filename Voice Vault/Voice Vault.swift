import SwiftUI
import SwiftData

@main
struct VoiceVault: App {
    @StateObject private var storage = ValueStorage()
    
    private let container: ModelContainer
    
    init() {
        let schema = Schema([
            Recording.self
        ])
        
        do {
            container = try ModelContainer(for: schema)
        } catch {
            fatalError("Failed to create model container")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            AppContainer()
        }
        .environmentObject(storage)
        .modelContainer(container)
    }
}
