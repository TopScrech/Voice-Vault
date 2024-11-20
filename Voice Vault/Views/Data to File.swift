import Foundation

func dataToFile(_ recordingData: Data?) -> URL? {
    print("Goida")
    
    guard let recordingData else {
        return nil
    }
    
    let tempDirectory = FileManager.default.temporaryDirectory
    let tempFileURL = tempDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("m4a")
    
    do {
        try recordingData.write(to: tempFileURL)
        
        return tempFileURL
    } catch {
        print("Failed to create temporary file: \(error.localizedDescription)")
        return nil
    }
}
