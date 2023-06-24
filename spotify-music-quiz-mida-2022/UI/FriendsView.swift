//
//  FriendsView.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 19/05/23.
//

import SwiftUI


//Show the list of your friends and allows to add new ones
struct FriendsView: View {
    
    @StateObject private var model = UserViewModel()
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            Text("Friends")
                .font(TextStyle.GothamBlack(30))
                .padding()
                .foregroundColor(.white)
            
            HStack {
                VStack{
                    Text("Here is the list of all your friends!")
                        .foregroundColor(.white)
                        .font(TextStyle.leaderboardItem().bold())
                    HStack {
                        Text("Click on")
                            .foregroundColor(.white)
                            .font(TextStyle.leaderboardItem().bold())
                        Image(systemName: "person.crop.circle.badge.plus")
                            .foregroundColor(.white)
                        Text("to add new friends!")
                            .foregroundColor(.white)
                            .font(TextStyle.leaderboardItem().bold())
                    }
                    .offset(x: -3)
                }
                Spacer()
                NavigationLink (destination: AddFriendsView() ,label: {
                    Image(systemName: "person.crop.circle.badge.plus")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color.gray)
                        .frame(width: 40.0, height: 40.0)
                })
            }
            .padding()
            if (!model.friends.isEmpty) {
                List(model.friends) { user in
                    HStack {
                        ListImage(imageString: user.image)
                        Text(user.display_name)
                            .font(TextStyle.leaderboardItem().bold())
                            .foregroundColor(.white)
                            .padding(.leading)
                        Spacer()
                        
                    }
                    .listRowBackground(Color.clear)
                }
                .listStyle(.plain)
                .foregroundColor(.white)
                .padding(.leading)
            } else {
                Spacer()
                HStack {
                    Spacer()
                    Text("You have added no friends yet!")
                        .foregroundColor(.white)
                        .font(TextStyle.leaderboardItem().bold())
                    Spacer()
                }
                Spacer()
            }
            Spacer()
        }
        .task {
            model.updateUserData()
            try? await model.getFriends()
            try? await model.getAllUsers()
        }
        .background(Color("Black"))
    }
    
    func alreadyed(user: User) -> Bool {
        let friends = model.friends
        return friends.contains{ $0.display_name == user.display_name }
    }
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}
