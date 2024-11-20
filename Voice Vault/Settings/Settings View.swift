import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var storage: ValueStorage
    
    @Query private var recordings: [Recording]
    
    private let bitrates = [1, 6, 8, 10, 12, 48, 96, 196]
    
    @State private var confirmDelete = false
    
    var body: some View {
        NavigationView {
            List {
                Picker("Codec", selection: $storage.selectedCodec) {
                    ForEach(Codec.allCases, id: \.rawValue) { codec in
                        Text(codec.name)
                            .tag(codec)
                    }
                }
                .pickerStyle(.navigationLink)
                .scrollIndicators(.never)
                
                Picker("Bitrate", selection: $storage.bitrate) {
                    ForEach(bitrates, id: \.self) { bitrate in
                        Text("\(bitrate) kHz")
                            .tag(bitrate)
                    }
                }
                
                Section {
                    Button("Delete all recordings", role: .destructive) {
                        confirmDelete = true
                    }
                    .disabled(recordings.isEmpty)
                } footer: {
                    Text("You don't have any recordings yet")
                }
            }
            .navigationTitle("Settings")
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.hidden)
        .confirmationDialog("Delete all recordings", isPresented: $confirmDelete) {
            Button("Yes, delete all recordings", role: .destructive) {
                deleteAll()
            }
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
    SettingsView()
        .environmentObject(ValueStorage())
}
