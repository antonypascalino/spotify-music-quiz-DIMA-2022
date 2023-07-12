//
//  QuestionManagerTests.swift
//  spotify-music-quiz-mida-2022Tests
//
//  Created by Antony Pascalino on 11/07/23.
//

import XCTest
@testable import spotify_music_quiz_mida_2022

class QuestionManagerTests: XCTestCase {
    
    var questionManager: MockQuestionManager!
    var userManager: UserManager!
    
    override func setUp() {
        super.setUp()
        // Inizializza le dipendenze necessarie
        questionManager = MockQuestionManager()

    }
    
    override func tearDown() {
        // Esegui operazioni di pulizia se necessario
        questionManager = nil
        super.tearDown()
    }
    
    func testGenRandomQuestions() async throws {
        // Esegui il test per il metodo genRandomQuestions
        // Testa il caso "whoIsTheAuthor"
        try await questionManager.importAllData()

            let whoIsAuthorQuestions = try await questionManager.genRandomQuestions(code: "whoIsTheAuthor", regenQuest: true)
        XCTAssertFalse(whoIsAuthorQuestions.isEmpty, "Failed to generate questions for code 'recallTheYear'")


        
        // Testa il caso "recallTheYear"
        let recallTheYearQuestions = try await questionManager.genRandomQuestions(code: "recallTheYear", regenQuest: true)
        // Verifica che sia stato generato un array di domande
        XCTAssertFalse(recallTheYearQuestions.isEmpty, "Failed to generate questions for code 'recallTheYear'")
        
        // Testa il caso "guessTheSong"
        let guessTheSongQuestions = try await questionManager.genRandomQuestions(code: "guessTheSong", regenQuest: true)
        // Verifica che sia stato generato un array di domande
        XCTAssertFalse(guessTheSongQuestions.isEmpty, "Failed to generate questions for code 'guessTheSong'")
        
        // Testa il caso "guessTheSinger"
        let guessTheSingerQuestions = try await questionManager.genRandomQuestions(code: "guessTheSinger", regenQuest: true)
        // Verifica che sia stato generato un array di domande
        XCTAssertFalse(guessTheSingerQuestions.isEmpty, "Failed to generate questions for code 'guessTheSinger'")
        
        // Testa il caso "authorSong"
        let authorSongQuestions = try await questionManager.genRandomQuestions(code: "authorSong", regenQuest: true)
        // Verifica che sia stato generato un array di domande
        XCTAssertFalse(authorSongQuestions.isEmpty, "Failed to generate questions for code 'authorSong'")
        
        // Testa il caso "whichAlbum"
        let whichAlbumQuestions = try await questionManager.genRandomQuestions(code: "whichAlbum", regenQuest: true)
        // Verifica che sia stato generato un array di domande
        XCTAssertFalse(whichAlbumQuestions.isEmpty, "Failed to generate questions for code 'whichAlbum'")
        
        // Testa il caso "classic"
        let classicQuestions = try await questionManager.genRandomQuestions(code: "classic", regenQuest: true)
        // Verifica che sia stato generato un array di domande
        XCTAssertFalse(classicQuestions.isEmpty, "Failed to generate questions for code 'classic'")
        
        // Testa il caso "home"
        let homeQuestions = try await questionManager.genRandomQuestions(code: "home", regenQuest: true)
        // Verifica che sia stato generato un array di domande
        XCTAssertFalse(homeQuestions.isEmpty, "Failed to generate questions for code 'home'")
    }
    
    func testGenAllQuestions() async throws {
        
        try await questionManager.importAllData()

        let allQuestions = try await questionManager.genAllQuestions()
        
        // Verifica che sia stato generato un array di domande
        XCTAssertFalse(allQuestions.isEmpty, "Failed to generate all questions")
    }
    
    
}

