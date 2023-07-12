//
//  GameVIewUITests.swift
//  spotify-music-quiz-mida-2022UITests
//
//  Created by Antony Pascalino on 12/07/23.
//

import XCTest
@testable import spotify_music_quiz_mida_2022 // Import your app's module

class GameViewUITests: XCTestCase {
    
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
    
    func testGameViewElements() throws {
        // Assuming the app initially displays the GameView
        
        // Verify the presence of the score text
        let scoreText = app.staticTexts["Score:"]
        XCTAssertTrue(scoreText.exists, "The score text should be displayed")
    }
}
