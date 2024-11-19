import Foundation
import SwiftData

@Model
final class Recording {
    @Attribute(.unique)
    var id: UUID = UUID()
    
    var name: String
    var createdAt: Date
    
    @Attribute(.allowsCloudEncryption)
    var recordingData: Data
    
    init(
        createdAt: Date = Date(),
        name: String,
        recordingData: Data
    ) {
        self.createdAt = createdAt
        self.name = name
        self.recordingData = recordingData
    }
}
