import SwiftUI
import SwiftData

@main
struct VoiceVault: App {
    private let container: ModelContainer
    
    init() {
        let schema = Schema([Recording.self])
        
        do {
#if targetEnvironment(simulator)
            let configuration = ModelConfiguration(schema: schema, cloudKitDatabase: .none)
#else
            let configuration = ModelConfiguration(schema: schema)
#endif
            container = try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Failed to create model container")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            AppContainer()
        }
        .modelContainer(container)
    }
}
