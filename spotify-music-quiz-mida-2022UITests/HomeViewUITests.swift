//
//  HomeViewTest.swift
//  spotify-music-quiz-mida-2022UITests
//
//  Created by Antony Pascalino on 11/07/23.
//

import XCTest
@testable import spotify_music_quiz_mida_2022 // Import your app's module

class HomeViewUITests: XCTestCase {
    
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
    
    func testHomePageElements() throws {
        
        
        // Assuming the app initially displays the Home Page
        let loginViewUITests = LoginViewUITests()
        try loginViewUITests.setUpWithError()
        try loginViewUITests.testSignIn()
        // Verify the high score is displayed within 20 seconds
        let highScoreLabelExpectation = XCTNSPredicateExpectation(predicate: NSPredicate(format: "exists == true"), object: app.staticTexts["Highscore:"])
        let highScoreLabelResult = XCTWaiter().wait(for: [highScoreLabelExpectation], timeout: 20)
        XCTAssertEqual(highScoreLabelResult, .completed, "High score label should be displayed within 20 seconds")

        // Verify the user's profile picture is shown within 20 seconds
        let profilePictureExpectation = XCTNSPredicateExpectation(predicate: NSPredicate(format: "exists == true"), object: app.images.matching(identifier: "profileImage").firstMatch)
        let profilePictureResult = XCTWaiter().wait(for: [profilePictureExpectation], timeout: 20)
        XCTAssertEqual(profilePictureResult, .completed, "Profile picture should be displayed within 20 seconds")

        // Verify the "Let's play!" text is present within 20 seconds
        let letsPlayTextExpectation = XCTNSPredicateExpectation(predicate: NSPredicate(format: "exists == true"), object: app.staticTexts["Let's play!"])
        let letsPlayTextResult = XCTWaiter().wait(for: [letsPlayTextExpectation], timeout: 20)
        XCTAssertEqual(letsPlayTextResult, .completed, "'Let's play!' text should be displayed within 20 seconds")

        // Verify the presence of game mode buttons within 20 seconds
        let classicModeButtonExpectation = XCTNSPredicateExpectation(predicate: NSPredicate(format: "exists == true"), object: app.buttons.matching(identifier: "ClassicModeButton").firstMatch)
        let classicModeButtonResult = XCTWaiter().wait(for: [classicModeButtonExpectation], timeout: 20)
        XCTAssertEqual(classicModeButtonResult, .completed, "Classic mode button should be displayed within 20 seconds")

        // Test the Log Out button within 20 seconds
        let logOutButtonExpectation = XCTNSPredicateExpectation(predicate: NSPredicate(format: "exists == true"), object: app.buttons.matching(identifier: "LogOutButton").firstMatch)
        let logOutButtonResult = XCTWaiter().wait(for: [logOutButtonExpectation], timeout: 20)
        XCTAssertEqual(logOutButtonResult, .completed, "Log Out button should be displayed within 20 seconds")

        // Tap the Log Out button and verify the alert is shown within 20 seconds
        app.buttons.matching(identifier: "LogOutButton").firstMatch.tap()

        let logOutAlertExpectation = XCTNSPredicateExpectation(predicate: NSPredicate(format: "exists == true"), object: app.alerts["Log Out"])
        let logOutAlertResult = XCTWaiter().wait(for: [logOutAlertExpectation], timeout: 20)
        XCTAssertEqual(logOutAlertResult, .completed, "Log Out alert should be displayed within 20 seconds")

        // Dismiss the Log Out alert
        app.alerts["Log Out"].buttons["Cancel"].tap()

        // Verify tapping a game mode button navigates to ModeView within 20 seconds
        let modeViewExpectation = XCTNSPredicateExpectation(predicate: NSPredicate(format: "exists == true"), object: app.navigationBars["ModeView"])
//        classicModeButton.tap()
        let modeViewResult = XCTWaiter().wait(for: [modeViewExpectation], timeout: 20)
        XCTAssertEqual(modeViewResult, .completed, "Navigation to ModeView should occur within 20 seconds")
    }
}

