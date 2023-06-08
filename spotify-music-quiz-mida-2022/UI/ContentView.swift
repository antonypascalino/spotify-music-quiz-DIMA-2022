//
//  ContentView.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 07/06/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationView {
                HomeView()
            }
            .tabItem {
                Image(systemName: "house")
                Text("Home")
            }
            NavigationView {
                FriendsView(mode: "classic")
            }
            .tabItem {
                Image(systemName: "list.number")
                Text("Leaderboard")
            }
            NavigationView {
                AuthorScoreView()
            }
            .tabItem {
                Image(systemName: "music.note.list")
                Text("Authors scores")
            }
        }
        .accentColor(.white)
        .toolbar(.hidden, for: .tabBar, .navigationBar)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
