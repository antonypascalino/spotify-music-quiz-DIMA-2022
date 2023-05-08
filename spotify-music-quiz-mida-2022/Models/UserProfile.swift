import Foundation


struct UserProfile: Codable{
    let display_name: String
    let country: String
    let email: String
    let explicit_content: [String:Bool]
    let external_urls: [String: String]
    let id: String
    let product: String
    let images: [APIImage]?
}


struct User : Codable{
    let display_name:String
    let external_urls: [String: String]
    let id: String
}

