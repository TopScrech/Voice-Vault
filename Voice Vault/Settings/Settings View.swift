import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var storage: ValueStorage
    //    @State private var bitrateString = ""
    
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
            }
            .navigationTitle("Settings")
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.hidden)
    }
}

#Preview {
    SettingsView()
        .environmentObject(ValueStorage())
}
