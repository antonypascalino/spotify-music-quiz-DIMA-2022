//
//  AccessView.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 20/03/23.
//

import SwiftUI

struct LoginView: View {
    
    @State var completeAuth = false
    
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
                    Spacer()
                }
                Spacer()
                HStack {
                    Text("Test your music!")
                        .font(TextStyle.homeTitle())
                        .foregroundColor(.white)
                        .padding(.leading)
                        .padding(.bottom, 50.0)
                }
                Spacer()
                
                NavigationLink(destination: AuthView( completionHandler: { value in
                    if value {
                        completeAuth = true
                    }
                }), label: {
                    HStack {
                        Image("SpotifyLogoBlack")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("Sign in")
                            .font(TextStyle.LoginInputTitle())
                    }
                })
                .frame(width: 210.0, height: 60.0)
                .background(Color("Green"))
                .foregroundColor(Color("Black"))
                .cornerRadius(30.0)
                Spacer()
                
                if completeAuth {
                    NavigationLink(
                        destination: HomeView(),
                        isActive: $completeAuth) {
                            EmptyView()
                        }
                }
                
            }
            .background(Color("Black"))
            .onDisappear() {
                Task {
                    try await APICaller.shared.getUserProfile { result in
                        switch result{
                            case .success(let model):
                                //                            self.userProfile = model
                                //                            print("USER PROFILE: \(userProfile)")
                                //                            self.currentUser = APICaller.shared.currentUser
                                //                            print("CURRENT USER: \(currentUser)")
                                //                            self.isLoading = false
                                break
                            case .failure(let error):
                                print(error.localizedDescription)
//                                self.isLoading = false
                                //self?.failedToGetProfile()
                        }
                    }
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
