//
//  GameOverView.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 21/05/23.
//

import SwiftUI


struct GameOverView: View {
    
    let mode : Mode
    let userManager : UserManager
    
    @ObservedObject private var model : UserViewModel
    @EnvironmentObject var gameManager : GameManager
    @EnvironmentObject var questionManager : QuestionManager
    @State var gameRestarted = false
    
    init(userManager: UserManager, mode: Mode) {
        self.mode = mode
        self.userManager = userManager
        self.model = UserViewModel(userManager: userManager)
    }
    
    var body: some View {
        
       
        
        VStack {
            if(!model.isLoading) {
                let score = gameManager.correctAnswersCount
                let isHighscore = score > model.highscores[mode.label] ?? 0
                
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
                    
                    NavigationLink(destination: GameView(mode: mode, userManager: userManager).environmentObject(gameManager).environmentObject(questionManager), isActive: $gameRestarted, label: {
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
                        Task {
                            try await gameManager.restartGame(codeQuestion: mode.label, regenQuest: true)
                        }
                        print("GAME RESTARTED")
                        gameRestarted = true
                    })
                    
                    NavigationLink {
                        ContentView(userManager: userManager)
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
        }
        .onAppear() {
            AudioPlayer.shared.stop()
            Task {
                gameManager.restartGame = true
                model.updateUserData()
                try? await model.getUserHighscores()
                if gameManager.correctAnswersCount > model.highscores[mode.label] ?? 0  {
                    try await model.setUserHighscore(mode: mode.label, newHighscore: gameManager.correctAnswersCount)
                }
            }
        }
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("Black"))
    }
}

//struct GameOverView_Previews: PreviewProvider {
//    static var previews: some View {
//        GameOverView()
//            .environmentObject(GameManager())
//    }
//}
