//
//  TestView.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 10/05/23.
//

import SwiftUI

struct TestView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Hi Antony!")
                    .font(TextStyle.GothamBlack(30))
                    .padding()
                    .foregroundColor(.white)
                
                Spacer()
                
//                Image(systemName: "list.number")
//                    .font(.system(size: 25, weight: .bold))
//                    .foregroundColor(.white)
//                    .frame(width: 50, height: 50)
                
                
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.system(size: 25, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .rotationEffect(Angle(degrees: 180))
                    .padding(.trailing)
                
            }
            HStack(spacing: 40) {
                Spacer()
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .foregroundColor(Color("Green"))
                    .frame(width: 120, height: 120)
                    .scaledToFit()
                    .cornerRadius(100)
                
                VStack {
                    Text("Highscore:")
                        .font(TextStyle.score(26))
                        .foregroundColor(Color("Green"))
                    
                    Text("45")
                        .font(TextStyle.score(80))
                        .foregroundColor(Color("Green"))
                        .padding(.bottom, 40.0)
                }
                .offset(y: 20)
                Spacer()
            }
            .padding([.bottom,.top])
            
            Text("Let's play!")
                .font(TextStyle.GothamBlack(30))
                .padding(.leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(Mode.modes.prefix(3) , id: \.name) { mode in
                        GameMode(cover: mode.label, description: mode.description)
                    }
                }
            }
            .padding()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(Mode.modes.suffix(4) , id: \.name) { mode in
                        GameMode(cover: mode.label, description: mode.description)
                    }
                }
            }
            .padding()
            
            Spacer()
        }
        .background(Color("Black"))
        .foregroundColor(.white)
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
