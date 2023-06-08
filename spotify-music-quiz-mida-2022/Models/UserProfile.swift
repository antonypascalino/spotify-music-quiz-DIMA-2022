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
        let user = User( highscores: [
            "classic": 0,
            "guessTheSong": 0,
            "guessTheSinger": 0,
            "recallTheYear": 0,
            "whichAlbum": 0,
            "whoIsTheAuthor": 0,
            "authorSong": 0,
        ],
                         display_name: display_name,
                         email: email,
                         friends: [DocumentReference](),
                         SpotifyID: id, image: images?.first?.url ?? "")
        
        print(user)
        return user
    }
}

struct Owner: Codable{
    let id: String
    
}
