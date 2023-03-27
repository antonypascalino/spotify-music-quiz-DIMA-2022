//
//  AccessView.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 20/03/23.
//

import SwiftUI

struct LoginView: View {
    @State private var inputUsername = ""
    @State private var inputPassword = ""
    @State private var username = "admin"
    @State private var password = "admin"
    @State private var authenticated = false
    
    var body: some View {
        NavigationView {
            //        NavigationView {
            //            VStack {
            //                HStack {
            //                    Text("Spotify Music Quiz")
            //                        .font(TextStyle.LoginTitle())
            //                        .foregroundColor(Color("Green"))
            //                        .multilineTextAlignment(.leading)
            //                        .padding(.bottom, 35.0)
            //                        .padding(.leading)
            //                        .minimumScaleFactor(0.5)
            //                    Spacer()
            //                }
            //                HStack {
            //                    Text("Test your music!")
            //                        .font(TextStyle.homeTitle())
            //                        .foregroundColor(.white)
            //                        .multilineTextAlignment(.leading)
            //                        .padding(.leading)
            //                        .padding(.bottom, 50.0)
            //                    Spacer()
            //                }
            //                HStack {
            //                    Text("Username or email")
            //                        .font(TextStyle.LoginInputTitle())
            //                        .foregroundColor(.white)
            //                        .multilineTextAlignment(.leading)
            //                        .padding([.leading, .bottom])
            //                    Spacer()
            //                }
            //                TextField("", text: $inputUsername)
            //                    .font(Font.custom("Gotham-BookItalic", size: 20))
            //                    .frame(width: 350.0, height: /*@START_MENU_TOKEN@*/50.0/*@END_MENU_TOKEN@*/)
            //                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
            //                    .foregroundColor(.white)
            //                    .background(Color.gray.opacity(0.2))
            //                    .cornerRadius(50.0)
            //                    .padding(.horizontal)
            //                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
            //                    .autocorrectionDisabled()
            //                Spacer()
            //                HStack {
            //                    Text("Password")
            //                        .font(TextStyle.LoginInputTitle())
            //                        .foregroundColor(.white)
            //                        .multilineTextAlignment(.leading)
            //                        .padding([.leading, .bottom])
            //                    Spacer()
            //                }
            //                SecureField("", text: $inputPassword)
            //                    .font(Font.custom("Gotham-BookItalic", size: 20))
            //                    .frame(width: 350.0, height: /*@START_MENU_TOKEN@*/50.0/*@END_MENU_TOKEN@*/)
            //                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
            //                    .foregroundColor(.white)
            //                    .background(Color.gray.opacity(0.2))
            //                    .cornerRadius(50.0)
            //                    .padding(.horizontal)
            //                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
            //                    .autocorrectionDisabled()
            //                Spacer()
            //
            //                NavigationLink(destination: HomeView(), isActive: $authenticated, label: {})
            //
            //                Button(action: {
            //                    if (password == inputPassword && username == inputUsername) {
            //                        print("Correct!")
            //                        self.authenticated = true
            //                    }
            //                })
            //                {
            //                    Text("Log in")
            //                        .font(TextStyle.LoginInputTitle())
            //                }
            //                .frame(width: 120.0, height: 50.0)
            //                .background(Color("Green"))
            //                .foregroundColor(Color("Black"))
            //                .cornerRadius(30.0)
            //                .padding(.bottom, 30.0)
            //                .padding(.top, 40.0)
            //
            //            }
            //            .background(Color("Black"))
            //        }
            NavigationLink(destination: AuthView(), label: { Text("Sign In")})
        }
    }
        
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
