//
//  Answer.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 22/03/23.
//

import SwiftUI


struct Answer: View {
    
    var answer : String
    var isCorrect : Bool
    @State private var isSelected = false
    
    var body: some View {
        Button(
            action: {
                
            },
            label: {
                HStack {
                    Image(systemName: "circle.fill")
                        .foregroundColor(Color(isSelected ? "Black" : "Green"))
                        .padding(.leading)
                    Text(answer)
                        .font(TextStyle.answer())
                        .foregroundColor(Color(isSelected ? "Black" : "White"))
                }
            })
        .frame(width: 300.0, height: 60.0, alignment: .leading)
        .background(Color(isSelected ? (isCorrect ? "Green" : "Red") : "Black"))
        .cornerRadius(100)
        .onTapGesture {
            isSelected = true
        }
    }
}

struct Answer_Previews: PreviewProvider {

    static var previews: some View {
        Answer(answer: "Freddy Mercury", isCorrect: true)
            .background(Color("Black"))
    }
}
