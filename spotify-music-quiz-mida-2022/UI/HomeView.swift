//
//  ContentView.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 19/12/22.
//

import SwiftUI


struct HomeView: View {
    
    @State var isLoading = true
    @ObservedObject private var userModel = UserViewModel()
    @StateObject var gameManager = GameManager.shared
    
    var body: some View {
        VStack {
            if !isLoading {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Hi \(userModel.currentUser.display_name.components(separatedBy: " ").first!)!")
                            .font(TextStyle.GothamBlack(30))
                            .padding()
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .minimumScaleFactor(0.1)
                        Spacer()
                        NavigationLink(destination: HomeView()) {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 50, height: 50)
                                .rotationEffect(Angle(degrees: 180))
                                .padding(.trailing)
                        }
                    }
                    HStack(spacing: 40) {
                        Spacer()
                        if !(userModel.currentUser.image == "") {
                            AsyncImage(url: URL(string: userModel.currentUser.image)) { image in
                                image
                                    .resizable()
                                    .frame(width: 120, height: 120)
                                    .scaledToFill()
                                    .cornerRadius(100)
                                    .shadow(color: Color("Green"), radius: 40)
                            } placeholder: {
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .foregroundColor(Color("Green"))
                                    .frame(width: 120, height: 120)
                                    .scaledToFit()
                                    .cornerRadius(100)
                            }
                        } else {
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .foregroundColor(Color("Green"))
                                .frame(width: 120, height: 120)
                                .scaledToFit()
                                .cornerRadius(100)
                        }
                        VStack {
                            Text("Highscore:")
                                .font(TextStyle.score(26))
                                .foregroundColor(Color("Green"))
                                .scaledToFit()
                                .minimumScaleFactor(0.1)
                            Text(String(userModel.currentUser.highscores!["classic"]!))
                                .font(TextStyle.score(80))
                                .foregroundColor(Color("Green"))
                                .padding(.bottom, 40.0)
                                .task {
                                    try? await userModel.getUserHighscores()
                                }
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
                                NavigationLink(destination: ModeView(mode: mode)) {
                                    GameMode(cover: mode.label, description: mode.description)
                                }
                            }
                        }
                    }
                    .padding()
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(Mode.modes.suffix(4) , id: \.name) { mode in
                                NavigationLink(destination: ModeView(mode: mode)) {
                                    GameMode(cover: mode.label, description: mode.description)
                                }
                            }
                        }
                    }
                    .padding()
                    
                    Spacer()
                }
                .background(Color("Black"))
                .foregroundColor(.white)
            } else {
                ProgressView()
            }
        }
//        .toolbar(.visible, for: .tabBar)
//        .navigationBarHidden(true)
        .onAppear {
            Task {
                print("Inizio task HomeView")
                try await loadData()

                if(gameManager.restartGame){
                    try await loadGame()
                }

                print("Fine task HomeView")
            }
            //if QuestionManager.shared.isLoadingQuestions{
               
            //}
           
        }
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
        try await gameManager.startGame(codeQuestion: "home")
    }
}


    
//
//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView(, model: <#UserViewModel#>)
//    }
//}
