import Foundation

struct Album: Codable {
    let album_type: String
    //let available_markets: [String]
    let id: String
    var images: [APIImage]
    let name: String
    let release_date: String
    let total_tracks: Int
    let artists: [Artist]
    

}

struct SimpleAlbum: Codable {
    let album_type: String
    //let available_markets: [String]
    let id: String
    var images: [APIImage]
    let name: String
    let release_date: String
    let total_tracks: Int
    let artists: [Artist]
    var tracks: LibrarySimpleTrackResponse
}
