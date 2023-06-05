//
//  ContentView.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 19/12/22.
//

import SwiftUI


struct HomeView: View {
    
//    @State var userProfile : UserProfile?
    @State var isLoading = true
    @ObservedObject private var userModel = UserViewModel()
    @StateObject var gameManager = GameManager.shared

    var body: some View {
        NavigationView {
            VStack {
                //                if isLoading {
                //                    ProgressView()
                //                }
                //                else if let userProfile = userProfile {
                if !isLoading {
                    HStack {
                        Text("Hi \(userModel.currentUser.display_name)!")
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
                        NavigationLink(destination: AuthorScoreView()) {
                            Image(systemName: "music.note.list")
                                .font(.system(size: 25, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 50, height: 50)
                        }
                    }
                    Spacer()
                    
                    if !(userModel.currentUser.image == "") {
                        
                        AsyncImage(url: URL(string: userModel.currentUser.image)) { image in
                            image
                                .resizable()
                                .frame(width: 230, height: 230)
                                .scaledToFill()
                                .cornerRadius(100)
                                .shadow(color: Color("Green"), radius: 40)
                        } placeholder: {
                            ProgressView()
                        }
                    } else {
                        Image("SpotifyLogoBlack")
                            .resizable()
                            .frame(width: 200, height: 200)
                            .scaledToFit()
                            .shadow(color: Color("Green"), radius: 40)
                    }
                    
                    Spacer()
                    Text("Highscore:")
                        .font(TextStyle.scoreTitle())
                        .foregroundColor(Color("Green"))
                        .padding(.bottom)
                    Text(String(userModel.currentUser.highscore))
                        .font(TextStyle.score(100))
                        .foregroundColor(Color("Green"))
                        .padding(.bottom, 40.0)
                        .task {
                            try? await userModel.getUserHighscore()
                        }
                    NavigationLink(destination: GameView()) {
                        Image(systemName: "play.circle.fill")
                            .resizable()
                            .frame(width: 80.0, height: 80.0)
                            .foregroundColor(Color("Green"))
                            .padding(.bottom)
                        
                    }
                } else {
                    LoadingView()
                }
            }
            
            .background(Color("Black")
//                RadialGradient(
//                    gradient: Gradient(colors: [Color("Green"), Color("Black")]),
//                    center: UnitPoint(x: 0.50, y: 0.35),
//                    startRadius: 20,
//                    endRadius: 280)
            )
            .foregroundColor(.white)
                        .onAppear {
                            Task {
                                try await loadData()
                                try await loadGame()
                            }
                        }
            //        }
            //            .task {
            //                try? await model.getCurrentUser()
            //            }
        }
                    .navigationBarHidden(true)
            
            
        
    }
            
    
    
    func loadData() async throws {

        print("")
        self.isLoading = true

        try await APICaller.shared.getUserProfile { result in
            switch result{
                case .success(let model):
                    print("UserName: \(model.id)")
                    userModel.updateUserData()
                    self.isLoading = false
                    
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    //self.isLoading = false
                    //self?.failedToGetProfile()
            }
        }
    }
    
    func loadGame() async throws {
        try await gameManager.startGame()
    }
}


    
//
//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView(, model: <#UserViewModel#>)
//    }
//}
