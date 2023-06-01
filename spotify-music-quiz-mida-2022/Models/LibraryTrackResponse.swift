import Foundation

struct LibraryTrackResponse: Codable {
    var items: [Track]
}

struct LibrarySimpleTrackResponse: Codable {
    var items: [SimpleTrack]
}

