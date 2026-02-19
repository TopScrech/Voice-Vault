import ScrechKit
import AVFoundation
import OSLog

@Observable
final class AudioPlayer: NSObject, AVAudioPlayerDelegate {
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "dev.topscrech.Voice-Vault",
        category: "AudioPlayer"
    )
    
    var audioPlayer: AVAudioPlayer?
    var currentlyPlaying: Recording?
    var isPlaying = false
    
    func startPlayback(_ recording: Recording) {
        guard let recordingData = recording.recordingData else {
            return
        }
        
        let playbackSession = AVAudioSession.sharedInstance()
        
        do {
            try playbackSession.setCategory(.playback, mode: .spokenAudio)
            try playbackSession.setActive(true)
            logger.info("Start Recording - Playback session set")
        } catch {
            logger.error("Play Recording - Failed to set up playback session: \(error.localizedDescription)")
        }
        
        do {
            audioPlayer = try AVAudioPlayer(data: recordingData)
            audioPlayer?.delegate = self
            audioPlayer?.play()
            isPlaying = true
            logger.info("Play Recording - Playing")
            
            withAnimation(.spring()) {
                currentlyPlaying = recording
            }
        } catch {
            logger.error("Play Recording - Playback failed: \(error.localizedDescription)")
            
            withAnimation {
                currentlyPlaying = nil
            }
        }
    }
    
    func pausePlayback() {
        audioPlayer?.pause()
        isPlaying = false
        
        logger.info("Play Recording - Paused")
    }
    
    func resumePlayback() {
        audioPlayer?.play()
        isPlaying = true
        
        logger.info("Play Recording - Resumed")
    }
    
    func stopPlayback() {
        guard let audioPlayer else {
            logger.error("Play Recording - Failed to stop playing because a recording is not active")
            return
        }
        
        audioPlayer.stop()
        isPlaying = false
        
        logger.info("Play Recording - Stopped")
        
        withAnimation(.spring) {
            self.currentlyPlaying = nil
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        guard flag else { return }
        
        isPlaying = false
        logger.info("Play Recording - Recording finished playing")
        
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(1))
            
            withAnimation(.spring) {
                self.currentlyPlaying = nil
            }
        }
    }
}
