//
//  GameControls.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 24/03/23.
//

import SwiftUI

struct GameControls: View {
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                
            }, label: {
                Image(systemName: "backward.end.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 45, weight: .ultraLight))
            })
            
            Button(action: {
                
            }, label: {
                Image(systemName: "play.circle.fill")
                    .foregroundColor(.white)
                    .padding(.horizontal, 25.0)
                    .font(.system(size: 80, weight: .ultraLight))
            })
            
            
            NavigationLink(destination: GameView()) {
                Image(systemName: "forward.end.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 45, weight: .ultraLight))
            }
            Spacer()
        }
    }
}

struct GameControls_Previews: PreviewProvider {
    static var previews: some View {
        GameControls()
            .background(Color("Black"))
    }
}
