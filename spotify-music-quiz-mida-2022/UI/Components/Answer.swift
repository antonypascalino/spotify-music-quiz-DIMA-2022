//
//  Answer.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 22/03/23.
//

import SwiftUI


struct Answer: View {
    
    @EnvironmentObject var gameManager : GameManager

    var answer : String
    @State var isSelected = false
    
    
    var body: some View {
        
        let currentQuestion = gameManager.getNextQuestion()!
        let isCorrect = currentQuestion.isCorrect(answer)
        
        HStack {
            Image(systemName: "circle.fill")
                .foregroundColor(Color(isSelected || (gameManager.answerSelected && isCorrect) ? "Black" : "Green"))
                .padding(.leading)
            Text(answer)
                .font(TextStyle.answer())
                .foregroundColor(Color(isSelected || (gameManager.answerSelected && isCorrect) ? "Black" : "White"))
                .lineLimit(1)
                .minimumScaleFactor(0.1)
        }
        
        .frame(width: 300.0, height: 60.0, alignment: .leading)
        .background(Color(isSelected || (!isSelected && isCorrect && gameManager.answerSelected) ? (isCorrect ? "Green" : "Red") : "Black"))
        .cornerRadius(100)
        .onTapGesture {
            if !gameManager.answerSelected {
                isSelected = true
                gameManager.selectAnswer(isCorrect)
            }
        }
        .onChange(of: currentQuestion) { newValue in
            isSelected = false
        }
    }
}

struct Answer_Previews: PreviewProvider {

    static var previews: some View {
        
        Answer(answer: "Pinguini Tattici Nucleari")
            .environmentObject(GameManager())
            .background(Color("Black"))
    }
}
