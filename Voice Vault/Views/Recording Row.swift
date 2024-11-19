import SwiftUI
import AVFoundation

struct RecordingRow: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(AudioPlayer.self) private var audioPlayer
    
    private var recording: Recording
    
    init(_ recording: Recording) {
        self.recording = recording
    }
    
    private var isPlaying: Bool {
        audioPlayer.currentlyPlaying?.id == recording.id
    }
    
    @State private var alertRename = false
    
    var body: some View {
        @Bindable var recording = recording
        
        Button {
            audioPlayer.startPlayback(recording)
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    Text(recording.name)
                        .fontWeight(isPlaying ? .bold : .regular)
                    
                    HStack {
                        let recordingData = recording.recordingData
                        
                        if let duration = getDuration(recordingData) {
                            Text(DateComponentsFormatter.positional.string(from: duration) ?? "0:00")
                        }
                        
                        if let codec = recording.codec {
                            Text(codec)
                        }
                        
                        if let bitrate = recording.bitrate {
                            Text("\(bitrate) kHz")
                        }
                    }
                    .caption2()
                    .secondary()
                }
                
                Spacer()
            }
        }
        .foregroundStyle(.foreground)
        .alert("Rename", isPresented: $alertRename) {
            TextField("New Name", text: $recording.name)
        }
        .contextMenu {
#warning("Implement sharing")
            
            //            ShareLink(item: <#T##URL#>)
            
            Button {
                alertRename = true
            } label: {
                Label("Rename", systemImage: "pencil")
            }
            
            Divider()
            
            Button(role: .destructive) {
                modelContext.delete(recording)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
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
