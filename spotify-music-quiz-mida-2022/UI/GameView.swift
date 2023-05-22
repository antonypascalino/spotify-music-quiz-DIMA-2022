//
//  GameView.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 17/03/23.
//

import SwiftUI

struct GameView: View {
    
    @StateObject var gameManager = GameManager()
    @State private var isShowingGuessView = true
    @State private var userAnswer = ""
    
    var body: some View {
        
        let currentAnwers = gameManager.currentAnswers!
        let currentQuestion = gameManager.getNextQuestion()!
        let playerMiss = gameManager.playerMiss
        let gameIsOver = gameManager.gameIsOver
        
        
        if gameIsOver {
            GameOverView()
                .environmentObject(GameManager())
        } else {
            VStack(alignment: .leading, spacing: 30) {
                
                Spacer()
                Text("Score: \(gameManager.correctAnswersCount)")
                    .font(TextStyle.score())
                    .foregroundColor(Color(playerMiss ? "Red" : "Green"))
                    .padding(.leading)
                
                
                Text((gameManager.getNextQuestion()?.questionText)!)
                    .font(TextStyle.LoginTitle())
                    .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                    .frame(width: 360.0, height: 60, alignment: .leading)
                    .minimumScaleFactor(0.1)
                    .foregroundColor(.white)
                    .padding([.leading, .bottom])
                
                if(gameManager.getNextQuestion()!.isShazam){
                    if isShowingGuessView {
                        GuessTheSongView(url: gameManager.getNextQuestion()!.songUrl!, userAnswer : $userAnswer, isShowingGuessView: $isShowingGuessView)
                    } else {
                        
                        //sicuramente da fixare e creare un'altra struttura per queste risposte
                        Answer(answer: userAnswer)
                        
                    }
                } else {
                    
                    ForEach(currentAnwers, id: \.self) { answer in
                        Answer(answer: answer)
                            .environmentObject(gameManager)
                    }
                }
                
                HStack {
                    Spacer()
                    TimeBar(duration: 10)
                        .environmentObject(gameManager)
                    Spacer()
                }
                .padding(.top, 32)
                
                GameControls()
                    .environmentObject(gameManager)
            }
            
            .background(Color("Black"))
            .navigationBarHidden(true)
        }
    }
    
}



struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
