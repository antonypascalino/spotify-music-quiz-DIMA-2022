//
//  AuthorScoreView.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 22/03/23.
//

import SwiftUI

struct AuthorScoreView: View {
    
    @StateObject private var model = UserViewModel()
    
    var body: some View {
        
        VStack {
            List {
                ForEach(model.authorsScores.sorted(by: <), id: \.value) { author, score in
                    HStack {
                        Text(author)
                            .font(TextStyle.leaderboardItem())
                            .foregroundColor(.white)
                            .padding(.leading)
                        Spacer()
                        Text(String(score))
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
                model.updateUserData()
                try? await model.getUserAuthorsScore()
            }
            .background(Color("Black"))
        }
        
    }
}

struct AuthorScoreView_Previews: PreviewProvider {
    static var previews: some View {
        AuthorScoreView()
    }
}
