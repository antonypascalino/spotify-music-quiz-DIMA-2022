//
//  GameView.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 17/03/23.
//

import SwiftUI

struct GameView: View {
    
    @StateObject var gameManager = GameManager()
    
    var body: some View {
        
        var currentAnwers = gameManager.currentAnswers!
        var currentQuestion = gameManager.getNextQuestion()!
        
        VStack(alignment: .leading, spacing: 30) {
            
            Spacer()
            Text("Score: \(gameManager.correctAnswersCount)")
                .font(TextStyle.score())
                .foregroundColor(Color("Green"))
                .padding(.leading)
            
            
            Text((gameManager.getNextQuestion()?.questionText)!)
                .font(TextStyle.LoginTitle())
                .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                .frame(width: 360.0, height: 60, alignment: .leading)
                .minimumScaleFactor(0.1)
                .foregroundColor(.white)
                .padding([.leading, .bottom])
            
            
            ForEach(currentAnwers, id: \.self) { answer in
                Answer(answer: answer)
                    .environmentObject(gameManager)
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



struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
