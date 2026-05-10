import Foundation
import OSLog

private let dataToFileLogger = Logger(
    subsystem: Bundle.main.bundleIdentifier ?? "dev.topscrech.Voice-Vault",
    category: "DataToFile"
)

func dataToFile(_ recordingData: Data?, codec: Codec?) -> URL? {
    dataToFileLogger.debug("\(#function)")
    
    guard let recordingData else {
        return nil
    }
    
    let tempDirectory = FileManager.default.temporaryDirectory
    let fileExtension = codec?.fileExtension ?? "m4a"
    let tempFileURL = tempDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension(fileExtension)
    
    do {
        try recordingData.write(to: tempFileURL)
        
        return tempFileURL
    } catch {
        dataToFileLogger.error("Failed to create temporary file: \(error.localizedDescription)")
        return nil
    }
}
