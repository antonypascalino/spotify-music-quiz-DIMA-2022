//
//  GameOverView.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 21/05/23.
//

import SwiftUI


struct GameOverView: View {
    
    @EnvironmentObject var gameManager : GameManager
    
    var body: some View {
        VStack {
            Spacer()
            Text("Oh no!\n Your score is:\n \(gameManager.correctAnswersCount)")
                .font(TextStyle.score())
                .foregroundColor(Color("Green"))
                .padding(.leading)
            Spacer()
            HStack {
                NavigationLink {
                    HomeView()
                } label: {
                    Text("Go back to the homepage")
                }
                NavigationLink {
                    GameView()
                } label: {
                    Text("Play again!")
                }
            }
        }
        .navigationBarHidden(true)
        .background(Color("Black"))
    }
}

struct GameOverView_Previews: PreviewProvider {
    static var previews: some View {
        GameOverView()
            .environmentObject(GameManager())
    }
}
