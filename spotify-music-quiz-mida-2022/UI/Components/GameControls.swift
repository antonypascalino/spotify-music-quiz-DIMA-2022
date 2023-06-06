//
//  GameControls.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 24/03/23.
//

import SwiftUI

struct GameControls: View {
    
    @EnvironmentObject var gameManager : GameManager
    @State var goHome = false
    @State var showAlert = false
    
    var body: some View {
        HStack {
            Spacer()
            
            if goHome {
                NavigationLink(
                    destination: HomeView(),
                    isActive: $goHome) {
                        EmptyView()
                    }
            }
            
            Button(action: {
                showAlert = true
            }, label: {
                Image(systemName: "backward.end.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 45, weight: .ultraLight))
//                    .opacity(!gameManager.answerSelected ? 0.5 : 1)
            
            })
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Wanna leave the game?"),
                    message: Text("The score of this game will be lost!"),
                    primaryButton: .default(Text("Yes")) {
                        goHome = true
                        gameManager.gameOver()
//                        Task {
//                            try await gameManager.endGame()
//                        }
                    },
                    secondaryButton: .cancel(Text("No").foregroundColor(Color("Red"))) {
                        showAlert = false
                    }
                )
            }
            
            
            Image(systemName: gameManager.isTimerRunning ? "pause.circle.fill" : "play.circle.fill")
                .foregroundColor(.white)
                .padding(.horizontal, 25.0)
                .font(.system(size: 80, weight: .ultraLight))
                .onTapGesture {
                    if !gameManager.answerSelected {
                        gameManager.isTimerRunning ? gameManager.pauseTimer() : gameManager.resumeTimer()
                        print("isTimerRunning = \(gameManager.isTimerRunning)")
                    }
                }
            
            Button(action: {
                Task {
                    try await gameManager.setNextQuestion()
                }
                gameManager.resumeTimer()
            }, label: {
                Image(systemName: "forward.end.fill")
                .foregroundColor(.white)
                .font(.system(size: 45, weight: .ultraLight))
                .opacity(!gameManager.answerSelected ? 0.5 : 1)
            })
            .disabled(!gameManager.answerSelected)
            Spacer()
        }
    }
}

//struct GameControls_Previews: PreviewProvider {
//    static var previews: some View {
//        GameControls(timeBar: TimeBar(duration: 20))
//            .environmentObject(GameManager())
//            .background(Color("Black"))
//            
//    }
//}
