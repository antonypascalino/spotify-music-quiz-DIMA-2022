//
//  AddFriendsView.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 19/05/23.
//

import SwiftUI

struct AddFriendsView: View {
    
    @StateObject private var model = UserViewModel()
    @StateObject private var friendsModel = FriendsViewModel()
    private var currentUser = APICaller.shared.currentUser
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
                        .font(TextStyle.leaderboardItem().bold())
                        .foregroundColor(.white)
                        .padding(.leading)
                    Spacer()
                    Button {
                        print("Adding friend with SpotifyID: \(user.SpotifyID)")
                        Task {
                            try await friendsModel.addFriends(currentUserSpotifyID: currentUser!.id, newFriendSpotifyID: user.SpotifyID)
                            
                            try? await friendsModel.getFriends(currentUserSpotifyID: currentUser!.id)
                            
                            
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
            }
            .listStyle(.plain)
            .foregroundColor(.white)
            .padding(.leading)
        
            
            Spacer()
            
            //Search field to filter the users
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color("Black"))
                    .padding(.leading, 10)
                    .font(Font.title.weight(.semibold))
                TextField("",text:  $nameToSearch)
                .placeholder(when: nameToSearch.isEmpty) {
                    Text("Search name...")
                        .font(TextStyle.leaderboardItem().bold())
                        .foregroundColor(Color("Black"))
                }
                .font(TextStyle.leaderboardItem().bold())
                .foregroundColor(Color("Black"))
                .lineLimit(1)
                .padding(.vertical, 16.0)
                .padding(.leading, 15)
            }
            .background(Color("White"))
            .cornerRadius(10)
            .padding([.leading, .trailing], 30.0)
            .padding(.bottom)
            
        }
        .task {
            try? await model.getAllUsers()
        }
        .background(Color("Black"))
        .navigationTitle("Add friends")
    }
}

struct AddFriendsView_Previews: PreviewProvider {
    static var previews: some View {
        AddFriendsView()
    }
}