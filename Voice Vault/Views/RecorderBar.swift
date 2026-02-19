import SwiftUI

struct RecorderBar: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(AudioRecorder.self) private var audioRecorder
    @Environment(AudioPlayer.self) private var audioPlayer
    @EnvironmentObject private var storage: ValueStorage
    
    @State private var buttonSize = 1.0
    
    private var repeatingAnimation: Animation {
        Animation.linear(duration: 0.5)
            .repeatForever()
    }
    
    var body: some View {
        VStack {
            // Duration
            if let audioRecorder = audioRecorder.audioRecorder, audioRecorder.isRecording {
                TimelineView(.periodic(from: .now, by: 1)) { _ in
                    Text(DateComponentsFormatter.positional.string(from: audioRecorder.currentTime) ?? "0:00")
                        .title3()
                        .semibold()
                }
                .transition(.scale)
            }
            
            recordButton
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    var recordButton: some View {
        Button {
            if audioRecorder.isRecording {
                stopRecording()
            } else {
                startRecording()
            }
        } label: {
            Image(systemName: audioRecorder.isRecording ? "stop.circle.fill" : "mic.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 65, height: 65)
                .clipped()
                .foregroundColor(.red)
                .scaleEffect(buttonSize)
                .onChange(of: audioRecorder.isRecording) { _, isRecording in
                    if isRecording {
                        withAnimation(repeatingAnimation) {
                            buttonSize = 1.1
                        }
                    } else {
                        withAnimation {
                            buttonSize = 1
                        }
                    }
                }
        }
    }
    
    func startRecording() {
        if audioPlayer.audioPlayer?.isPlaying ?? false {
            // Stop any playback
            audioPlayer.stopPlayback()
            
            Task {
                try? await Task.sleep(for: .seconds(1))
                await MainActor.run {
                    // Start
                    audioRecorder.startRecording(codec: storage.selectedCodec, bitrate: storage.bitrate)
                }
            }
        } else {
            // Start
            audioRecorder.startRecording(codec: storage.selectedCodec, bitrate: storage.bitrate)
        }
    }
    
    func stopRecording() {
        // Stop
        audioRecorder.stopRecording(modelContext)
    }
}

#Preview {
    RecorderBar()
        .environment(AudioPlayer())
        .environment(AudioRecorder())
}
