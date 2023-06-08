//
//  ModeView.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 08/05/23.
//
//
import SwiftUI



struct ModeView: View {
    
    let mode : Mode
    @StateObject private var model = UserViewModel()
    @State var isLoading = true
    
    var body: some View {
        NavigationView {
            VStack {
                
                let friends = model.friends
                    .filter { friend in
                        friend.highscores?[mode.label] ?? nil != nil
                    }
                    .sorted { $0.highscores![mode.label]! > $1.highscores![mode.label]! }
                
                HStack {
                    Text(mode.name)
                        .font(TextStyle.homeTitle())
                        .padding()
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.leading)
                
                Image(mode.label)
                    .resizable()
                    .frame(width: 200.0, height: 200.0)
                    .scaledToFit()
                    .padding(.bottom)
                
                HStack{
                    Text("Your friends' highscore in this game mode!\nWho knows more about music?")
                        .font(TextStyle.leaderboardItem().bold())
                        .foregroundColor(Color.gray)
                    Spacer()
                }
                .padding(.leading)
                HStack(spacing: 20) {
                    if(!model.isLoading) {
                        Text("Your highscore: \(model.currentUser.highscores!["classic"]!)")
                            .font(TextStyle.leaderboardItem().bold())
                            .foregroundColor(.white)
                            .padding(.leading, 6.0)
                    } else {
                        Text("Your highscore:   ")
                            .font(TextStyle.leaderboardItem().bold())
                            .foregroundColor(.white)
                            .padding(.leading, 6.0)
                    }
                    
                    Spacer()
                    NavigationLink (destination: AddFriendsView() ,label: {
                        Image(systemName: "person.crop.circle.badge.plus")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color.gray)
                            .frame(width: 40.0, height: 40.0)
                    })
                    
                    NavigationLink (destination: GameView(mode: mode.label) ,label: {
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
                                    .padding(.trailing)
                            }
                            .listRowBackground(Color.clear)
                            .padding(.bottom)
                        }
                    }
                    //                .listStyle(.plain)
                    //                .background(Color.clear)
                    
                } else {
                    VStack {
                        Spacer()
                        Text("You have added no friends yet!")
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
            .background(Color("Black"))
            .task {
                print("TASK ModeView")
                model.updateUserData()
                try? await model.getFriends()
                try? await model.getUserHighscores()
                
//                print("CURRENT USER HIGHSCORES: \(model.currentUser.highscores!["classic"])")
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .toolbar(.hidden, for: .tabBar)
    }
}

//struct ModeView_Previews: PreviewProvider {
//    static var previews: some View {
//        ModeView()
//    }
//}