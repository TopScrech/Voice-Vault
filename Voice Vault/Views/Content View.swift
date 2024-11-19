import SwiftUI

struct ContentView: View {
    @ObservedObject private var audioPlayer = AudioPlayer()
    @State private var audioRecorder = AudioRecorder()
    
    var body: some View {
        NavigationView {
            RecordingsList(audioPlayer: audioPlayer)
                .safeAreaInset(edge: .bottom) {
                    bottomBar
                }
                .navigationTitle("Voice Recorder")
        }
    }
    
    var bottomBar: some View {
        VStack {
            PlayerBar(audioPlayer: audioPlayer)
            
            RecorderBar(audioPlayer: audioPlayer)
                .environment(audioRecorder)
        }
        .background(.thinMaterial)
    }
}

#Preview {
    ContentView()
}
