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
            .task {
                model.updateUserData()
                try? await model.getUserAuthorsScore()
            }
            Spacer()
        }
        .background(Color("Black"))
    }
}

struct AuthorScoreView_Previews: PreviewProvider {
    static var previews: some View {
        AuthorScoreView()
    }
}
