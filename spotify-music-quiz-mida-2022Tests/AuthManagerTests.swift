import XCTest
@testable import spotify_music_quiz_mida_2022

class AuthManagerTests: XCTestCase {
    
    var authManager: MockAuthManager!
    
    override func setUp() {
        super.setUp()
        authManager = MockAuthManager()
    }
    
    override func tearDown() {
        authManager = nil
        super.tearDown()
    }
    
    func testSignInURL() {
        let signInURL = authManager.signInURL
        XCTAssertNotNil(signInURL, "Sign in URL should not be nil")
    }
    
    func testIsSignedIn() {
        // Reset the access token
        UserDefaults.standard.set(nil, forKey: "access_token")

        print("SIGNED IN")
        XCTAssertFalse(authManager.isSignedIn, "User should not be signed in initially")
        
        // Simulate signing in by setting the access token
        UserDefaults.standard.set("dummy_access_token", forKey: "access_token")
        
        XCTAssertTrue(authManager.isSignedIn, "User should be signed in after setting the access token")
        
        
    }
    
    
    

    func testSignOut() {
        let expectation = self.expectation(description: "Sign out completion called")
        
        // Simulate signing in by setting the access token and refresh token
        UserDefaults.standard.set("dummy_access_token", forKey: "access_token")
        UserDefaults.standard.set("dummy_refresh_token", forKey: "refresh_token")
        UserDefaults.standard.set(Date().addingTimeInterval(3600), forKey: "expirationDate")
        
        authManager.signOut { success in
            XCTAssertTrue(success, "User should be successfully signed out")
            
            XCTAssertNil(UserDefaults.standard.string(forKey: "access_token"), "Access token should be cleared")
            XCTAssertNil(UserDefaults.standard.string(forKey: "refresh_token"), "Refresh token should be cleared")
            XCTAssertNil(UserDefaults.standard.object(forKey: "expirationDate"), "Expiration date should be cleared")
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    /*
    func testWithValidToken() {
        let expectation = self.expectation(description: "Valid token completion called")
        
        // Simulate signing in by setting the access token
        UserDefaults.standard.set("dummy_access_token", forKey: "access_token")
        
        authManager.withValidToken { token in
            XCTAssertEqual(token, "dummy_access_token", "Valid token should be returned")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }*/
}
