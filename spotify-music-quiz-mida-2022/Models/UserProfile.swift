import Foundation
import FirebaseFirestore


struct UserProfile: Codable {
    let display_name: String
    let country: String
    let email: String
    let explicit_content: [String:Bool]
    let external_urls: [String: String]
    let id: String
    let product: String
    let images: [APIImage]?
    
    func mapWithUser() -> User {
        
        print(UserProfile.self)
        let user = User(display_name: display_name, email: email, friends: [DocumentReference](), highscore: 0, SpotifyID: id, image: images?.first?.url ?? "")
        print(user)
        return user
    }
}

