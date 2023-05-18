//
//  LeaderboardView.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 22/03/23.
//

import SwiftUI

struct LeaderboardView: View {
    
    @StateObject private var model = UserViewModel()

    var body: some View {
        NavigationView {
            if #available(iOS 16.0, *) {
                List(model.users) { user in
                    HStack {
                        if (user.image != "") {
                            AsyncImage(url: URL(string: user.image)) { image in
                                image
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .scaledToFit()
                            } placeholder: {
                                ProgressView()
                            }
                        }
                        else {
                            Image(systemName: "person.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
//
                        
                        Text(user.display_name)
                            .font(TextStyle.leaderboardItem())
                            .foregroundColor(.white)
                            .padding(.leading)
                        Spacer()
                        Text(String(user.highscore))
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
            try? await model.getAllUsers()
        }
    }
        

}

struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView()
    }
}
