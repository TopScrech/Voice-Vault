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
                        if let recordingData = rec.recordingData, let duration = getDuration(recordingData) {
                            Text(DateComponentsFormatter.positional.string(from: duration) ?? "0:00")
                        }
                        
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
    
    private func getDuration(_ recordingData: Data) -> TimeInterval? {
        do {
            return try AVAudioPlayer(data: recordingData).duration
        } catch {
            print("Failed to get the duration for recording on the list: Recording Name - \(rec.name)")
            return nil
        }
    }
}
