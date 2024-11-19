import ScrechKit
import AVFoundation

final class AudioPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    @Published var currentlyPlaying: Recording?
    @Published var isPlaying = false
    
    var audioPlayer: AVAudioPlayer?
    
    func startPlayback(_ recording: Recording) {
        let recordingData = recording.recordingData
        let playbackSession = AVAudioSession.sharedInstance()
        
        do {
            try playbackSession.setCategory(.playback, mode: .spokenAudio)
            try playbackSession.setActive(true)
            print("Start Recording - Playback session setted")
        } catch {
            print("Play Recording - Failed to set up playback session")
        }
        
        do {
            audioPlayer = try AVAudioPlayer(data: recordingData)
            audioPlayer?.delegate = self
            audioPlayer?.play()
            isPlaying = true
            print("Play Recording - Playing")
            
            withAnimation(.spring()) {
                currentlyPlaying = recording
            }
        } catch {
            print("Play Recording - Playback failed: - \(error)")
            
            withAnimation {
                currentlyPlaying = nil
            }
        }
    }
    
    func pausePlayback() {
        audioPlayer?.pause()
        isPlaying = false
        
        print("Play Recording - Paused")
    }
    
    func resumePlayback() {
        audioPlayer?.play()
        isPlaying = true
        
        print("Play Recording - Resumed")
    }
    
    func stopPlayback() {
        if audioPlayer != nil {
            audioPlayer?.stop()
            isPlaying = false
            print("Play Recording - Stopped")
            
            withAnimation(.spring) {
                self.currentlyPlaying = nil
            }
        } else {
            print("Play Recording - Failed to Stop playing - Coz the recording is not playing")
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            isPlaying = false
            print("Play Recording - Recoring finished playing")
            
            delay(1) {
                withAnimation(.spring) {
                    self.currentlyPlaying = nil
                }
            }
        }
    }
}
