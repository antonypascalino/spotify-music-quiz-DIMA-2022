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
    
    func getAllUsers() async throws {
        let users = try await UserManager().getAllUsers()
        self.users = users.sorted { $0.display_name.localizedCaseInsensitiveCompare($1.display_name) == .orderedAscending }
    }
    
    func searchUsers(name: String) async throws {
        let users = try await UserManager().searchUsers(name: name)
        self.users = users.sorted { $0.display_name.localizedCaseInsensitiveCompare($1.display_name) == .orderedAscending }
        print(users)
    }
}
