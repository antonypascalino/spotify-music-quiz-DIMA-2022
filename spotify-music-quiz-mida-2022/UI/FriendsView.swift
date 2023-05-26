//
//  FriendsView.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 08/05/23.
//
//
import SwiftUI



struct FriendsView: View {
    
    @StateObject private var friendsModel = FriendsViewModel()
    @StateObject private var model = UserViewModel()
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .frame(width: 260.0, height: 260.0)
                    .foregroundColor(Color(.blue))
                
                Image("Podio")
                    .resizable()
                    .frame(width: 260.0, height: 260.0)
                    .scaledToFit()
            }
            .padding()
            Text("Look at your friends' highscore. Who knows more about music?")
                .padding()
                .font(TextStyle.leaderboardItem().bold())
                .foregroundColor(.white)
            HStack(spacing: 20) {
                Text("Your highscore: \(model.highscore)")
                    .font(TextStyle.leaderboardItem().bold())
                    .foregroundColor(.white)
                    .padding(.leading, 6.0)
                    .task {
                        try? await model.getUserHighscore(SpotifyID: "11127717417")
                    }
                Spacer()
                NavigationLink (destination: AddFriendsView() ,label: {
                    Image(systemName: "person.crop.circle.badge.plus")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color.gray)
                        .frame(width: 40.0, height: 40.0)
                })
                
                NavigationLink (destination: GameView() ,label: {
                    Image(systemName: "play.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color("Green"))
                        .frame(width: 50.0, height: 50.0)
                        
                })
                .padding(.trailing, 5.0)
            }
            .padding()
            if (!friendsModel.friends.isEmpty){
                List(friendsModel.friends.indices) { index in
                    let friend = friendsModel.friends[index]
                    HStack {
                        Text("\(index + 1)")
                            .font(TextStyle.leaderboardItem().bold())
                            .foregroundColor(.white)
                            .frame(width: 20, height: 20)
                            .padding(.trailing)
                        ListImage(imageString: friend.image)
                        Text(friend.display_name)
                            .font(TextStyle.leaderboardItem().bold())
                            .foregroundColor(.white)
                            .padding(.leading)
                        Spacer()
                        Text(String(friend.highscore))
                            .font(TextStyle.leaderboardItem().bold())
                            .foregroundColor(.white)
                            .padding(.trailing)
                    }
                    .listRowBackground(Color.clear)
                }
                .listStyle(.plain)
                .background(Color.clear)
                
            } else {
                VStack {
                    Spacer()
                    Text("You have added no friends yet!")
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
                    Spacer()
                }
            }
            
            //            Text("This is ")
            //                .font(.system(size: 16)) // Set the desired font size for the normal text
            //                +
            //                Text("italic")
            //                .italic() // Apply the italic style to this part of the text
            //                .font(.system(size: 16)) // Set the desired font size for the italic text
            //                +
            //                Text(" text.")
            //                .font(.system(size: 16)) // Set the desired font size for the normal text
        }
        .background(LinearGradient(
            gradient: Gradient(colors: [Color("Green"),Color("Black"),Color("Black")]),
            startPoint: .top,
            endPoint: .bottom))
        .task {
            try? await friendsModel.getFriends(currentUserSpotifyID: "11127717417")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}
