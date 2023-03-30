import Foundation

struct LibraryAlbumResponse: Codable {
    let items: [SavedAlbum]
}
struct SavedAlbum: Codable{
    let added_at: String
    let album: Album
}