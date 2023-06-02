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
                    Text(String(userModel.currentUser.highscore))
                        .font(TextStyle.score(50))
                        .foregroundColor(Color("Green"))
                        .padding(.bottom, 40.0)
                        .task {
                            try? await userModel.getUserHighscore()
                        }
                    NavigationLink(destination: GameView()) {
                        Image(systemName: "play.circle.fill")
                            .resizable()
                            .frame(width: 100.0, height: 100.0)
                            .foregroundColor(Color("Green"))
                    }
                }else {
                    ProgressView()
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
                        .onAppear {
                            Task {
                                try await loadData()
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
}


    
//
//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView(, model: <#UserViewModel#>)
//    }
//}
