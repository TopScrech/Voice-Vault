import ScrechKit
import SwiftData
import AVFoundation
import OSLog

@Observable
final class AudioRecorder {
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "dev.topscrech.Voice-Vault",
        category: "AudioRecorder"
    )

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
    func startRecording(codec: Codec, bitrate: Int) {
        let format = "dd-MM-YY 'at' HH:mm:ss"
        let recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            logger.error("Start Recording - Failed to set up recording session: \(error.localizedDescription)")
        }
        
        recordingDate = currentDateTime
        recordingName = currentDateTime.toString(dateFormat: format)
        
        let tempDir = FileManager.default.temporaryDirectory
        
        let recordingFileURL = tempDir
            .appendingPathComponent(recordingName)
            .appendingPathExtension("m4a")
        
        recordingURL = recordingFileURL
                
        let settings = [
            AVFormatIDKey: codec.rawValue,
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
            logger.error("Start Recording - Could not start recording: \(error.localizedDescription)")
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
                logger.error("Stop Recording - Could not save to SwiftData: \(error.localizedDescription)")
            }
        } else {
            logger.error("Stop Recording - Could not find the recording URL")
        }
    }
    
    // MARK: - SwiftData Integration
    func saveNewRecording(_ modelContext: ModelContext, _ recordingData: Data) {
        let storage = ValueStorage()
        let codec = storage.selectedCodec
        let bitrate = storage.bitrate
        
        let newRecording = Recording(
            createdAt: currentDateTime,
            name: recordingName,
            recordingData: recordingData,
            bitrate: bitrate,
            codec: codec
        )
        
        modelContext.insert(newRecording)
        
        deleteRecordingFile()
    }
    
    private func deleteRecordingFile() {
        if let recordingURL {
            do {
                try FileManager.default.removeItem(at: recordingURL)
            } catch {
                logger.error("Stop Recording - Could not delete the recording file: \(error.localizedDescription)")
            }
        }
    }
}
