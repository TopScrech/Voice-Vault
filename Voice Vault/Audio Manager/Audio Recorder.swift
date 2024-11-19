import ScrechKit
import SwiftData
import AVFoundation

@Observable
final class AudioRecorder {
    var audioRecorder: AVAudioRecorder?
    var isRecording = false
    var isPermissionGranted = false
    
    private var recordingName = "Recording1"
    private var recordingDate = Date()
    private var recordingURL: URL?
    
    private let currentDateTime = Date.now
    
    init() {
        checkAndRequestMicAccess()
    }
    
    func checkAndRequestMicAccess() {
        switch AVAudioApplication.shared.recordPermission {
        case .granted:
            isPermissionGranted = true
            
        case .denied:
            isPermissionGranted = false
            
        case .undetermined:
            AVAudioApplication.requestRecordPermission { granted in
                main {
                    self.isPermissionGranted = granted
                }
            }
            
        default:
            isPermissionGranted = false
        }
    }
    
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
        recordingName = "\(currentDateTime.toString(dateFormat: "dd-MM-YY 'at' HH:mm:ss"))"
        
        let tempDirectory = FileManager.default.temporaryDirectory
        let recordingFileURL = tempDirectory.appendingPathComponent(recordingName).appendingPathExtension("m4a")
        recordingURL = recordingFileURL
        
        let storage = ValueStorage()
        let codec = storage.selectedCodec.rawValue
        let bitrate = storage.bitrate * 1000
        
        let settings = [
            AVFormatIDKey: codec,
            AVSampleRateKey: bitrate,
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
    func stopRecording(_ modelContext: ModelContext) {
        audioRecorder?.stop()
        
        withAnimation {
            isRecording = false
        }
        
        if let recordingURL {
            do {
                let recordingData = try Data(contentsOf: recordingURL)
                saveNewRecording(modelContext, recordingData)
            } catch {
                print("Stop Recording - Could not save to SwiftData: \(error)")
            }
        } else {
            print("Stop Recording - Could not find the recording URL")
        }
    }
    
    // MARK: - SwiftData Integration
    private func saveNewRecording(_ modelContext: ModelContext, _ recordingData: Data) {
        let storage = ValueStorage()
        let codec = storage.selectedCodec.name
        let bitrate = storage.bitrate

        let newRecording = Recording(
            createdAt: currentDateTime,
            name: recordingName,
            recordingData: recordingData,
            bitrate: bitrate,
            codec: codec
        )
        
        modelContext.insert(newRecording)
        try! modelContext.save()
        
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
