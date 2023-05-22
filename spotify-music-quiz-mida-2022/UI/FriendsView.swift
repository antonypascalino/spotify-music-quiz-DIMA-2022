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
    
    let highscore = 30
    
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
                Text("Your highscore: \(highscore)")
                    .font(TextStyle.leaderboardItem().bold())
                    .foregroundColor(.white)
                    .padding(.leading, 6.0)
                Spacer()
                NavigationLink (destination: AddFriendView() ,label: {
                    Image(systemName: "person.crop.circle.badge.plus")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color.gray)
                        .frame(width: 40.0, height: 40.0)
                })
                
                NavigationLink (destination: GameView() ,label: {
                    Image("GreenPlay")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color.gray)
                        .frame(width: 50.0, height: 50.0)
                        
                })
                .padding(.trailing, 5.0)
            }
            .padding()
            if (!model.friends.isEmpty){
                List(model.friends.indices) { index in
                    let friend = model.friends[index]
                    HStack {
                        Text("\(index + 1)")
                            .font(TextStyle.leaderboardItem().bold())
                            .foregroundColor(.white)
                            .frame(width: 20, height: 20)
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
                HStack {
                    Text("You have added no friends yet. Click on ")
                    Image(systemName: "person.crop.circle.badge.plus")
                    Text("to add new friends!")
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
            try? await model.getFriends(currentUserSpotifyID: "11127717417")
        }
        .navigationBarBackButtonHidden(true)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}
