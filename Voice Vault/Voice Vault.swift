import SwiftUI
import SwiftData

@main
struct Voice_VaultApp: App {
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
            ContentView()
        }
        .modelContainer(container)
    }
}
