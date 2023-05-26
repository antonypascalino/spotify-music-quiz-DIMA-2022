//
//  UserViewModel.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 09/05/23.
//

import Foundation

@MainActor
final class UserViewModel : ObservableObject {
    @Published private(set) var users : [User] = []
    @Published private(set) var searchedUsers : [User] = []
    @Published private(set) var highscore = 0
    
    func getAllUsers() async throws {
        let users = try await UserManager().getAllUsers()
        self.users = users.sorted { $0.display_name.localizedCaseInsensitiveCompare($1.display_name) == .orderedAscending }
    }
    
    func searchUsers(name: String) async throws {
        let users = try await UserManager().searchUsers(name: name)
        self.users = users.sorted { $0.display_name.localizedCaseInsensitiveCompare($1.display_name) == .orderedAscending }
    }
    
    func getUserHighscore(SpotifyID: String) async throws {
        self.highscore = try await UserManager().getUserHighscore(SpotifyID: SpotifyID)
    }
    
    func setUserHighscore(SpotifyID: String, newHighscore: Int) async throws {
        try await UserManager().setUserHighscore(SpotifyID: SpotifyID, newHighscore: newHighscore)
    }
}
