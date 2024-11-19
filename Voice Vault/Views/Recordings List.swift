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
            }.forEach(modelContext.delete)
        }
    }
}

struct RecordingRow: View {
    @ObservedObject var audioPlayer: AudioPlayer
    var recording: Recording
    
    var isPlayingThisRecording: Bool {
        audioPlayer.currentlyPlaying?.id == recording.id
    }
    
    var body: some View {
        Button {
            audioPlayer.startPlayback(recording: recording)
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    Text(recording.name)
                        .fontWeight(isPlayingThisRecording ? .bold : .regular)
                    
                    Group {
                        let recordingData = recording.recordingData
                        
                        if let duration = getDuration(of: recordingData) {
                            Text(DateComponentsFormatter.positional.string(from: duration) ?? "0:00")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Spacer()
            }
        }
        .foregroundStyle(.foreground)
    }
    
    private func getDuration(of recordingData: Data) -> TimeInterval? {
        do {
            return try AVAudioPlayer(data: recordingData).duration
        } catch {
            print("Failed to get the duration for recording on the list: Recording Name - \(recording.name)")
            return nil
        }
    }
}

#Preview {
    RecordingsList(audioPlayer: AudioPlayer())
}
