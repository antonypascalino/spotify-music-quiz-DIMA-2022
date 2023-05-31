import Foundation

struct Track: Codable {
    let name: String
    let id : String
    let preview_url : String?
    var album : Album?
    let artists : [Artist]
}

struct SimpleTrack: Codable {
    let name: String
    let id : String
    let preview_url : String?
    //let artists : [Artist]
}


