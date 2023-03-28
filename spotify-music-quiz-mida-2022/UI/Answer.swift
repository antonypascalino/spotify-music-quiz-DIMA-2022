//
//  Answer.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 22/03/23.
//

import SwiftUI

var question = Question(question: "Who sings the song Bohemian Rapsody?", rightAns: "The Queen", wrongAns1: "Lady Gaga", wrongAns2: "Rolling Stones", wrongAns3: "Post Malone")

struct Answer: View {
    
    var question : Question
    var index: Int
    
    var body: some View {
    
//        VStack {
//            Button(
//                action: {
//
//                },
//                label: {
//                    HStack {
//                        Image(systemName: "circle.fill")
//                            .foregroundColor(Color("Green"))
//                            .padding(.leading)
//                        Text(question.answers[index])
//                            .font(TextStyle.answer())
//                            .foregroundColor(Color("Green"))
//                    }
//                })
//            .frame(width: 300.0, height: 60.0, alignment: .leading)
//            .overlay(
//                RoundedRectangle(cornerRadius: 100)
//                    .stroke(Color("Green"), lineWidth: 4)
//        )
            Button(
                action: {
                    
                },
                label: {
                    HStack {
                        Image(systemName: "circle.fill")
                            .foregroundColor(Color("Green"))
                            .padding(.leading)
                        Text(question.answers[index])
                            .font(TextStyle.answer())
                            .foregroundColor(Color(.white))
                    }
                })
            .frame(width: 300.0, height: 60.0, alignment: .leading)
        }
}

struct Answer_Previews: PreviewProvider {
    
    static var previews: some View {
        Answer(question: question, index: 0)
            .background(Color("Black"))
    }
}
