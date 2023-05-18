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
    
    func getAllUsers() async throws {
        self.users = try await UserManager().getAllUsers()
    }
}
