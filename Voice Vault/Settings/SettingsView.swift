import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var storage: ValueStorage
    
    @Query private var recordings: [Recording]
    
    private let bitrates = [1, 6, 8, 10, 12, 48, 96, 196]
    
    @State private var confirmDelete = false
    
    var body: some View {
        List {
            Picker("Codec", selection: $storage.selectedCodec) {
                ForEach(Codec.allCases, id: \.rawValue) {
                    Text($0.name)
                        .tag($0)
                }
            }
            .pickerStyle(.navigationLink)
            .scrollIndicators(.never)
            
            Picker("Bitrate", selection: $storage.bitrate) {
                ForEach(bitrates, id: \.self) {
                    Text("\($0) kHz")
                        .tag($0 * 1000)
                }
            }
            
            Section {
                Button("Delete all recordings", role: .destructive) {
                    confirmDelete = true
                }
                .disabled(recordings.isEmpty)
            } footer: {
                if recordings.isEmpty {
                    Text("You don't have any recordings yet")
                }
            }
        }
        .navigationTitle("Settings")
        .confirmationDialog("Delete all recordings", isPresented: $confirmDelete) {
            Button("Yes, delete all recordings", role: .destructive, action: deleteAll)
        } message: {
            Text("Are you sure you want to delete all recordings?")
        }
    }
    
    private func deleteAll() {
        for rec in recordings {
            modelContext.delete(rec)
        }
    }
}

#Preview {
    SettingsParent()
        .environmentObject(ValueStorage())
}
