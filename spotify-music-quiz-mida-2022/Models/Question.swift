//
//  Question.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 22/03/23.
//

import Foundation

struct Question {
    var question = ""
    var rightAns = ""
    var answers : [String]

    init(question: String, rightAns: String, wrongAns1: String, wrongAns2: String, wrongAns3: String) {
        self.question = question
        self.rightAns = rightAns
        answers = []
        answers.append(rightAns)
        answers.append(wrongAns1)
        answers.append(wrongAns2)
        answers.append(wrongAns3)
        answers.shuffle();
    }
    
    func isRight (answer: String) -> Bool {
        if answer == rightAns {
            return true
        } else {
            return false
        }
    }
}
