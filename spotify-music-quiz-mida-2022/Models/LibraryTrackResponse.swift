import Foundation

struct LibraryTrackResponse: Codable {
    var items: [Track]
}

struct LibrarySimpleTrackResponse: Codable {
    var items: [SimpleTrack]
}

struct LibrarySavedTrackResponse: Codable {
    var items: [SavedTrack]
}

struct SavedTrack: Codable{
    let added_at: String
    let track: Track
}
