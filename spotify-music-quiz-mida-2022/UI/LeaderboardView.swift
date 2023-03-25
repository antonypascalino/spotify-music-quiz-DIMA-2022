//
//  LeaderboardView.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 22/03/23.
//

import SwiftUI



var friend1 = Friend(name: "Michael", image: "Profilo1", highscore: 100)
var friend2 = Friend(name: "Pam", image: "Profilo1", highscore: 340)
var friend3 = Friend(name: "Jim", image: "Profilo1", highscore: 320)
var friend4 = Friend(name: "Oscar", image: "Profilo1", highscore: 306)
var friend5 = Friend(name: "Stanley", image: "Profilo1", highscore: 500)

var friends = [friend1, friend2, friend3, friend4, friend5, friend4, friend4, friend4, friend4, friend4, friend4]

struct LeaderboardView: View {
    
    
    var body: some View {
        NavigationView {
            if #available(iOS 16.0, *) {
                List(friends) { friend in
                    HStack {
                        Image(friend.image)
                            .resizable()
                            .frame(width: 40, height: 40)
                        Text(friend.name)
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
    }
}

struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView()
    }
}
