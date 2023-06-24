//
//  ModeView.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 08/05/23.
//
//
import SwiftUI


//Page of the single game mode, shows the leaderborad of your friends in this mode and can launch the game
struct ModeView: View {
    
    let mode : Mode
    @StateObject private var model = UserViewModel()
    @StateObject var gameManager = GameManager.shared
    @State var isLoading = true
    
    var body: some View {
        
        VStack {
            
            let friends = model.friends
                .filter { friend in
                    friend.highscores?[mode.label] ?? nil != nil && friend.highscores?[mode.label] != 0
                    
                }
                .sorted { $0.highscores![mode.label]! > $1.highscores![mode.label]! }
            
            Image(mode.label)
                .resizable()
                .frame(width: 220.0, height: 220.0)
                .scaledToFit()
                .offset(y: -20)
                .shadow(color: Color("Black").opacity(0.8), radius: 15)
            
            HStack {
                Text(mode.name)
                    .font(TextStyle.GothamBlack(30))
                    .padding(.leading)
                    .foregroundColor(.white)
                Spacer()
            }
            
            HStack{
                Text(mode.description)
                    .font(TextStyle.leaderboardItem().bold())
                    .foregroundColor(Color.gray)
                Spacer()
            }
            .padding(.leading)
            HStack(spacing: 20) {
                VStack(alignment: .leading) {
                    if(!model.isLoading) {
                        Text("Your highscore: \(model.currentUser.highscores![mode.label] ?? 0)")
                            .font(TextStyle.leaderboardItem().bold())
                            .foregroundColor(.white)
                    } else {
                        Text("Your highscore:")
                            .font(TextStyle.leaderboardItem().bold())
                            .foregroundColor(.white)
                    }
                    Text("Your friends highscores:")
                        .font(TextStyle.leaderboardItem().bold())
                        .foregroundColor(Color.white)
                }
                
                Spacer()
                NavigationLink (destination: AddFriendsView() ,label: {
                    Image(systemName: "person.crop.circle.badge.plus")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color.gray)
                        .frame(width: 40.0, height: 40.0)
                })
                
                NavigationLink (destination: GameView(mode: mode).navigationBarHidden(true) ,label: {
                    Image(systemName: "play.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color("Green"))
                        .frame(width: 50.0, height: 50.0)
                    
                })
                
                .padding(.trailing, 5.0)
            }
            .padding()
            if (!friends.isEmpty) {
                ScrollView {
                    ForEach(Array(friends.enumerated()), id: \.offset) { index, friend in
                        HStack {
                            Text("\(index + 1)")
                                .font(TextStyle.leaderboardItem().bold())
                                .foregroundColor(.white)
                                .frame(width: 20, height: 20)
                                .padding(.leading)
                            ListImage(imageString: friend.image)
                            Text(friend.display_name)
                                .font(TextStyle.leaderboardItem().bold())
                                .foregroundColor(.white)
                                .padding(.leading)
                            Spacer()
                            Text(String(friend.highscores![mode.label]!))
                                .font(TextStyle.leaderboardItem().bold())
                                .foregroundColor(.white)
                                .padding(.trailing, 35)
                        }
                        .listRowBackground(Color.clear)
                        .padding(.bottom)
                    }
                }
            } else {
                VStack {
                    Spacer()
                    Text("No friends of yours has ever played this mode!")
                        .foregroundColor(.white)
                        .font(TextStyle.leaderboardItem().bold())
                    
                    HStack {
                        Text("Click on")
                            .foregroundColor(.white)
                            .font(TextStyle.leaderboardItem().bold())
                        Image(systemName: "person.crop.circle.badge.plus")
                            .foregroundColor(.white)
                        Text("to add new friends!")
                            .foregroundColor(.white)
                            .font(TextStyle.leaderboardItem().bold())
                    }
                    Spacer()
                }
            }
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [mode.color.opacity(0.8), .black]),
                startPoint: UnitPoint(x: 0.5, y: 0),
                endPoint: UnitPoint(x: 0.5, y: 0.5)
                    )
                )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            print("ModeView")
            Task {
                print("TASK ModeView")
                model.updateUserData()
                try? await model.getFriends()
                try? await model.getUserHighscores()
                
                Task.detached {
                    while QuestionManager.shared.isLoadingQuestions {
                        // Lavora in background
                    }
                    print("PARTO START MINI")
                    try await gameManager.startMiniGame(codeQuestion: mode.label, regenQuest: false)

                    DispatchQueue.main.async {
                        // Torna alla coda principale per eseguire operazioni sull'interfaccia utente
                        self.isLoading = false
                    }
                }
                
            }

        }
    }
}

extension UINavigationController {

  open override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    navigationBar.topItem?.backButtonDisplayMode = .minimal
  }

}

//struct ModeView_Previews: PreviewProvider {
//    static var previews: some View {
//        ModeView()
//    }
//}
