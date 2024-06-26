//
//  GameControls.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 24/03/23.
//

import SwiftUI

struct GameControls: View {
    
    let userManager : UserManager
    @EnvironmentObject var gameManager : GameManager
    @State var goHome = false
    @Binding var showAlert : Bool
    
    var body: some View {
        HStack {
            Spacer()
            
            if goHome {
                NavigationLink(
                    destination: ContentView(userManager: userManager),
                    isActive: $goHome) {
                        EmptyView()
                    }
            }
            
            Button(action: {
                showAlert = true
                gameManager.pauseTimer()
            }, label: {
                Image(systemName: "backward.end.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 45, weight: .ultraLight))
            })
//            .alert(isPresented: $showAlert) {
//                Alert(
//                    title: Text("Wanna leave the game?"),
//                    message: Text("The score of this game will be lost!"),
//                    primaryButton: .default(Text("Yes")) {
//                        AudioPlayer.shared.stop()
//                        goHome = true
////                        gameManager.gameOver()
//                        gameManager.restartGame = true
//                        gameManager.resumeTimer()
//                    },
//                    secondaryButton: .cancel(Text("No").foregroundColor(Color("Red"))) {
//                        showAlert = false
//                        gameManager.resumeTimer()
//                    }
//                )
//            }
            
            
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
