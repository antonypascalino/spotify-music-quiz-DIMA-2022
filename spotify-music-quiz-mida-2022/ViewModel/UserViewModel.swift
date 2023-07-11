//
//  UserViewModel.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 09/05/23.
//

import Foundation
import FirebaseFirestore

@MainActor
final class UserViewModel : ObservableObject {
    @Published private(set) var isLoading = true
    @Published private(set) var users : [User] = []
    @Published private(set) var friends : [User] = []
    @Published private(set) var searchedUsers : [User] = []
    @Published private(set) var highscores = [String : Int]()
    @Published private(set) var highscoresOrdered : Array<(key: String, value: Int)> = []
    @Published private(set) var authorsScores : Array<(key: String, value: Int)> = []
    @Published private(set) var authorsId : Array<(key: String, value: String)> = []
    @Published var currentUser = User(id: "", display_name: "", email: "", friends: [DocumentReference](), SpotifyID: "", image: "")
    
    func getAllUsers() async throws {
        let users = try await UserManager.shared.getAllUsers()
        self.users = users.sorted { $0.display_name.localizedCaseInsensitiveCompare($1.display_name) == .orderedAscending }
    }
    
    func getFriends() async throws {
        self.friends = try await UserManager.shared.getUserFriends()
    }
    
    func addFriends(newFriendSpotifyID: String) async throws {
        try await UserManager.shared.addFriend(newFriendSpotifyID: newFriendSpotifyID)
    }
    
    func getUserHighscores() async throws {
        self.highscores = try await UserManager.shared.getUserHighscores()
        highscoresOrdered = self.highscores.sorted { $0.value > $1.value }
        self.isLoading = false
        highscoresOrdered = highscoresOrdered.map { (key, value) -> (String, Int) in
            let separatedKey = separateCamelCase(key)
            return (separatedKey, value)
        }
    }
    
    func setUserHighscore(mode: String, newHighscore: Int) async throws {
        try await UserManager.shared.setUserHighscore(mode: mode, newHighscore: newHighscore)
    }
    
    func updateUserData() {
        DispatchQueue.main.async {
            self.currentUser = UserManager.shared.currentUser
        }
    }
    
    func getUserAuthorsScore() async throws {
        let dictionary = try await UserManager.shared.getUserAuthorsScore()
        authorsScores = dictionary.sorted { $0.value > $1.value }
        print(authorsScores)
    }
    
    func separateCamelCase(_ input: String) -> String {
        var separatedString = ""
        
        for (index, character) in input.enumerated() {
            // Check if the current character is uppercase
            let isUppercase = character.isUppercase
            
            // Add a space before the current character if it's uppercase
            if index > 0 && isUppercase {
                separatedString.append(" ")
            }
            
            // Add the current character to the resulting string
            separatedString.append(character)
        }
        separatedString = separatedString.lowercased()
        
        // Capitalize only the first character of the resulting string
        let firstCharacter = separatedString.prefix(1).uppercased()
        let remainingString = String(separatedString.dropFirst())
        
        return firstCharacter + remainingString
    }

    
    
//    func getTopAuthors() async throws -> [String] {
//        let dictionary = try await UserManager.shared.getUserAuthorsScore()
//        authorsScores = dictionary.sorted { $0.value > $1.value }
//
//        let topArtistsNames = authorsScores.prefix(10).map { $0.key }
//        let topArtistsIds = try await UserManager.shared.getAuthorsId(artists: topArtistsNames)
//        print("Names: \(topArtistsNames), IDs: \(topArtistsIds)")
//        return topArtistsIds
//    }
    
    

    func setUserAuthorsScore(author: String) async throws {
        try await UserManager.shared.setUserAuthorScore(author: author)
    }
    
//    func addAuthor(artist: Artist) async throws {
//        try await UserManager.shared.addAuthor(artist: artist)
//    }
}
