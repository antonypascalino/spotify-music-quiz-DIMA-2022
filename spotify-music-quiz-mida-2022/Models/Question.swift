//
//  Question.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 22/03/23.
//

import Foundation

struct Question : Equatable {
    let id = UUID()
    let questionText: String?
    let correctAnswer: String
    var isShazam = false
    var songUrl : String? = nil
    var albumImage : String? = nil
    var author : String? = nil
    var songName : String? = nil
    let wrongAnswers: [String]
    
    func isCorrect(_ answer: String) -> Bool {
        return answer == correctAnswer
    }
    
    func getAnswers() -> [String] {
        var answers : [String] = []
        answers.append(correctAnswer)
        answers.append(contentsOf: wrongAnswers)
        answers.shuffle()
        
        return answers
    }
}
