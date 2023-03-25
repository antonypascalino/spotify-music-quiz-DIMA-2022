//
//  GameView.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 17/03/23.
//

import SwiftUI

struct GameView: View {
    
    var question = Question(question: "Who sings the song Bohemian Rapsody?", rightAns: "The Queen", wrongAns1: "Lady Gaga", wrongAns2: "Rolling Stones", wrongAns3: "Post Malone")
    
    
    
    var body: some View {
        
        let score = 23
        
        VStack(alignment: .leading, spacing: 30) {
            
            Spacer()
            Text("Score: \(score)")
                .font(TextStyle.score())
                .foregroundColor(Color("Green"))
                .padding(.leading)

            
            Text(question.question)
                .font(TextStyle.LoginTitle())
                .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                .frame(width: 360.0, height: 60, alignment: .leading)
                .minimumScaleFactor(0.1)
                .foregroundColor(.white)
                .padding([.leading, .bottom])

            
            Answer(question: question, index: 0)
            Answer(question: question, index: 1)
            Answer(question: question, index: 2)
            Answer(question: question, index: 3)
            
            HStack {
                Spacer()
                TimeBar(duration: 10)
                Spacer()
            }
            .padding(.top, 32)
            
           GameControls()
        }
        .background(Color("Black"))
        
        
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
