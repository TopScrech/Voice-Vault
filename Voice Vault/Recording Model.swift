import Foundation
import SwiftData

@Model
final class Recording {
    @Attribute(.unique)
    var id: UUID = UUID()
    
    var name: String
    var createdAt: Date
    var bitrate: Int?
    var codec: String?
    
    @Attribute(.allowsCloudEncryption)
    var recordingData: Data
    
    init(
        createdAt: Date = Date(),
        name: String,
        recordingData: Data,
        bitrate: Int,
        codec: String
    ) {
        self.createdAt = createdAt
        self.name = name
        self.recordingData = recordingData
        self.bitrate = bitrate
        self.codec = codec
    }
}
