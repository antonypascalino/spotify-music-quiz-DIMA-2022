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
        
        VStack(alignment: .leading) {
            
            Text("Authors score")
                .font(TextStyle.GothamBlack(30))
                .padding()
                .foregroundColor(.white)
            
            Text("Look at the authors you know better!\nFor each correct answer you get a point!")
                .padding()
                .font(TextStyle.leaderboardItem().bold())
                .foregroundColor(.white)
            
            if (!model.authorsScores.isEmpty) {
                List(model.authorsScores, id: \.key) { author, score in
                    HStack {
                        Text(author)
                            .font(TextStyle.leaderboardItem().bold())
                            .foregroundColor(.white)
                        Spacer()
                        Text(String(score))
                            .font(TextStyle.leaderboardItem().bold())
                            .foregroundColor(.white)
                    }
                    .listRowBackground(Color.clear)
                }
                .listStyle(.plain)
                .foregroundColor(.white)
            } else {
                VStack(alignment: .center, spacing: 20) {
                    Spacer()
                    Text("Sorry, you have not guessed any question yet")
                        .foregroundColor(.white)
                        .font(TextStyle.leaderboardItem().bold())
                    Text("Play some games to score more points!")
                        .foregroundColor(.white)
                        .font(TextStyle.leaderboardItem().bold())
                    Spacer()
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("Black"))
        .task {
            model.updateUserData()
            try? await model.getUserAuthorsScore()
        }
    }
}

struct AuthorScoreView_Previews: PreviewProvider {
    static var previews: some View {
        AuthorScoreView()
    }
}
