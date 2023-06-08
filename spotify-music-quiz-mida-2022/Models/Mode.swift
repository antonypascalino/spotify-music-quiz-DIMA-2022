//
//  Mode.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 08/06/23.
//

import Foundation
import SwiftUI

struct Mode {
    let name : String
    let label : String
    let color : Color
    let description : String
    
    static let modes : [Mode] = [
        Mode(name: "Classic", label: "classic", color: Color("Green"), description: "All kind of questions"),
        Mode(name: "Guess the song", label: "guessTheSong", color: .yellow, description: "Listen! Know the title?"),
        Mode(name: "Guess the singer", label: "guessTheSinger", color: .indigo, description: "Listen! Who is singing?"),
        Mode(name: "Recall the year", label: "recallTheYear", color: .orange, description: "When was it released?"),
        Mode(name: "Which album", label: "whichAlbum", color: .brown, description: "In which album was it?"),
        Mode(name: "Who is the author", label: "whoIsTheAuthor", color: .yellow, description: "Who sings that song?"),
        Mode(name: "Author song", label: "authorSong", color: .blue, description: "Which song they sing?")
    ]
}


