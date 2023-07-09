//
//  GameManagerTests.swift
//  spotify-music-quiz-mida-2022Tests
//
//  Created by Antony Pascalino on 07/07/23.
//

import XCTest
@testable import spotify_music_quiz_mida_2022 // Importa il nome corretto della tua app

class GameManagerTests: XCTestCase {

    var gameManager: GameManager!
    
    override func setUp() {
        super.setUp()
        let userManager = UserManager()
        let apiCaller = APICaller(userManager: userManager, authManager: AuthManager())
        let questionManager = QuestionManager(apiCaller: apiCaller, userManager: userManager)
        
        gameManager = GameManager(userManager: userManager, questionManager: questionManager)
    }
    
    override func tearDown() {
        gameManager = nil
        super.tearDown()
    }
    
    func testStartGame() async {
        let codeQuestion = "ABC" // Codice di domanda di esempio
        
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
    
    func testSelectAnswer() {
        // Assicurati che ci sia almeno una domanda disponibile nel gameManager prima di eseguire questo test
        guard let question = gameManager.getNextQuestion() else {
            XCTFail("No question available")
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
    
    // Aggiungi altri test secondo le tue esigenze
    func testSetNextQuestion() async throws {
        // Assicurati che l'array delle domande sia vuoto prima di eseguire questo test
        
        gameManager.questions = []
        gameManager.tempQuestions = []
        
        let codeQuestion = "ABC" // Codice di domanda di esempio
        
        do {
            try await gameManager.startGame(codeQuestion: codeQuestion)
            
            // Verifica che l'array delle domande sia stato generato e che la domanda corrente sia impostata correttamente
            XCTAssertFalse(gameManager.questions.isEmpty)
            XCTAssertEqual(gameManager.currentQuestionIndex, 0)
            XCTAssertNotNil(gameManager.currentQuestion)
            XCTAssertNotNil(gameManager.currentAnswers)
            
            // Simula la risposta corretta alla domanda corrente
            gameManager.selectAnswer(true)
            
            // Verifica che la risposta sia stata conteggiata come corretta
            XCTAssertEqual(gameManager.correctAnswersCount, 1)
            
            // Simula la risposta corretta alla domanda corrente
            gameManager.selectAnswer(true)
            
            // Verifica che la domanda corrente sia passata alla successiva
            XCTAssertEqual(gameManager.currentQuestionIndex, 1)
            XCTAssertNotNil(gameManager.currentQuestion)
            XCTAssertNotNil(gameManager.currentAnswers)
            
            // Simula la risposta corretta alla domanda corrente
            gameManager.selectAnswer(true)
            
            // Verifica che la risposta sia stata conteggiata come corretta
            XCTAssertEqual(gameManager.correctAnswersCount, 2)
            
            // Simula la risposta corretta alla domanda corrente
            gameManager.selectAnswer(true)
            
            // Verifica che la domanda corrente sia passata alla successiva
            XCTAssertEqual(gameManager.currentQuestionIndex, 2)
            XCTAssertNotNil(gameManager.currentQuestion)
            XCTAssertNotNil(gameManager.currentAnswers)
            
            // Simula la risposta corretta alla domanda corrente
            gameManager.selectAnswer(true)
            
            // Verifica che la risposta sia stata conteggiata come corretta
            XCTAssertEqual(gameManager.correctAnswersCount, 3)
            
            // Simula la risposta corretta alla domanda corrente
            gameManager.selectAnswer(true)
            
            // Verifica che tutte le domande siano state completate e che la generazione di nuove domande sia avvenuta correttamente
            XCTAssertEqual(gameManager.currentQuestionIndex, 0)
            XCTAssertNotNil(gameManager.currentQuestion)
            XCTAssertNotNil(gameManager.currentAnswers)
            XCTAssertTrue(gameManager.questions.isEmpty)
            XCTAssertFalse(gameManager.tempQuestions.isEmpty)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

}

