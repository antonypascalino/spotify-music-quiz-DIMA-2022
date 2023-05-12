//
//  GameView.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 17/03/23.
//

import SwiftUI

struct GameView: View {

    @StateObject private var model = GameViewModel()
    
    @StateObject private var gameManager = GameManager.shared
    @State var userProfile : UserProfile?
    @State var isLoading = false
    @State private var error: Error?

    
    
    var body: some View {
        var question = model.getNextQuestion()
        let score = 23
        
        VStack(alignment: .leading, spacing: 30) {
            
            Spacer()
            Text("Score: \(score)")
                .font(TextStyle.score())
                .foregroundColor(Color("Green"))
                .padding(.leading)

            
            Text("Ciao")
                .font(TextStyle.LoginTitle())
                .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                .frame(width: 360.0, height: 60, alignment: .leading)
                .minimumScaleFactor(0.1)
                .foregroundColor(.white)
                .padding([.leading, .bottom])

            let answers = question.getAnswers()
            Answer(answer: answers[0], isCorrect: question.isCorrect(answers[0]))
            Answer(answer: answers[1], isCorrect: question.isCorrect(answers[1]))
            Answer(answer: answers[2], isCorrect: question.isCorrect(answers[2]))
            Answer(answer: answers[3], isCorrect: question.isCorrect(answers[3]))

            
            HStack {
                Spacer()
                TimeBar(duration: 10)
                Spacer()
            }
            .padding(.top, 32)
            
           GameControls()
        }
        .background(Color("Black"))
        .navigationBarHidden(true)
    }
    
    init() {
        model.startGame()
    }
}



struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
