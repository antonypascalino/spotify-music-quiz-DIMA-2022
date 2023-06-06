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
    @Published private(set) var users : [User] = []
    @Published var currentUser = User(id: "", display_name: "", email: "", friends: [DocumentReference](), highscore: 0, SpotifyID: "", image: "")

    @Published private(set) var searchedUsers : [User] = []
    @Published private(set) var highscore = 0
    @Published private(set) var authorsScores : Array<(key: String, value: Int)> = []
    @Published private(set) var authorsId : Array<(key: String, value: String)> = []
    
    
    init() {
    }
    
    func getAllUsers() async throws {
        let users = try await UserManager.shared.getAllUsers()
        self.users = users.sorted { $0.display_name.localizedCaseInsensitiveCompare($1.display_name) == .orderedAscending }
    }
    
//    func searchUsers(name: String) async throws {
//        let users = try await UserManager.shared.searchUsers(name: name)
//        self.users = users.sorted { $0.display_name.localizedCaseInsensitiveCompare($1.display_name) == .orderedAscending }
//    }
    
    func getUserHighscore() async throws {
        self.highscore = try await UserManager.shared.getUserHighscore()
    }
    
    func setUserHighscore(newHighscore: Int) async throws {
        try await UserManager.shared.setUserHighscore(newHighscore: newHighscore)
    }
    
    func updateUserData() {
//        print("Stampo Prima")
        DispatchQueue.main.async {
            self.currentUser = UserManager.shared.currentUser
        }
    }
    
    func getUserAuthorsScore() async throws {
        let dictionary = try await UserManager.shared.getUserAuthorsScore()
        authorsScores = dictionary.sorted { $0.value > $1.value }
//        authorsScores = Dictionary(uniqueKeysWithValues: sortedArray)
        for (author, score) in authorsScores {
            print("\(author) : \(score)")
        }
//        print("TOP 5 AUTHORS: \(try await getTopAuthors())")
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
