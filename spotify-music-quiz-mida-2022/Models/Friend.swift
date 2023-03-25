//
//  Friend.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 22/03/23.
//

import Foundation

struct Friend : Identifiable {
    
    var id = UUID()
    var name: String
    var image: String
    var highscore: Int
}
