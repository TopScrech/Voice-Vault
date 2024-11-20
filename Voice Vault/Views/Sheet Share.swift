import SwiftUI
import ScrechKit

struct SheetShare: View {
    private let data: Data?
    
    init(_ data: Data?) {
        self.data = data
    }
    
    @State private var url: URL? = nil
    
    var body: some View {
        VStack {
            if let url {
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
            } else {
                ProgressView()
            }
        }
        .task {
            withAnimation {
                url = dataToFile(data)
            }
        }
    }    
}

//#Preview {
//    SheetShare()
//}
