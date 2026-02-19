import SwiftUI

final class ValueStorage: ObservableObject {
    @AppStorage("selected_codec") var selectedCodec: Codec = .appleLossless
    @AppStorage("bitrate") var bitrate = 48_000
}
