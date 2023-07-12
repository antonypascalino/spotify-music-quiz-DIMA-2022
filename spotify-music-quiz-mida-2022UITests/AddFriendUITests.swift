//
//  AddFriendUITests.swift
//  spotify-music-quiz-mida-2022UITests
//
//  Created by Antony Pascalino on 12/07/23.
//

import XCTest
@testable import spotify_music_quiz_mida_2022 // Import your app's module

class AddFriendsViewUITests: XCTestCase {
    
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
    
    func testAddFriendsViewElements() throws {
        // Assuming the app initially displays the AddFriendsView
        
        // Verify the presence of the "Click on" text
        let clickOnText = app.staticTexts["Click on"]
        XCTAssertTrue(clickOnText.exists, "The 'Click on' text should be displayed")
        
        // Verify the presence of the "plus.circle" image
        let plusCircleImage = app.images["plus.circle"]
        XCTAssertTrue(plusCircleImage.exists, "The 'plus.circle' image should be displayed")
        
        // Verify the presence of the "to add a friend to your leaderboard!" text
        let toAddFriendText = app.staticTexts["to add a friend to your leaderboard!"]
        XCTAssertTrue(toAddFriendText.exists, "The 'to add a friend to your leaderboard!' text should be displayed")
        
        // Verify the presence of the list of users
        let usersList = app.tables.firstMatch
        XCTAssertTrue(usersList.exists, "The list of users should be displayed")
        
        // Verify the presence of the search field
        let searchField = app.textFields.firstMatch
        XCTAssertTrue(searchField.exists, "The search field should be displayed")
        
        // Example: Verify the presence of a specific user in the list
        let specificUser = app.staticTexts["John Doe"]
        XCTAssertTrue(specificUser.exists, "The specific user should be displayed in the list")
        
    }
}
