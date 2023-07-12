//
//  FriendsViewUITests.swift
//  spotify-music-quiz-mida-2022UITests
//
//  Created by Antony Pascalino on 12/07/23.
//

import XCTest
@testable import spotify_music_quiz_mida_2022 // Import your app's module

class FriendsViewUITests: XCTestCase {
    
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
    
    func testFriendsViewElements() throws {
        // Assuming the app initially displays the FriendsView
        
        // Verify the presence of the "Friends" title
        let friendsTitle = app.staticTexts["Friends"]
        XCTAssertTrue(friendsTitle.exists, "The 'Friends' title should be displayed")
        
        // Verify the presence of the "Here is the list of all your friends!" text
        let friendsListText = app.staticTexts["Here is the list of all your friends!"]
        XCTAssertTrue(friendsListText.exists, "The 'Here is the list of all your friends!' text should be displayed")
        
        // Verify the presence of the "Click on" text
        let clickOnText = app.staticTexts["Click on"]
        XCTAssertTrue(clickOnText.exists, "The 'Click on' text should be displayed")
        
        // Verify the presence of the "person.crop.circle.badge.plus" image
        let addFriendsImage = app.images["person.crop.circle.badge.plus"]
        XCTAssertTrue(addFriendsImage.exists, "The 'person.crop.circle.badge.plus' image should be displayed")
        
        // Verify the presence of the "to add new friends!" text
        let addFriendsText = app.staticTexts["to add new friends!"]
        XCTAssertTrue(addFriendsText.exists, "The 'to add new friends!' text should be displayed")
        
        // Verify the presence of the NavigationLink
        let addFriendsNavigationLink = app.navigationBars.buttons["AddFriendsView"]
        XCTAssertTrue(addFriendsNavigationLink.exists, "The NavigationLink to AddFriendsView should be displayed")
        
        // Verify the presence of the user list or "You have added no friends yet!" text
        if app.tables.firstMatch.exists {
            // User list is present
            let userList = app.tables.firstMatch
            XCTAssertTrue(userList.exists, "The user list should be displayed")
        } else {
            // No friends added yet
            let noFriendsText = app.staticTexts["You have added no friends yet!"]
            XCTAssertTrue(noFriendsText.exists, "The 'You have added no friends yet!' text should be displayed")
        }
        
        // Example: Verify the presence of a specific user in the list
        let specificUser = app.staticTexts["pettorruso7"]
        XCTAssertTrue(specificUser.exists, "The specific user should be displayed in the list")
    }
}
