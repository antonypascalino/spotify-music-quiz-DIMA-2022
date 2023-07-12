//
//  ModeViewUITests.swift
//  spotify-music-quiz-mida-2022UITests
//
//  Created by Antony Pascalino on 12/07/23.
//

import XCTest
@testable import spotify_music_quiz_mida_2022 // Import your app's module

class ModeViewUITests: XCTestCase {
    
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
    
    func testModeViewElements() throws {
        // Example: Verify the presence of the highscore text
        let highscoreText = app.staticTexts["Your highscore:"]
        XCTAssertTrue(highscoreText.exists, "The highscore text should be displayed")
        
        // Verify the presence of the friends' highscores
        let friendsHighscores = app.staticTexts.matching(identifier: "FriendsHighscore").allElementsBoundByIndex
        XCTAssertFalse(friendsHighscores.isEmpty, "The friends' highscores should be displayed")
        
        // Verify the presence of the friend list
        let friendList = app.tables.matching(identifier: "FriendList").firstMatch
        XCTAssertTrue(friendList.exists, "The friend list should be displayed")
    }
}
