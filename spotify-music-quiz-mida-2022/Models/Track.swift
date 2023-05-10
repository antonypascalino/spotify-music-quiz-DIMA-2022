import Foundation

struct Track: Codable {
    let name: String
    let id : String
    //let release_date : String
    var album : Album?
    let artists : [Artist]
}
