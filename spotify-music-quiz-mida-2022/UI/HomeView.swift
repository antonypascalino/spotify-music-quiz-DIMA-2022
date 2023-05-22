//
//  ContentView.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 19/12/22.
//

import SwiftUI

let score = 257


struct HomeView: View {
    
    @State var userProfile : UserProfile?
    @State var isLoading = false
    @State private var error: Error?
    @State private var profileImage: UIImage?
    
    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView()
                }
                else if let userProfile = userProfile {
                    HStack {
                        Text("Hi \(userProfile.display_name)!")
                            .font(TextStyle.homeTitle())
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .foregroundColor(.white)
                        Spacer()
                        NavigationLink(destination: FriendsView()) {
                            Image(systemName: "list.number")
                                .font(.system(size: 25, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 50, height: 50)
                        }
                        NavigationLink(destination: SettingsView()) {
                            Image(systemName: "gearshape")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 50, height: 50)
                        }
                    }
                    Spacer()
                    
                    if !(userProfile.images!.isEmpty) {

                        AsyncImage(url: URL(string: userProfile.images!.first!.url)) { image in
                            image
                                .resizable()
                                .frame(width: 200, height: 200)
                                .scaledToFit()
                                .cornerRadius(100)
                        } placeholder: {
                            ProgressView()
                        }
                    } else {
                        Image("SpotifyLogoBlack")
                            .resizable()
                            .frame(width: 200, height: 200)
                            .scaledToFit()
                    }
                    
                    Spacer()
                    Text("Your highscore:")
                        .font(TextStyle.scoreTitle())
                        .foregroundColor(Color("Green"))
                        .padding(.bottom)
                    Text(String(score))
                        .font(TextStyle.score(50))
                        .foregroundColor(Color("Green"))
                        .padding(.bottom, 40.0)
                    NavigationLink(destination: GameView()) {
                        Image("GreenPlay")
                            .resizable()
                            .frame(width: 100.0, height: 100.0)
                    }
                }
            }
            .background(
                RadialGradient(
                    gradient: Gradient(colors: [Color("Green"), Color("Black")]),
                    center: UnitPoint(x: 0.50, y: 0.35),
                    startRadius: 20,
                    endRadius: 280)
            )
            .foregroundColor(.white)
            .onAppear{
                loadData()
            }
        }
        .navigationBarHidden(true)
    }
            
    
    func loadData() {
        
        isLoading = true
        
        APICaller.shared.getUserProfile {result in
            switch result{
                case .success(let model):
                    self.userProfile = model
                    self.isLoading = false
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    self.isLoading = false
                    //self?.failedToGetProfile()
            }
            
        }
    }
}


    

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
