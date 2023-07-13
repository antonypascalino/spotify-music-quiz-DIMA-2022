//
//  AddFriendsView.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 19/05/23.
//

import SwiftUI

struct AddFriendsView: View {
    
    @ObservedObject private var model : UserViewModel
    @State private var nameToSearch = ""
    
    init(userManager: UserManager) {
        self.model = UserViewModel(userManager: userManager)
    }
    
    var orderedUsers : [User] {
        if nameToSearch.isEmpty {
            return model.users.filter { $0.display_name != model.currentUser.display_name}
        } else {
            let orderedUser = model.users.filter { user in
                let range = user.display_name.range(of: nameToSearch, options: .caseInsensitive)
                return range != nil
            }
            return orderedUser.filter { $0.display_name != model.currentUser.display_name}
        }
    }
    
    var body: some View {
        
        VStack {
            HStack {
                Text("Click on")
                    .foregroundColor(.white)
                    .font(TextStyle.leaderboardItem().bold())
                Image(systemName: "plus.circle")
                    .foregroundColor(.white)
                Text("to add a friend to your leaderboard!")
                    .foregroundColor(.white)
                    .font(TextStyle.leaderboardItem().bold())
            }
            .padding(.top)
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
                            try await model.addFriends(newFriendSpotifyID: user.SpotifyID)
                            model.updateUserData()
                            try? await model.getFriends()
                        }
                    } label: {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .scaledToFit()
                            .padding()
                            .foregroundColor(Color.white)
                            .frame(width: 60.0, height: 60.0)
                            .opacity(alreadyAdded(user: user) ? 0.5 : 1)
                    }
                    .disabled(alreadyAdded(user: user))
                    
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
            model.updateUserData()
            try? await model.getFriends()
            try? await model.getAllUsers()
        }
        .background(Color("Black"))
        .navigationTitle(Text(""))
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Add friend")
                    .font(TextStyle.homeTitle())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .scaledToFit()
                    .minimumScaleFactor(0.1)
            }
        }
    }
    
    func alreadyAdded(user: User) -> Bool {
        let friends = model.friends
        return friends.contains{ $0.display_name == user.display_name }
    }
}

//struct AddFriendsView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddFriendsView()
//    }
//}
