
//  GameMode.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 06/06/23.


import SwiftUI

struct GameMode: View {
    
    let cover : String
    let description : String
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Image(cover)
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 140)
            
            Text(description)
                .font(TextStyle.GothamLight(20).bold())
                .foregroundColor(.gray)
                .minimumScaleFactor(0.5)
                .lineLimit(2)
                .scaledToFill()
        }
        .frame(width: 140)
    }
}

struct GameMode_Previews: PreviewProvider {
    static var previews: some View {
        let cover = "GuessTheSong"
        let description = "Listen! Remember the title?"
        
        VStack {
            GameMode(cover: cover, description: description)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("Black"))
    }
}
