import ScrechKit
import SwiftData

struct RecordingsList: View {
    @State private var audioPlayer = AudioPlayer()
    @State private var audioRecorder = AudioRecorder()
    @StateObject private var storage = ValueStorage()
    
    @Environment(\.modelContext) private var modelContext
    @Query(animation: .default) private var recordings: [Recording]
    
    @State private var sheetSettings = false
    
    var body: some View {
        List {
            ForEach(recordings) { recording in
                RecordingRow(recording)
            }
            .onDelete(perform: delete)
            
            if recordings.isEmpty && !audioRecorder.isRecording {
                ContentUnavailableView("You don't have any recordings yet", systemImage: "microphone.badge.plus", description: Text("Start recording right now!"))
            }
        }
        .navigationTitle("Voice Vault")
        .sheet($sheetSettings) {
            SettingsParent()
        }
        .toolbar {
            SFButton("gear") {
                sheetSettings = true
            }
            .disabled(audioRecorder.isRecording)
        }
        .safeAreaInset(edge: .bottom) {
            VStack {
                PlayerBar()
                RecorderBar()
            }
            .background(.thinMaterial)
        }
        .environmentObject(storage)
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
