//
//  ContentView.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 07/06/23.
//

import SwiftUI

struct ContentView: View {
    
    var apiCaller : APICaller!
    var userManager : UserManager!
    
    init(userManager: UserManager) {
        self.userManager = userManager
        self.apiCaller = APICaller(userManager: userManager, authManager: AuthManager())
    }
    
    var body: some View {
        NavigationStack {
            TabView {
                HomeView(apiCaller: apiCaller, userManager: userManager)
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                FriendsView(userManager: userManager)
                    .tabItem {
                        Image(systemName: "person.2")
                        Text("Friends")
                    }
                AuthorScoreView(userManager: userManager)
                    .tabItem {
                        Image(systemName: "music.note.list")
                        Text("Authors scores")
                    }
            }
            .accentColor(.white)
            .toolbar(.hidden, for: .tabBar, .navigationBar)
        }
        .toolbar(.hidden, for: .navigationBar)
        
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
