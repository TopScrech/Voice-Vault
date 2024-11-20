import SwiftUI
import AVFoundation

struct RecordingRow: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(AudioPlayer.self) private var audioPlayer
    
    private var rec: Recording
    
    init(_ rec: Recording) {
        self.rec = rec
    }
    
    private var isPlaying: Bool {
        audioPlayer.currentlyPlaying?.id == rec.id
    }
    
    private var duration: String {
        getDuration(rec.recordingData)
    }
    
    @State private var alertRename = false
    
    var body: some View {
        @Bindable var rec = rec
        
        Button {
            audioPlayer.startPlayback(rec)
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    Text(rec.name)
                        .bold(isPlaying)
                    
                    HStack(spacing: 5) {
                        Text(duration)
                        
                        if let codec = rec.codec {
                            Text(codec)
                        }
                        
                        if let bitrate = rec.bitrate {
                            Text("\(bitrate / 1000) kHz")
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
            TextField("New Name", text: $rec.name)
        }
        .contextMenu {
#warning("Implement sharing")
            
            //            if let data = rec.recordingData, let url = try? AVAudioPlayer(data: data).url {
            //                ShareLink(item: url)
            //            }
            
            Button {
                alertRename = true
            } label: {
                Label("Rename", systemImage: "pencil")
            }
            
            Divider()
            
            Button(role: .destructive) {
                modelContext.delete(rec)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
    
    private func getDuration(_ recordingData: Data?) -> String {
        guard let recordingData else {
            return "0:00"
        }
        
        do {
            let duration = try AVAudioPlayer(data: recordingData).duration
            return DateComponentsFormatter.positional.string(from: duration) ?? "0:00"
        } catch {
            print("Failed to get duration for recording '\(rec.name)'")
            return "0:00"
        }
    }
}
