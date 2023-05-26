//
//  GameOverView.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 21/05/23.
//

import SwiftUI


struct GameOverView: View {
    
    @StateObject private var model = UserViewModel()
    @EnvironmentObject var gameManager : GameManager
    @State var gameRestarted = false
    
    var body: some View {
        
        let score = gameManager.correctAnswersCount
        @State var isHighscore = score > model.highscore
        
        VStack {
            Spacer()
            Text("Oh no!")
                .font(TextStyle.score(80))
                .foregroundColor(Color("Green"))
                .padding()
            
            Text("Your score is:")
                .font(TextStyle.score(40))
                .foregroundColor(Color("Green"))
                .padding()
            
            Text(String(gameManager.correctAnswersCount))
            //            Text("50")
                .font(TextStyle.score(100))
                .foregroundColor(Color("Green"))
                .padding()
            
            if(isHighscore) {
                Text("It's your new highscore!")
                    .font(TextStyle.score(40))
                    .foregroundColor(Color("Green"))
                    .padding([.leading,.trailing])
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
            
            HStack(spacing: 30.0) {
                
                NavigationLink(destination: GameView().environmentObject(gameManager), isActive: $gameRestarted, label: {
                    Image(systemName: "play.circle.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(.leading)
                    
                    Text("Play again")
                        .font(TextStyle.LoginInputTitle())
                        .minimumScaleFactor(0.1)
                        .padding(.trailing)
                        .lineLimit(1)
                })
                .frame(width: 160.0, height: 60.0)
                .background(Color("Green"))
                .foregroundColor(Color("Black"))
                .cornerRadius(100.0)
                .simultaneousGesture(TapGesture().onEnded {
                    gameManager.restartGame()
                    print("GAME RESTARTED")
                    gameRestarted = true
                })
                
                NavigationLink {
                    HomeView()
                } label: {
                    Image(systemName: "house.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(.leading)
                    Text("Homepage")
                        .font(TextStyle.LoginInputTitle())
                        .minimumScaleFactor(0.1)
                        .padding(.trailing)
                        .lineLimit(1)
                }
                .frame(width: 160, height: 60.0)
                .background(Color("Green"))
                .foregroundColor(Color("Black"))
                .cornerRadius(100.0)
                
            }
            .padding([.leading , .trailing])
            Spacer()
        }
        .onAppear() {
            Task {
                try? await model.getUserHighscore(SpotifyID: "11127717417")
                if score > model.highscore {
                    try await model.setUserHighscore(SpotifyID: "11127717417", newHighscore: score)
                }
            }
        }
        .navigationBarHidden(true)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("Black"))
    }
}

struct GameOverView_Previews: PreviewProvider {
    static var previews: some View {
        GameOverView()
//            .environmentObject(GameManager())
    }
}
