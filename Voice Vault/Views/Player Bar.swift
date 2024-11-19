import SwiftUI

struct PlayerBar: View {
    @ObservedObject var audioPlayer: AudioPlayer
    
    @State private var sliderValue = 0.0
    @State private var isDragging = false
    
    let timer = Timer
        .publish(every: 1/120, on: .main, in: .common)
        .autoconnect()
    
    var body: some View {
        if let player = audioPlayer.audioPlayer, let currentlyPlaying = audioPlayer.currentlyPlaying {
            VStack {
                Slider(value: $sliderValue, in: 0...player.duration) { dragging in
                    print("Editing the slider: \(dragging)")
                    isDragging = dragging
                    
                    if !dragging {
                        player.currentTime = sliderValue
                    }
                }
                .tint(.primary)
                
                // Time passed & remaining
                HStack {
                    Text(DateComponentsFormatter.positional.string(from: player.currentTime) ?? "0:00")
                    
                    Spacer()
                    
                    Text("-\(DateComponentsFormatter.positional.string(from: (player.duration - player.currentTime) ) ?? "0:00")")
                }
                .font(.caption)
                .foregroundColor(.secondary)
                
                HStack(spacing: 15) {
                    Button {
                        if audioPlayer.isPlaying {
                            // Pause
                            audioPlayer.pausePlayback()
                        } else {
                            // Play
                            audioPlayer.resumePlayback()
                        }
                    } label: {
                        Image(systemName: audioPlayer.isPlaying ? "pause.fill" : "play.fill")
                            .font(.title2)
                            .imageScale(.large)
                    }
                    
                    // Recording name
                    Text(currentlyPlaying.name)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    // Stop button
                    Button {
                        audioPlayer.stopPlayback()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .imageScale(.large)
                            .symbolRenderingMode(.hierarchical)
                    }
                }
                .padding(.top, 10)
            }
            .padding()
            .foregroundColor(.primary)
            .onAppear {
                sliderValue = 0
            }
            .onReceive(timer) { _ in
                guard let player = audioPlayer.audioPlayer, !isDragging else { return }
                sliderValue = player.currentTime
            }
            .transition(.scale(scale: 0, anchor: .bottom))
            
            Divider()
        }
    }
}

#Preview {
    PlayerBar(audioPlayer: AudioPlayer())
}
