import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var storage: ValueStorage
    
    @Query private var recordings: [Recording]
    
    private let bitrates = [
        1,
        6,
        8,
        10,
        12,
        48,
        96,
        196
    ]
    
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
                        Text(bitrate)
                            .tag(bitrate)
                    }
                }
                
#if DEBUG
                Section {
                    Button("Delete All", role: .destructive) {
                        deleteAll()
                    }
                }
#endif
            }
            .navigationTitle("Settings")
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.hidden)
    }
    
    private func deleteAll() {
        for rec in recordings {
            modelContext.delete(rec)
        }
        
        do {
            try modelContext.save()
        } catch {
            print("Not saved")
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(ValueStorage())
}
