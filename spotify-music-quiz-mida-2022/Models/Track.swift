import Foundation

struct Track: Codable {
    let name: String
    let id : String
    var album : Album?
    let artists : [Artists]
}