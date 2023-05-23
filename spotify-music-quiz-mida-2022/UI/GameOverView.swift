//
//  GameOverView.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 21/05/23.
//

import SwiftUI


struct GameOverView: View {
    
    let score : Int
    
    var body: some View {
        VStack {
            Spacer()
            Text("Oh no!")
                .font(TextStyle.score(80))
                .foregroundColor(Color("Green"))
                .padding()
            
            Text("Your score is:")
                .font(TextStyle.score(40))
                .foregroundColor(Color("Green"))
                .padding()
            
            Text(String(score))
                .font(TextStyle.score(100))
                .foregroundColor(Color("Green"))
                .padding()
            Spacer()
            HStack(spacing: 30.0) {
                NavigationLink {
                    HomeView()
                } label: {
                    Image(systemName: "house.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("Homepage")
                        .font(TextStyle.LoginInputTitle())
                }
                .frame(width: 170.0, height: 60.0)
                .background(Color("Green"))
                .foregroundColor(Color("Black"))
                .cornerRadius(30.0)
                
                NavigationLink {
                    GameView()
                } label: {
                    HStack {
                        Image(systemName: "play.circle.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                        
                        Text("Play again!")
                            .font(TextStyle.LoginInputTitle())
                    }
                }
                .frame(width: 170.0, height: 60.0)
                .background(Color("Green"))
                .foregroundColor(Color("Black"))
                .cornerRadius(30.0)
                }
            .padding(.bottom, 50.0)
            }
        
        .navigationBarHidden(true)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("Black"))
    }
}

struct GameOverView_Previews: PreviewProvider {
    static var previews: some View {
        GameOverView(score: 19)
    }
}
