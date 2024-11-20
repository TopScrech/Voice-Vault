import ScrechKit
import SwiftData

struct RecordingsList: View {
    @State private var audioPlayer = AudioPlayer()
    @State private var audioRecorder = AudioRecorder()
    
    @Environment(\.modelContext) private var modelContext
    @Query(animation: .default) private var recordings: [Recording]
    
    @State private var sheetSettings = false
    
    var body: some View {
        List {
            ForEach(recordings) { recording in
                RecordingRow(recording)
            }
            .onDelete(perform: delete)
        }
        .navigationTitle("Voice Vault")
        .toolbar {
            SFButton("gear") {
                sheetSettings = true
            }
            .disabled(audioRecorder.isRecording)
        }
        .sheet($sheetSettings) {
            SettingsView()
        }
        .safeAreaInset(edge: .bottom) {
            VStack {
                PlayerBar()
                RecorderBar()
            }
            .background(.thinMaterial)
        }
        .environment(audioPlayer)
        .environment(audioRecorder)
    }
    
    private func delete(at offsets: IndexSet) {
        offsets.map {
            recordings[$0]
        }
        .forEach(modelContext.delete)
    }
}

#Preview {
    RecordingsList()
    
}
