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
        NavigationView {
            if #available(iOS 16.0, *) {
                List(model.friends) { friend in
                    HStack {
                        Image(friend.image)
                            .resizable()
                            .frame(width: 40, height: 40)
                        Text(friend.display_name)
                            .font(TextStyle.leaderboardItem())
                            .foregroundColor(.white)
                            .padding(.leading)
                        Spacer()
                        Text(String(friend.highscore))
                            .font(TextStyle.leaderboardItem())
                            .foregroundColor(.white)
                    }
                    .listRowBackground(Color("Black"))
                    .padding(.bottom)
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        HStack {
                            Text("Leaderboard")
                                .font(TextStyle.homeTitle())
                                .foregroundColor(.white)
                                .padding(.leading, 22.0)
                            Spacer()
                        }
                    }
                }
                .foregroundColor(.white)
                .background(Color("Black"))
                .scrollContentBackground(.hidden)
                
            } else {
                // Fallback on earlier versions
            }
        }
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
