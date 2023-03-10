//
//  spotify_music_quiz_mida_2022App.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 19/12/22.
//

import SwiftUI

@main
struct spotify_music_quiz_mida_2022App: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationView {
                    HomeView()
                }
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                NavigationView {
                    //SearchView()
                }
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
                NavigationView {
                    //AboutUsView()
                }
                .tabItem {
                    Image(systemName: "info.circle")
                    Text("About us")
                }
            }
        }
    }
}
