//
//  MockAuthManager.swift
//  spotify-music-quiz-mida-2022Tests
//
//  Created by Antony Pascalino on 26/06/23.
//

import Foundation
@testable import spotify_music_quiz_mida_2022

final class MockAuthManager: AuthManagerProtocol, Mockable {
    
    func withValidToken(completion: @escaping ((String) -> Void)) {
        
    }
    
    func refreshIfNeeded(completion: @escaping (Bool) -> Void) {
        
    }
    
    func exchangeCodeForToken(code: String, completion: @escaping ((Bool) -> Void)) {
        
        let result = loadJSON(filename: "AuthResponse", type: AuthResponse.self)
        self.cacheToken(result: result)
        completion(true)
    }
    
    func cacheToken(result: AuthResponse) {
        UserDefaults.standard.set(result.access_token,
                                  forKey: "access_token")
        
        if let refresh_token = result.refresh_token {
            UserDefaults.standard.set(result.refresh_token,
                                      forKey: "refresh_token")
        }
        
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)),
                                       forKey: "expirationDate")
    }
    
    func signOut(completion: (Bool) -> Void) {
        
    }
}
