import SwiftUI
import ScrechKit

struct SheetShare: View {
    private let url: URL
    
    init(_ url: URL) {
        self.url = url
    }
    
    var body: some View {
        ContentUnavailableView {
            Label("Your recording is ready for export", systemImage: "waveform.badge.microphone")
        } actions: {
            ShareLink(item: url) {
                Text("Share")
                    .title3(.semibold)
                    .padding()
                    .foregroundStyle(.white)
                    .background(.blue, in: .rect(cornerRadius: 16))
                    .padding()
            }
        }
    }
}

//#Preview {
//    SheetShare()
//}
