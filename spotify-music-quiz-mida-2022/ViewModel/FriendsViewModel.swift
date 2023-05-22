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
    
    func getFriends(currentUserSpotifyID : String) async throws {
        let friends = try await UserManager().getUserFriends(currentUserSpotifyID: currentUserSpotifyID)
        self.friends = friends.sorted { $0.highscore > $1.highscore }
    }
    
    func addFriends(currentUserSpotifyID: String, newFriendSpotifyID: String) async throws {
        try await UserManager().addFriend(currentUserSpotifyID: currentUserSpotifyID, newFriendSpotifyID: newFriendSpotifyID)
    }
}
