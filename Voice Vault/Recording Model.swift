import Foundation
import SwiftData

@Model
final class Recording {
    var createdAt: Date
    var id: UUID
    var name: String
    var recordingData: Data
    
    init(createdAt: Date = Date(), id: UUID = UUID(), name: String, recordingData: Data) {
        self.createdAt = createdAt
        self.id = id
        self.name = name
        self.recordingData = recordingData
    }
}
