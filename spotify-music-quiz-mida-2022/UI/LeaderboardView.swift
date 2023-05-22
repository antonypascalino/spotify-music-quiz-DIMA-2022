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
        
        VStack {
            List(model.users) { user in
                HStack {
                    ListImage(imageString: user.image)
                    Text(user.display_name)
                        .font(TextStyle.leaderboardItem())
                        .foregroundColor(.white)
                        .padding(.leading)
                    Spacer()
                    Text(String(user.highscore))
                        .font(TextStyle.leaderboardItem())
                        .foregroundColor(.white)
                }
                .listRowBackground(Color.clear)
                .padding(.bottom)
            }
            .listStyle(.plain)
            //                .toolbar {
            //                    ToolbarItem(placement: .principal) {
            //                        HStack {
            //                            Text("Leaderboard")
            //                                .font(TextStyle.homeTitle())
            //                                .foregroundColor(.white)
            //                                .padding(.leading, 22.0)
            //                            Spacer()
            //                        }
            //                    }
            //                }
            .foregroundColor(.white)
            
        }
        .task {
            try? await model.getAllUsers()
        }
        .background(Color("Black"))
    }
        

}

struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView()
    }
}
