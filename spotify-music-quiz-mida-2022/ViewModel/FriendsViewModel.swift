//
//  FriendsViewModel.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 09/05/23.
//

import Foundation
import Firebase

@MainActor
final class FriendsViewModel : ObservableObject {
    @Published private(set) var friends : [User] = []
    
    func getFriends() async throws {
        let friends = try await UserManager.shared.getUserFriends()
        self.friends = friends.sorted { $0.highscore > $1.highscore }
    }
    
    func addFriends(newFriendSpotifyID: String) async throws {
        try await UserManager.shared.addFriend(newFriendSpotifyID: newFriendSpotifyID)
    }
}
