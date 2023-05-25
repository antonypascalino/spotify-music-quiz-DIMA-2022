//
//  spotify_music_quiz_mida_2022App.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 19/12/22.
//

import SwiftUI
import FirebaseCore

@main
struct spotify_music_quiz_mida_2022App: App {
    
    init() {
        FirebaseApp.configure()
        print("Firebase configured")
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                LoginView()
            }
            .statusBar(hidden: true)
            .preferredColorScheme(.dark)
        }
    }
}
