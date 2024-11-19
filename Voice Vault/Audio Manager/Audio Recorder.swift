import SwiftUI
import SwiftData
import AVFoundation

@Observable
final class AudioRecorder {
    var audioRecorder: AVAudioRecorder?
    private var recordingName = "Recording1"
    private var recordingDate = Date()
    private var recordingURL: URL?
    var isRecording = false
    let currentDateTime = Date.now
    
    
    // MARK: - Start Recording
    func startRecording() {
        let recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Start Recording - Failed to set up recording session")
        }
        
        recordingDate = currentDateTime
        recordingName = "\(currentDateTime.toString(dateFormat: "dd-MM-YY_'at'_HH:mm:ss"))"
        
        let tempDirectory = FileManager.default.temporaryDirectory
        let recordingFileURL = tempDirectory.appendingPathComponent(recordingName).appendingPathExtension("m4a")
        recordingURL = recordingFileURL
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatAppleLossless),
            AVSampleRateKey: 48000,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: recordingFileURL, settings: settings)
            audioRecorder?.record()
            
            withAnimation {
                isRecording = true
            }
        } catch {
            print("Start Recording - Could not start recording")
        }
    }
    
    // MARK: - Stop Recording
    func stopRecording(modelContext: ModelContext) {
        audioRecorder?.stop()
        
        withAnimation {
            isRecording = false
        }
        
        if let recordingURL {
            do {
                let recordingData = try Data(contentsOf: recordingURL)
                saveRecordingToSwiftData(recordingData: recordingData, modelContext: modelContext)
            } catch {
                print("Stop Recording - Could not save to SwiftData: \(error)")
            }
        } else {
            print("Stop Recording - Could not find the recording URL")
        }
    }
    
    // MARK: - SwiftData Integration
    private func saveRecordingToSwiftData(recordingData: Data, modelContext: ModelContext) {
        let newRecording = Recording(
            createdAt: currentDateTime,
            name: recordingName,
            recordingData: recordingData
        )
        
        modelContext.insert(newRecording)
        
        deleteRecordingFile()
    }
    
    private func deleteRecordingFile() {
        if let recordingURL {
            do {
                try FileManager.default.removeItem(at: recordingURL)
            } catch {
                print("Stop Recording - Could not delete the recording file: \(error)")
            }
        }
    }
}
