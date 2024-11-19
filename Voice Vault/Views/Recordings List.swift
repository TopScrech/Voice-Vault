import SwiftUI
import SwiftData
import AVFoundation

struct RecordingsList: View {
    @Environment(\.modelContext) private var modelContext
    @Query(animation: .default) private var recordings: [Recording]
    @ObservedObject var audioPlayer: AudioPlayer
    
    var body: some View {
        List {
            ForEach(recordings) { recording in
                RecordingRow(audioPlayer: audioPlayer, recording: recording)
            }
            .onDelete(perform: delete)
        }
    }
    
    func delete(at offsets: IndexSet) {
        withAnimation {
            offsets.map {
                recordings[$0]
            }
            .forEach(modelContext.delete)
        }
    }
}

#Preview {
    RecordingsList(audioPlayer: AudioPlayer())
}
