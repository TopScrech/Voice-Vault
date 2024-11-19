import AVFoundation

enum Codec: Int {
    case appleLossless,
         ima4,
         aac,
         flac,
         mp3,
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
    
    static var allCases: [Codec] = [
        .appleLossless,
        .ima4,
        .aac,
        .flac,
        .mp3,
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
        case .mp3: Int(kAudioFormatMPEGLayer3)
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
        case .mp3: "MPEG Layer 3"
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
