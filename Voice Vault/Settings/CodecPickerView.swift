import SwiftUI

struct CodecPickerView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var selectedCodec: Codec
    
    var body: some View {
        List {
            ForEach(Codec.recordingCases, id: \.rawValue) { codec in
                Button {
                    selectedCodec = codec
                    dismiss()
                } label: {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(codec.name)
                            
                            if let tag = tag(for: codec) {
                                Text(tag)
                                    .secondary()
                                    .footnote()
                            }
                        }
                        
                        Spacer()
                        
                        if codec == selectedCodec {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.tint)
                        }
                    }
                }
                .foregroundStyle(.foreground)
            }
        }
        .navigationTitle("Codec")
    }
    
    private func tag(for codec: Codec) -> String? {
        switch codec {
        case .appleLossless:
            "Recommended"
        case .aac:
            "Most compatible"
        default:
            nil
        }
    }
}

#Preview {
    NavigationStack {
        CodecPickerView(selectedCodec: .constant(.appleLossless))
    }
}
