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
        
        var question = gameManager.getNextQuestion()
        let answers = question?.getAnswers()
        
        VStack(alignment: .leading, spacing: 30) {
            
            Spacer()
            Text("Score: \(gameManager.correctAnswersCount)")
                .font(TextStyle.score())
                .foregroundColor(Color("Green"))
                .padding(.leading)

            
            Text((question?.questionText)!)
                .font(TextStyle.LoginTitle())
                .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                .frame(width: 360.0, height: 60, alignment: .leading)
                .minimumScaleFactor(0.1)
                .foregroundColor(.white)
                .padding([.leading, .bottom])

           
            Answer(answer: answers![0], isCorrect: question!.isCorrect(answers![0]))
                .environmentObject(gameManager)
            Answer(answer: answers![1], isCorrect: question!.isCorrect(answers![1]))
                .environmentObject(gameManager)
            Answer(answer: answers![2], isCorrect: question!.isCorrect(answers![2]))
                .environmentObject(gameManager)
            Answer(answer: answers![3], isCorrect: question!.isCorrect(answers![3]))
                .environmentObject(gameManager)

            
            HStack {
                Spacer()
                TimeBar(duration: 10)
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
