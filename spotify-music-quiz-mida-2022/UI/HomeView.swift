//
//  ContentView.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 19/12/22.
//

import SwiftUI


struct HomeView: View {
    
//    @State var userProfile : UserProfile?
    @State var currentUser = APICaller.shared.currentUser
    @StateObject private var model = UserViewModel()

    
    var body: some View {
        NavigationView {
            VStack {
                //                if isLoading {
                //                    ProgressView()
                //                }
                //                else if let userProfile = userProfile {
                HStack {
                    Text("Hi \(currentUser!.display_name)!")
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
                
                if !(currentUser?.image == "") {
                    
                    AsyncImage(url: URL(string: currentUser!.image)) { image in
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
                Text(String(model.highscore))
                    .font(TextStyle.score(50))
                    .foregroundColor(Color("Green"))
                    .padding(.bottom, 40.0)
                    .task {
                        try? await model.getUserHighscore(SpotifyID: currentUser!.SpotifyID)
                    }
                NavigationLink(destination: GameView()) {
                    Image(systemName: "play.circle.fill")
                        .resizable()
                        .frame(width: 100.0, height: 100.0)
                        .foregroundColor(Color("Green"))
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
            //            .onAppear {
            //                Task {
            //                    try await loadData()
            //                }
            //            }
            //        }
            .task {
                try? await model.addUser(user: APICaller.shared.currentUser!)
            }
        }
        .navigationBarHidden(true)
        
    }
            
    
//    func loadData() async throws {
//
//        isLoading = true
//
//        try await APICaller.shared.getUserProfile { result in
//            switch result{
//                case .success(let model):
//                    self.userProfile = model
//                    print("USER PROFILE: \(userProfile)")
//                    self.currentUser = APICaller.shared.currentUser
//                    print("CURRENT USER: \(currentUser)")
//                    self.isLoading = false
//                    break
//                case .failure(let error):
//                    print(error.localizedDescription)
//                    self.isLoading = false
//                    //self?.failedToGetProfile()
//            }
//        }
//    }
}


    

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
