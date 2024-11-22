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
    @State private var sheetShare = false
    @State private var localUrl: URL? = nil
    
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
                        if let codec = rec.codec {
                            Text(codec.name)
                        }
                        
                        if let bitrate = rec.bitrate {
                            Text("\(bitrate / 1000) kHz")
                        }
                    }
                    .caption2()
                    .secondary()
                }
                
                Spacer()
                
                Text(duration)
                    .secondary()
            }
        }
        .foregroundStyle(.foreground)
        .alert("Rename", isPresented: $alertRename) {
            TextField("New Name", text: $rec.name)
        }
        .onDrag {
            let url = dataToFile(rec.recordingData)
            localUrl = url
            
            return NSItemProvider(contentsOf: url)!
        }
        .sheet($sheetShare) {
            NavigationView {
                SheetShare(localUrl)
            }
            .presentationDetents([.medium])
        }
        .contextMenu {
            Button {
                alertRename = true
            } label: {
                Label("Rename", systemImage: "pencil")
            }
            
            Button {
                sheetShare = true
            } label: {
                Label("Share", systemImage: "square.and.arrow.up")
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
