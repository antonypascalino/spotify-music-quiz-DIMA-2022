//
//  AddFriendView.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 19/05/23.
//

import SwiftUI

struct AddFriendView: View {
    
    @StateObject private var model = UserViewModel()
    @StateObject private var friendsModel = FriendsViewModel()
    @State private var nameToSearch = ""
    
    var orderedUsers : [User] {
        if nameToSearch.isEmpty {
            return model.users
        } else {
            return model.users.filter { user in
                let range = user.display_name.range(of: nameToSearch, options: .caseInsensitive)
                return range != nil
            }
        }
    }
    
    var body: some View {
        
        VStack {
            List(orderedUsers) { user in
                HStack {
                    ListImage(imageString: user.image)
                    Text(user.display_name)
                        .font(TextStyle.leaderboardItem())
                        .foregroundColor(.white)
                        .padding(.leading)
                    Spacer()
                    Button {
                        print("Adding friend with SpotifyID: \(user.SpotifyID)")
                        Task {
                            try await friendsModel.addFriends(currentUserSpotifyID: "11127717417", newFriendSpotifyID: user.SpotifyID)
                            
                            try? await friendsModel.getFriends(currentUserSpotifyID: "11127717417")
                            
                            
                        }
                    } label: {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .scaledToFit()
                            .padding()
                            .foregroundColor(Color.white)
                            .frame(width: 60.0, height: 60.0)
                    }
                }
                .listRowBackground(Color.clear)
                .padding(.bottom)
            }
            .listStyle(.plain)
            .foregroundColor(.white)
        
            
            Spacer()
            
            //Search field to filter the users
            TextField(
                "Search by name...",
                text:  $nameToSearch
            )
            .padding()
        }
        .task {
            try? await model.getAllUsers()
        }
        .background(Color("Black"))
    }
    
    func filterUsers(searchWord: String) {
        
    }
}

struct AddFriendView_Previews: PreviewProvider {
    static var previews: some View {
        AddFriendView()
    }
}
