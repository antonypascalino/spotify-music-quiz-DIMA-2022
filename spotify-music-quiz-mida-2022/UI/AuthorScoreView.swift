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
            Text("Look at the authors you know better!\nFor each correct answer you get a point!")
                .padding(.top, 25)
                .font(TextStyle.leaderboardItem().bold())
                .foregroundColor(.white)
                .offset(x: -7)
            
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
                .listStyle(.plain)
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
