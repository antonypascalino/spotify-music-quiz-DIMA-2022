//
//  AuthorsScoreViewUITests.swift
//  spotify-music-quiz-mida-2022UITests
//
//  Created by Antony Pascalino on 12/07/23.
//

import XCTest
@testable import spotify_music_quiz_mida_2022 // Import your app's module

class AuthorScoreViewUITests: XCTestCase {
    
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
    
    func testAuthorScoreViewElements() throws {
        // Assuming the app initially displays the AuthorScoreView
        
        // Verify the presence of the "Authors score" title
        let authorsScoreTitle = app.staticTexts["Authors score"]
        XCTAssertTrue(authorsScoreTitle.exists, "The 'Authors score' title should be displayed")
        
        // Verify the presence of the description text
        let descriptionText = app.staticTexts["Look at the authors you know better!\nFor each correct answer you get a point!"]
        XCTAssertTrue(descriptionText.exists, "The description text should be displayed")
        
        // Verify the presence of the author and score pairs in the list
        let authorsScoresList = app.tables.firstMatch
        XCTAssertTrue(authorsScoresList.exists, "The authors scores list should be displayed")
        
        // Example: Verify the presence of a specific author and score pair
        let specificAuthorScore = app.staticTexts["John Doe: 5"]
        XCTAssertTrue(specificAuthorScore.exists, "The specific author and score pair should be displayed")
        
        // Example: Verify the presence of a specific message when no author scores are available
        let noScoresMessage = app.staticTexts["Sorry, you have not guessed any question yet"]
        XCTAssertTrue(noScoresMessage.exists, "The 'Sorry, you have not guessed any question yet' message should be displayed")
    }
}
