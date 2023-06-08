//
//  User.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 29/03/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore

struct User : Identifiable, Codable {
    
    @DocumentID var id : String?
    var authors : [String : Int]?
    var highscores : [String : Int]?
    var display_name : String
    var email : String
    var friends : [DocumentReference]
    var highscore : Int
    var SpotifyID : String
    var image : String
}
