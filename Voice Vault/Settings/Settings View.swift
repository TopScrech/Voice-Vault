import SwiftUI

struct SettingsView: View {
    @AppStorage("selected_codec") private var selectedCodec: Codec = .appleLossless
    @AppStorage("bitrate") private var bitrate = 48000
    
    //    @State private var bitrateString = ""
    
    private let bitrates = [
        1000,
        8000,
        12000,
        48000,
        96000,
        196000
    ]
    
    var body: some View {
        NavigationView {
            List {
                Picker("Codec", selection: $selectedCodec) {
                    ForEach(Codec.allCases, id: \.rawValue) { codec in
                        Text(codec.name)
                            .tag(codec)
                    }
                }
                .pickerStyle(.navigationLink)
                .scrollIndicators(.never)
                
                Picker("Bitrate", selection: $bitrate) {
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
}
