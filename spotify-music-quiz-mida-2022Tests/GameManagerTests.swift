//
//  GameManagerTests.swift
//  spotify-music-quiz-mida-2022Tests
//
//  Created by Antony Pascalino on 07/07/23.
//

import XCTest
@testable import spotify_music_quiz_mida_2022 // Importa il nome corretto della tua app

class GameManagerTests: XCTestCase {
    
    var gameManager: MockGameManager!
    
    override func setUp() {
        super.setUp()
        let questionManager = MockQuestionManager()
        gameManager = MockGameManager(questionManager: questionManager)
    }
    
    override func tearDown() {
        gameManager = nil
        super.tearDown()
    }
    
    func testStartGame() async {
        let codeQuestion = "whoIsTheAuthor" // Codice di domanda di esempio
        
        XCTAssertFalse(gameManager.gameIsOver)
        XCTAssertFalse(gameManager.playerMiss)
        XCTAssertFalse(gameManager.answerSelected)
        XCTAssertEqual(gameManager.correctAnswersCount, 0)
        
        do {
            try await gameManager.startGame(codeQuestion: codeQuestion)
            
            XCTAssertFalse(gameManager.gameIsOver)
            XCTAssertFalse(gameManager.playerMiss)
            XCTAssertFalse(gameManager.answerSelected)
            XCTAssertEqual(gameManager.correctAnswersCount, 0)
            XCTAssertEqual(gameManager.currentQuestionIndex, 0)
            XCTAssertNotNil(gameManager.currentQuestion)
            XCTAssertNotNil(gameManager.currentAnswers)
            XCTAssertEqual(gameManager.currentAnswers?.count, 4) // Assumendo che ci siano 4 risposte possibili per ogni domanda
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testSelectAnswer() async {
        // Assicurati che ci sia almeno una domanda disponibile nel gameManager prima di eseguire questo test
        guard let question = gameManager.getNextQuestion() else {
            do {
                try await gameManager.startGame(codeQuestion: "whoIsTheAuthor")
            } catch {
                XCTFail("Unexpected error: \(error)")
            }
            return
        }
        
        //let isCorrectAnswer = question.correctAnswer // Assumendo che l'opzione corretta sia la prima nella lista delle risposte
        let isCorrectAnswer = true
        
        let initialCorrectAnswersCount = gameManager.correctAnswersCount
        
        gameManager.selectAnswer(isCorrectAnswer)
        
        XCTAssertTrue(gameManager.answerSelected)
        
        if isCorrectAnswer {
            XCTAssertEqual(gameManager.correctAnswersCount, initialCorrectAnswersCount + 1)
        } else {
            XCTAssertTrue(gameManager.playerMiss)
        }
    }
    
    func testSetNextQuestion() async throws {
        
        gameManager.questions = []
        gameManager.tempQuestions = []
        
        let codeQuestion = "whoIsTheAuthor" // Codice di domanda di esempio
        
        do {
            try await gameManager.startGame(codeQuestion: codeQuestion)
            
            XCTAssertFalse(gameManager.questions.isEmpty)
            XCTAssertEqual(gameManager.currentQuestionIndex, 0)
            XCTAssertNotNil(gameManager.currentQuestion)
            XCTAssertNotNil(gameManager.currentAnswers)
            
            gameManager.selectAnswer(true)
            
            XCTAssertEqual(gameManager.correctAnswersCount, 1)
            
            try await gameManager.setNextQuestion()
            
            await waitForExpectations(timeout: 5) { error in
                if let error = error {
                    XCTFail("Timeout: \(error)")
                } else {
                    XCTAssertEqual(self.gameManager.currentQuestionIndex, 1)
                    XCTAssertNotNil(self.gameManager.currentQuestion)
                    XCTAssertNotNil(self.gameManager.currentAnswers)
                }
            }
            
            
            gameManager.selectAnswer(true)
            
            
            
            XCTAssertEqual(gameManager.correctAnswersCount, 2)
            
            try await gameManager.setNextQuestion()
            
            await waitForExpectations(timeout: 5) { error in
                if let error = error {
                    XCTFail("Timeout: \(error)")
                } else {
                    XCTAssertEqual(self.gameManager.currentQuestionIndex, 2)
                    XCTAssertNotNil(self.gameManager.currentQuestion)
                    XCTAssertNotNil(self.gameManager.currentAnswers)
                }
            }
            
            
            
            gameManager.selectAnswer(true)
            
            XCTAssertEqual(gameManager.correctAnswersCount, 3)
            
            try await gameManager.setNextQuestion()
            
            await waitForExpectations(timeout: 5) { error in
                if let error = error {
                    XCTFail("Timeout: \(error)")
                } else {
                    XCTAssertEqual(self.gameManager.currentQuestionIndex, 0)
                    XCTAssertNotNil(self.gameManager.currentQuestion)
                    XCTAssertNotNil(self.gameManager.currentAnswers)
                    XCTAssertTrue(self.gameManager.questions.isEmpty)
                    XCTAssertFalse(self.gameManager.tempQuestions.isEmpty)
                }
            }
            
            
            
        }
        
    }
    
}
