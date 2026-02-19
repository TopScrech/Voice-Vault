import SwiftUI

struct SettingsParent: View {
    var body: some View {
        NavigationView {
            SettingsView()
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.hidden)
    }
}
