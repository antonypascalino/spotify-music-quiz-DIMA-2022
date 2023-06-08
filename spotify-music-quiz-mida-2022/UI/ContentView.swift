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
            HomeView()
            .tabItem {
                Image(systemName: "house")
                Text("Home")
            }
            AddFriendsView()
            .tabItem {
                Image(systemName: "person.2")
                Text("Friends")
            }
            AuthorScoreView()
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
