//
//  AuthManager.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 27/03/23.
//

import Foundation

class AuthManager {
    
    static let shared = AuthManager()
    
    struct Constants {
        static let clientID = "a92e939475fa48619185a62b70173a45"
        static let clientSecret = "d4d235cc683942778dcd68a445935671"
    }
    
    private init() {}
    
    public var signInURL : URL? {
        let scopes = "user-read-private"
        let redirectURI = "https://localhost:8888/callback"
        let base = "https://accounts.spotify.com/authorize"
        let string = "\(base)?response_type=code&client_id=\(AuthManager.Constants.clientID)&scope=\(scopes)&redirect_uri=\(redirectURI)&show_dialog=TRUE"
        return URL(string: string)
    }
    
    public func exchangeCodeForToken(
        code : String,
        completion: @escaping ((Bool)->Void)
    ){
        //Token
    }
}
