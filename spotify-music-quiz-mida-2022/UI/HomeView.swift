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
    @State var showAlert = false
    @State var goLoginView = false
    
    var body: some View {
        VStack {
            if (!isLoading) {
                ZStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Hi \(userModel.currentUser.display_name.components(separatedBy: " ").first!)!")
                                .font(TextStyle.GothamBlack(30))
                                .padding()
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .minimumScaleFactor(0.1)
                            Spacer()
                            
                            Button(action: {
                                showAlert = true
                            }, label: {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(width: 50, height: 50)
                                    .rotationEffect(Angle(degrees: 180))
                                    .padding(.trailing)
                                
                            })
                        }
                        .preferredColorScheme(.dark)
                        HStack() {
                            Spacer()
                            if !(userModel.currentUser.image == "") {
                                AsyncImage(url: URL(string: userModel.currentUser.image)) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? 250 : 120, height: UIDevice.current.userInterfaceIdiom == .pad ? 300 : 120)
                                        .clipShape(Circle())
                                        .shadow(color: Color("Green"), radius: 20)
                                } placeholder: {
                                    Image(systemName: "person.crop.circle")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(Color("Green"))
                                        .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? 250 : 120, height: UIDevice.current.userInterfaceIdiom == .pad ? 300 : 120)
                                    
                                }
                            } else {
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .foregroundColor(Color("Green"))
                                    .frame(width: 120, height: 120)
                                    .scaledToFit()
                                    .cornerRadius(100)
                            }
                            Spacer()
                            VStack {
                                Text("Highscore:")
                                    .font(TextStyle.score(UIDevice.current.userInterfaceIdiom == .pad ? 60 : 20))
                                    .foregroundColor(Color("Green"))
                                Text(String(userModel.currentUser.highscores!["classic"]!))
                                    .font(TextStyle.score(UIDevice.current.userInterfaceIdiom == .pad ? 150 : 80))
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
                        
                        if UIDevice.current.userInterfaceIdiom == .pad {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 20) {
                                    ForEach(Mode.modes, id: \.name) { mode in
                                        NavigationLink(destination: ModeView(mode: mode)) {
                                            GameMode(cover: mode.label, description: mode.description)
                                        }
                                    }
                                }
                            }
                            .padding()
                            
                        } else {
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
                        }
                        
                        Spacer()
                    }
                    .background(Color("Black"))
                    .foregroundColor(.white)
                    .blur(radius: showAlert ? 10 : 0)
                    
                    if (showAlert) {
                        LogOutAlert(showAlert: $showAlert)
                    }
                }
            } else {
                LoadingView()
            }
        }
        .onAppear {
            Task {
                try await loadData()

                if(gameManager.restartGame){
                    try await loadGame()
                }
            }
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
