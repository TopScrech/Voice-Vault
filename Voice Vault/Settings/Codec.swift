import AVFoundation

enum Codec: Int, Codable {
    case appleLossless,
         ima4,
         aac,
         flac,
         ac3,
         enhancedAC3,
         opus,
         alaw,
         ulaw,
         linearPCM,
         amr,
         amrWB,
         mpegLayer1,
         mpegLayer2,
         mpegLayer3,
         midiStream,
         qDesign,
         qDesign2,
         ilbc,
         gsm,
         audible,
         celp,
         hvxc,
         twinVQ
    
    var id: Int { rawValue }

    init?(rawValue: Int) {
        switch rawValue {
        case Int(kAudioFormatAppleLossless), 0: self = .appleLossless
        case Int(kAudioFormatAppleIMA4), 1: self = .ima4
        case Int(kAudioFormatMPEG4AAC), 2: self = .aac
        case Int(kAudioFormatFLAC), 3: self = .flac
        case Int(kAudioFormatAC3), 4: self = .ac3
        case Int(kAudioFormatEnhancedAC3), 5: self = .enhancedAC3
        case Int(kAudioFormatOpus), 6: self = .opus
        case Int(kAudioFormatALaw), 7: self = .alaw
        case Int(kAudioFormatULaw), 8: self = .ulaw
        case Int(kAudioFormatLinearPCM), 9: self = .linearPCM
        case Int(kAudioFormatAMR), 10: self = .amr
        case Int(kAudioFormatAMR_WB), 11: self = .amrWB
        case Int(kAudioFormatMPEGLayer1), 12: self = .mpegLayer1
        case Int(kAudioFormatMPEGLayer2), 13: self = .mpegLayer2
        case Int(kAudioFormatMPEGLayer3), 14: self = .mpegLayer3
        case Int(kAudioFormatMIDIStream), 15: self = .midiStream
        case Int(kAudioFormatQDesign), 16: self = .qDesign
        case Int(kAudioFormatQDesign2), 17: self = .qDesign2
        case Int(kAudioFormatiLBC), 18: self = .ilbc
        case Int(kAudioFormatMicrosoftGSM), 19: self = .gsm
        case Int(kAudioFormatAudible), 20: self = .audible
        case Int(kAudioFormatMPEG4CELP), 21: self = .celp
        case Int(kAudioFormatMPEG4HVXC), 22: self = .hvxc
        case Int(kAudioFormatMPEG4TwinVQ), 23: self = .twinVQ
        default: return nil
        }
    }

    static var allCases: [Codec] = [
        .appleLossless,
        .ima4,
        .aac,
        .flac,
        .ac3,
        .enhancedAC3,
        .opus,
        .alaw,
        .ulaw,
        .linearPCM,
        .amr,
        .amrWB,
        .mpegLayer1,
        .mpegLayer2,
        .mpegLayer3,
        .midiStream,
        .qDesign,
        .qDesign2,
        .ilbc,
        .gsm,
        .audible,
        .celp,
        .hvxc,
        .twinVQ
    ]
    
    var rawValue: Int {
        switch self {
        case .appleLossless: Int(kAudioFormatAppleLossless)
        case .ima4: Int(kAudioFormatAppleIMA4)
        case .aac: Int(kAudioFormatMPEG4AAC)
        case .flac: Int(kAudioFormatFLAC)
        case .ac3: Int(kAudioFormatAC3)
        case .enhancedAC3: Int(kAudioFormatEnhancedAC3)
        case .opus: Int(kAudioFormatOpus)
        case .alaw: Int(kAudioFormatALaw)
        case .ulaw: Int(kAudioFormatULaw)
        case .linearPCM: Int(kAudioFormatLinearPCM)
        case .amr: Int(kAudioFormatAMR)
        case .amrWB: Int(kAudioFormatAMR_WB)
        case .mpegLayer1: Int(kAudioFormatMPEGLayer1)
        case .mpegLayer2: Int(kAudioFormatMPEGLayer2)
        case .mpegLayer3: Int(kAudioFormatMPEGLayer3)
        case .midiStream: Int(kAudioFormatMIDIStream)
        case .qDesign: Int(kAudioFormatQDesign)
        case .qDesign2: Int(kAudioFormatQDesign2)
        case .ilbc: Int(kAudioFormatiLBC)
        case .gsm: Int(kAudioFormatMicrosoftGSM)
        case .audible: Int(kAudioFormatAudible)
        case .celp: Int(kAudioFormatMPEG4CELP)
        case .hvxc: Int(kAudioFormatMPEG4HVXC)
        case .twinVQ: Int(kAudioFormatMPEG4TwinVQ)
        }
    }
    
    var name: String {
        switch self {
        case .appleLossless: "Apple Lossless"
        case .ima4: "Apple IMA4"
        case .aac: "MPEG4 AAC"
        case .flac: "FLAC"
        case .ac3: "AC3"
        case .enhancedAC3: "Enhanced AC3"
        case .opus: "Opus"
        case .alaw: "ALaw"
        case .ulaw: "ULaw"
        case .linearPCM: "Linear PCM"
        case .amr: "AMR"
        case .amrWB: "AMR_WB"
        case .mpegLayer1: "MPEG Layer 1"
        case .mpegLayer2: "MPEG Layer 2"
        case .mpegLayer3: "MPEG Layer 3"
        case .midiStream: "MIDI Stream"
        case .qDesign: "QDesign"
        case .qDesign2: "QDesign2"
        case .ilbc: "iLBC"
        case .gsm: "Microsoft GSM"
        case .audible: "Audible"
        case .celp: "MPEG4 CELP"
        case .hvxc: "MPEG4 HVXC"
        case .twinVQ: "MPEG4 TwinVQ"
        }
    }
}
