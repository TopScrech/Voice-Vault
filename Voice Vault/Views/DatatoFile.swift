import Foundation
import OSLog

private let dataToFileLogger = Logger(
    subsystem: Bundle.main.bundleIdentifier ?? "dev.topscrech.Voice-Vault",
    category: "DataToFile"
)

func dataToFile(_ recordingData: Data?) -> URL? {
    dataToFileLogger.debug("\(#function)")
    
    guard let recordingData else {
        return nil
    }
    
    let tempDirectory = FileManager.default.temporaryDirectory
    let tempFileURL = tempDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("m4a")
    
    do {
        try recordingData.write(to: tempFileURL)
        
        return tempFileURL
    } catch {
        dataToFileLogger.error("Failed to create temporary file: \(error.localizedDescription)")
        return nil
    }
}
