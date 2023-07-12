//
//  MockUserViewModel.swift
//  spotify-music-quiz-mida-2022UITests
//
//  Created by Antony Pascalino on 12/07/23.
//

import Foundation
@testable import spotify_music_quiz_mida_2022 // Import your app's module

class MockUserViewModel: UserViewModel {
    
    override func getAllUsers() async throws {
        self.users.append(User(id: "", authors: [:], highscores: (["classic":17, "guessTheSong":10]), display_name: "Matteo", email: "", friends: [], SpotifyID: "11111111", image: ""))
        self.users.append(User(id: "", authors: [:], highscores: (["classic":10, "guessTheSong":23]), display_name: "Marco", email: "", friends: [], SpotifyID: "11111111", image: ""))
        self.users.append(User(id: "", authors: [:], highscores: (["classic":24, "guessTheSong":5]), display_name: "Alessia", email: "", friends: [], SpotifyID: "11111111", image: ""))
        self.users.append(User(id: "", authors: [:], highscores: (["classic":5, "guessTheSong":34]), display_name: "Carlo", email: "", friends: [], SpotifyID: "11111111", image: ""))
        self.users.append(User(id: "", authors: [:], highscores: (["classic":15, "guessTheSong":2]), display_name: "Rebecca", email: "", friends: [], SpotifyID: "11111111", image: ""))
        self.users = users.sorted { $0.display_name.localizedCaseInsensitiveCompare($1.display_name) == .orderedAscending }
    }
    
    override func getFriends() async throws {
        self.friends.append(User(id: "", authors: [:], highscores: (["classic":17, "guessTheSong":10]), display_name: "Matteo", email: "", friends: [], SpotifyID: "11111111", image: ""))
        self.friends.append(User(id: "", authors: [:], highscores: (["classic":10, "guessTheSong":23]), display_name: "Marco", email: "", friends: [], SpotifyID: "11111111", image: ""))
        self.friends.append(User(id: "", authors: [:], highscores: (["classic":24, "guessTheSong":5]), display_name: "Alessia", email: "", friends: [], SpotifyID: "11111111", image: ""))
        self.friends.append(User(id: "", authors: [:], highscores: (["classic":5, "guessTheSong":34]), display_name: "Carlo", email: "", friends: [], SpotifyID: "11111111", image: ""))
        self.friends.append(User(id: "", authors: [:], highscores: (["classic":15, "guessTheSong":2]), display_name: "Rebecca", email: "", friends: [], SpotifyID: "11111111", image: ""))
    }
    
    override func addFriends(newFriendSpotifyID: String) async throws {
        
    }
    
    override func getUserHighscores() async throws {
        self.highscores = ["classic":5, "guessTheSong":34]
    }
    
    override func setUserHighscore(mode: String, newHighscore: Int) async throws {
        
    }
    
    override func updateUserData() {
        self.currentUser = User(id: "", authors: [:], highscores: (["classic":15, "guessTheSong":2]), display_name: "Antony", email: "", friends: [] , SpotifyID: "11111111", image: "https://scontent-ams2-1.xx.fbcdn.net/v/t1.6435-1/65027121_2736509836421775_2602413434465157120_n.jpg?stp=dst-jpg_p320x320&_nc_cat=110&ccb=1-7&_nc_sid=0c64ff&_nc_ohc=HqinrGseUcUAX9xlGJP&_nc_ht=scontent-ams2-1.xx&edm=AP4hL3IEAAAA&oh=00_AfAYT3hmu31wwESCY2ZX7bYxReQMPYbEabMafWzQqoM0Tg&oe=64D5554A")
    }
    
    override func getUserAuthorsScore() async throws {
        authorsScores = []
    }
    
    override func setUserAuthorsScore(author: String) async throws {
        
    }
    
}
