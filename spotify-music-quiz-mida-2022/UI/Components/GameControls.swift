//
//  GameControls.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 24/03/23.
//

import SwiftUI

struct GameControls: View {
    
    @EnvironmentObject var gameManager : GameManager
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                
            }, label: {
                Image(systemName: "backward.end.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 45, weight: .ultraLight))
                    .opacity(!gameManager.answerSelected ? 0.5 : 1)
            })
            
            Button(action: {
                
            }, label: {
                Image(systemName: gameManager.answerSelected ? "play.circle.fill" : "pause.circle.fill")
                    .foregroundColor(.white)
                    .padding(.horizontal, 25.0)
                    .font(.system(size: 80, weight: .ultraLight))
                    .opacity(!gameManager.answerSelected ? 0.5 : 1)
            })
            .disabled(!gameManager.answerSelected)
            
            
            
            
            Button(action: {
                Task {
                    try await gameManager.setNextQuestion()
                }
            }, label: {
                Image(systemName: "forward.end.fill")
                .foregroundColor(.white)
                .font(.system(size: 45, weight: .ultraLight))
                .opacity(!gameManager.answerSelected ? 0.5 : 1)
            })
            .disabled(!gameManager.answerSelected)
            Spacer()
        }
    }
}

struct GameControls_Previews: PreviewProvider {
    static var previews: some View {
        GameControls()
            .environmentObject(GameManager())
            .background(Color("Black"))
            
    }
}
