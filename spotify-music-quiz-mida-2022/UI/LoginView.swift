//
//  AccessView.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 20/03/23.
//

import SwiftUI

struct LoginView: View {
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Spotify Music Quiz")
                        .font(TextStyle.LoginTitle())
                        .foregroundColor(Color("Green"))
                        .multilineTextAlignment(.leading)
                        .padding(.bottom, 35.0)
                        .padding(.leading)
                        .minimumScaleFactor(0.5)
                    Spacer()
                }
                Spacer()
                HStack {
                    Text("Test your music!")
                        .font(TextStyle.homeTitle())
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .padding(.leading)
                        .padding(.bottom, 50.0)
                }
                Spacer()
                
                NavigationLink(destination: AuthView(), label: {
                    ZStack{
                        HStack {
                            Image("SpotifyLogoBlack")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("Sign in")
                                .font(TextStyle.LoginInputTitle())
                        }
                    }
                })
                .frame(width: 210.0, height: 60.0)
                .background(Color("Green"))
                .foregroundColor(Color("Black"))
                .cornerRadius(30.0)
                Spacer()
                
            }
            .background(Color("Black"))
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
