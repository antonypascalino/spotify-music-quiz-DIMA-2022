//
//  GameViewModel.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 10/05/23.
//

import Foundation

@MainActor
final class GameViewModel : ObservableObject {
    
//    @Published private(set) var nextQuestion : Question2()
    
    func startGame() {
        GameManager().startGame()
    }
    
    func getNextQuestion() -> Question2 {
        return GameManager().getNextQuestion()!
    } 
}
