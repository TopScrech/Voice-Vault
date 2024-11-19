import SwiftUI
import AVFoundation

struct RecordingRow: View {
    @Environment(AudioPlayer.self) private var audioPlayer
    
    private var recording: Recording
    
    init(_ recording: Recording) {
        self.recording = recording
    }
    
    var isPlayingThisRecording: Bool {
        audioPlayer.currentlyPlaying?.id == recording.id
    }
    
    var body: some View {
        Button {
            audioPlayer.startPlayback(recording)
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    Text(recording.name)
                        .fontWeight(isPlayingThisRecording ? .bold : .regular)
                    
                    Group {
                        let recordingData = recording.recordingData
                        
                        if let duration = getDuration(recordingData) {
                            Text(DateComponentsFormatter.positional.string(from: duration) ?? "0:00")
                                .caption2()
                                .secondary()
                        }
                    }
                }
                
                Spacer()
            }
        }
        .foregroundStyle(.foreground)
    }
    
    private func getDuration(_ recordingData: Data) -> TimeInterval? {
        do {
            return try AVAudioPlayer(data: recordingData).duration
        } catch {
            print("Failed to get the duration for recording on the list: Recording Name - \(recording.name)")
            return nil
        }
    }
}
