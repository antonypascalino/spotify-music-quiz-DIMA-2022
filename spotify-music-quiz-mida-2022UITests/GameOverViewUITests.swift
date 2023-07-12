//
//  GameOverViewUITests.swift
//  spotify-music-quiz-mida-2022UITests
//
//  Created by Antony Pascalino on 12/07/23.
//

import XCTest
@testable import spotify_music_quiz_mida_2022 // Import your app's module

class GameOverViewUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        // Launch the app
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
        try super.tearDownWithError()
    }
    
    func testGameOverViewElements() throws {
        // Assuming the app initially displays the GameOverView
        
        // Verify the presence of the "Oh no!" title
        let ohNoTitle = app.staticTexts["Oh no!"]
        XCTAssertTrue(ohNoTitle.exists, "The 'Oh no!' title should be displayed")
        
        // Verify the presence of the score text
        let scoreText = app.staticTexts["Your score is:"]
        XCTAssertTrue(scoreText.exists, "The score text should be displayed")
        
        // Verify the presence of the actual score value
//        let scoreValue = app.staticTexts[String(gameManager.correctAnswersCount)]
//        XCTAssertTrue(scoreValue.exists, "The actual score value should be displayed")
        
        // Example: Verify the presence of the "It's your new highscore!" message when the score is a new highscore
        let newHighscoreMessage = app.staticTexts["It's your new highscore!"]
        XCTAssertTrue(newHighscoreMessage.exists, "The 'It's your new highscore!' message should be displayed")
    }
}
