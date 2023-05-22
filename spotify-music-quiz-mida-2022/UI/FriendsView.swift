//
//  FriendsView.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 08/05/23.
//
//
import SwiftUI



struct FriendsView: View {

    @StateObject private var model = FriendsViewModel()

    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .frame(width: 200.0, height: 200.0)
                    .foregroundColor(Color(.blue))
                
                Image("Podio")
                    .resizable()
                    .frame(width: 200.0, height: 200.0)
                    .scaledToFit()
            }
            Text("Look at your friends' highscore. Who knows more about music?")
            HStack {
                Spacer()
                NavigationLink (destination: AddFriendView() ,label: {
                    Image(systemName: "person.crop.circle.badge.plus")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color.gray)
                        .padding()
                        .frame(width: 80.0, height: 80.0)
                })
            }
            if (!model.friends.isEmpty){
                List(model.friends) { friend in
                    HStack {
                        ListImage(imageString: friend.image)
                        Text(friend.display_name)
                            .font(TextStyle.leaderboardItem())
                            .foregroundColor(.black)
                            .padding(.leading)
                        Spacer()
                        Text(String(friend.highscore))
                            .font(TextStyle.leaderboardItem())
                            .foregroundColor(.black)
                    }
                    .listRowBackground(Color.clear)
                }
                .listStyle(.plain)
                .background(Color.clear)
                
            } else {
                HStack {
                    Text("You have added no friends yet. Click on ")
                    Image(systemName: "person.crop.circle.badge.plus")
                    Text("to add new friends!")
                }
            }
        }
        .background(
            LinearGradient(gradient:
            Gradient(colors: [Color("Green"),Color("Black")]),
                           startPoint: UnitPoint(x: 0, y: 0),
                           endPoint: UnitPoint(x: 1, y: 1))
        )
        .task {
            try? await model.getFriends(currentUserSpotifyID: "11127717417")
        }
    }
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}
