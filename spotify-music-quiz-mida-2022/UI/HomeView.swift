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

    @StateObject private var gameManager = GameManager.shared
    
    var body: some View {
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
                    NavigationLink(destination: LeaderboardView()) {
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
                if let image = profileImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 250.0, height: 250.0)
                        .clipShape(Circle())
                }
                Spacer()
                Text("Your highscore:")
                    .font(TextStyle.scoreTitle())
                    .foregroundColor(Color("Green"))
                    .padding(.bottom)
                Text(String(score))
                    .font(TextStyle.score())
                    .foregroundColor(Color("Green"))
                    .padding(.bottom, 40.0)
                NavigationLink(destination: GameView()) {
                    Image("GreenPlay")
                        .resizable()
                        .frame(width: 100.0, height: 100.0)
                }.onAppear {
                    gameManager.startGame()
                }
            }
        }
        .background(
            RadialGradient(gradient: Gradient(colors: [Color("Green"), Color("Black")]),
                           center: UnitPoint(x: 0.50, y: 0.35),
                           startRadius: 20,
                           endRadius: 280)
            
        )
        .navigationTitle("Home")
        .foregroundColor(.white)
        .onAppear{
            loadData()
            fetchImage(url: URL(string: (userProfile?.images?.first!.url))!)
        }
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
    func fetchImage(url: URL) {
            isLoading = true
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                isLoading = false
                
                guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                    self.error = error ?? URLError(.unknown)
                    return
                }
                
                guard response.statusCode == 200 else {
                    self.error = URLError(.badServerResponse)
                    return
                }
                
                self.profileImage = UIImage(data: data)
            }.resume()
        }
}


    

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
