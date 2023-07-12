//
//  LoginViewTest.swift
//  spotify-music-quiz-mida-2022UITests
//
//  Created by Antony Pascalino on 12/07/23.
//

import XCTest

class LoginViewUITests: XCTestCase {
    
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
    
    func testSignIn() throws {
        // Verify if the Sign In button exists
        let signInButton = app.buttons["Sign in"]
        XCTAssertTrue(signInButton.exists, "Sign In button should exist")
        
        // Tap on the Sign In button
        signInButton.tap()
        
        // Wait for the WebView to appear
        let webView = app.webViews.firstMatch
        XCTAssertTrue(webView.waitForExistence(timeout: 10), "WebView should appear within 10 seconds")
        
        // Enter email and password in the respective text fields
        let emailField = webView.textFields["Indirizzo e-mail o nome utente"]
        if emailField.exists {
            XCTAssertTrue(emailField.exists, "Email field should be present in the WebView")
            emailField.tap()
            emailField.typeText("55antony99@gmail.com")
            
            let passwordField = webView.secureTextFields["Password"]
            XCTAssertTrue(passwordField.exists, "Password field should be present in the WebView")
            passwordField.tap()
            passwordField.typeText("COCOLAND")
            
            // Tap the login button
            let loginButton = webView.buttons["Accedi"]
            XCTAssertTrue(loginButton.exists, "Login button should be present in the WebView")
            loginButton.tap()
        }
        // Scroll to the end of the WebView
        let acceptButton = webView.buttons["ACCETTO"]
        XCTAssertTrue(acceptButton.exists, "Accept button should be present in the WebView")
        acceptButton.tap()
    }
}
