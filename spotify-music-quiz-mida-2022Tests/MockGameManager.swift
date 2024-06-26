//
//  MockAuthManager.swift
//  spotify-music-quiz-mida-2022Tests
//
//  Created by Antony Pascalino on 26/06/23.
//

import Foundation
@testable import spotify_music_quiz_mida_2022

final class MockGameManager: GameManagerProtocol, Mockable {
    
    let questionManager : MockQuestionManager!
    
     var questions: [Question] = []
     var tempQuestions: [Question] = []
    private(set) var currentQuestion : Question?
    private(set) var currentAnswers : [String]?
    private(set) var gameIsOver = false
    private(set) var playerMiss = false
    private(set) var codeQuestion = ""
    @Published private(set) var isTimerRunning = true
    @Published private(set) var currentQuestionIndex = 0
    @Published private(set) var correctAnswersCount = 0
    @Published private(set) var answerSelected = false
    var restartGame = true
    
    
    init(questionManager : MockQuestionManager) {
        self.questionManager = questionManager
    }
    
    func startGame(codeQuestion: String) async throws {
        self.restartGame = false
        self.codeQuestion = codeQuestion
//        if(questions.count == 0 || correctAnswersCount != 0) {
        try await resetGame()
        questionManager.isLoadingQuestions = true
        try await questionManager.importAllData()
        print("Start Game")
        try await self.genQuestions(codeQuestion: codeQuestion, regenQuest : true)
        
//        }
    }
    
    func genQuestions(codeQuestion: String, regenQuest : Bool) async throws {
//        print("GEN QUESTION: QUESTION COUNT: \(questions.count) Answer Count: \(correctAnswersCount)")
//            if(questions.count == 0 || correctAnswersCount != 0) {
//            tempQuestions = []
//            questions = []
        questions = try await questionManager.genRandomQuestions(code: codeQuestion, regenQuest: regenQuest)
            print("Question generated: \(questions.count)")
            questions.shuffle()
            DispatchQueue.main.async {
                self.currentQuestionIndex = 0
                //self.correctAnswersCount = 0 //is necessary?
                self.currentQuestion = self.questions[self.currentQuestionIndex]
                self.currentAnswers = self.currentQuestion?.getAnswers()
            }
       // }
        questionManager.isLoadingQuestions = false

        
    }
    func restartGame(codeQuestion: String, regenQuest: Bool) async throws {
        self.codeQuestion = codeQuestion
        self.restartGame = true
        try await resetGame()
        questionManager.isLoadingQuestions = true
        try await genQuestions(codeQuestion: codeQuestion, regenQuest: regenQuest)
    }
    
    func startMiniGame(codeQuestion: String, regenQuest: Bool) async throws {
        self.codeQuestion = codeQuestion
        print("MiniGame")
        questionManager.isLoadingQuestions = true
        try await genQuestions(codeQuestion: codeQuestion, regenQuest: regenQuest)
    }
    
    func resetGame() async throws {
        
        self.questions = []
        DispatchQueue.main.async {
            self.gameIsOver = false
            self.playerMiss = false
            self.answerSelected = false
            self.correctAnswersCount = 0
        }
        print("RESET GAME")
    }
    
    func setNextQuestion() async throws {
        DispatchQueue.main.async {
            self.answerSelected = false
        }
        
        if (playerMiss) {
            gameOver()
        } else {
            
            // Only setting next question if index is smaller than the number of questions set
            print("Current question index : \(currentQuestionIndex), question.count: \(questions.count)")
            if currentQuestionIndex < questions.count - 1 {
                DispatchQueue.main.async {
                    self.currentQuestionIndex += 1
                    self.currentQuestion = self.questions[self.currentQuestionIndex]
                    self.currentAnswers = self.currentQuestion?.getAnswers() ?? [String]()
                }
                    if (currentQuestionIndex == (questions.count/2))  {
                        print("CURRENT INDEX: \(currentQuestionIndex)")
                        tempQuestions = try await questionManager.genRandomQuestions(code: self.codeQuestion, regenQuest: true)
                    }

            } else {
                print("Reload questions")
                DispatchQueue.main.async {
                    self.questions = []
                    self.questions = self.tempQuestions
                    self.tempQuestions = []
                    //questions = try await QuestionManager.shared.genRandomQuestions()
                    self.questions.shuffle()
                    self.currentQuestionIndex = 0
                    print("Questions.count: \(self.questions.count)")
                    //self.correctAnswersCount = 0 //is necessary?
                    self.currentQuestion = self.questions[self.currentQuestionIndex]
                    self.currentAnswers = self.currentQuestion?.getAnswers()
                }
            }
        }
        
    }
    
    func getNextQuestion() -> Question? {
//        print("Risposta esatta: \(currentQuestion?.correctAnswer)")
        return currentQuestion
    }
    
    func gameOver() {
        gameIsOver = true
    }
    
    func selectAnswer(_ isCorrect : Bool) {
        
        answerSelected = true
        
        let currentQuestion = questions[currentQuestionIndex]
        if isCorrect {
            correctAnswersCount += 1
            
        } else {
            playerMiss = true
        }
    }
    
    func pauseTimer() {
        isTimerRunning = false
    }
        
    func resumeTimer() {
        isTimerRunning = true
    }
}
