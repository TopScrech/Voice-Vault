import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var storage: ValueStorage
    
    @Query private var recordings: [Recording]
    
    @State private var alertDelete = false
    
    var body: some View {
        List {
            NavigationLink {
                CodecPickerView(selectedCodec: $storage.selectedCodec)
            } label: {
                HStack {
                    Text("Codec")
                    
                    Spacer()
                    
                    Text(storage.selectedCodec.name)
                        .secondary()
                }
            }
            
            Picker("Bitrate", selection: $storage.bitrate) {
                ForEach(Codec.commonSampleRates, id: \.self) {
                    Text(sampleRateLabel($0))
                        .tag($0)
                }
            }
            
            Section {
                Button("Delete all recordings", role: .destructive) {
                    alertDelete = true
                }
                .disabled(recordings.isEmpty)
            } footer: {
                if recordings.isEmpty {
                    Text("You don't have any recordings yet")
                }
            }
        }
        .navigationTitle("Settings")
        .alert("Delete all recordings", isPresented: $alertDelete) {
            Button("Delete all", role: .destructive, action: deleteAll)
        } message: {
            Text("Are you sure you want to delete all recordings?")
        }
    }
    
    private func deleteAll() {
        for rec in recordings {
            modelContext.delete(rec)
        }
    }
    
    private func sampleRateLabel(_ sampleRate: Int) -> String {
        let kilohertz = Double(sampleRate) / 1000
        return kilohertz.formatted(.number.precision(.fractionLength(0...1))) + " kHz"
    }
}

#Preview {
    SettingsParent()
        .environmentObject(ValueStorage())
}
