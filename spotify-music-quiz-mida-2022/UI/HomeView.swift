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
        VStack {
            if !isLoading {
                HStack {
                    Text("Hi \(userModel.currentUser.display_name.components(separatedBy: " ").first!)!")
                        .font(TextStyle.homeTitle())

                        .padding()
                        .foregroundColor(.white)
                    Spacer()
                    NavigationLink(destination: FriendsView(mode: "classic")) {
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
                    .font(TextStyle.score(40))
                    .foregroundColor(Color("Green"))
                    .padding(.bottom)
                Text(String(userModel.currentUser.highscores!["classic"]!))
                    .font(TextStyle.score(100))
                    .foregroundColor(Color("Green"))
                    .padding(.bottom, 40.0)
                    .task {
                        try? await userModel.getUserHighscores()
                    }
                NavigationLink(destination: GameView(mode: "classic")) {
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
        )
        .foregroundColor(.white)
        .onAppear {
            Task {
                print("Inizio task HomeView")
                try await loadData()
                try await loadGame()
                print("Fine task HomeView")
            }
        }
        .toolbar(.visible, for: .tabBar)
        .toolbar(.hidden, for: .navigationBar)
    }
            
    
    
    func loadData() async throws {

        print("LOAD DATA")
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
        print("Home View: START GAME")
        try await gameManager.startGame()
    }
}


    
//
//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView(, model: <#UserViewModel#>)
//    }
//}
