//
//  QuestionView.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 22/03/23.
//

import SwiftUI

struct QuestionView: View {
    
    var question = ""
    
    var body: some View {
        
        GeometryReader { geometry in
            Text(question)
                .font(Font.custom("Gotham-Black", size: min(geometry.size.width, geometry.size.height)))
                .foregroundColor(.black)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
        }
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView(question: "Hello world!")
    }
}
