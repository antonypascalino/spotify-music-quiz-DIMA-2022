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
        self.friends = try await UserManager().getUserFriends(currentUserSpotifyID: currentUserSpotifyID )
    }
}
