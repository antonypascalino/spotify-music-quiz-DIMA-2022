//
//  AuthManager.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 27/03/23.
//

import Foundation

protocol AuthManagerProtocol {
    func withValidToken(completion: @escaping ((String)->Void))
    func refreshIfNeeded(completion: @escaping (Bool) -> Void)
    func exchangeCodeForToken(
        code : String,
        completion: @escaping ((Bool)->Void)
    )
    func cacheToken(result: AuthResponse)
    func signOut(completion: (Bool)-> Void)
}


class AuthManager : AuthManagerProtocol {
    
    struct Constants {
        static let clientID = "a92e939475fa48619185a62b70173a45"
        static let clientSecret = "d4d235cc683942778dcd68a445935671"
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
        static let redirectURI = "https://localhost:8888/callback"
        //static let scopes = "user-read-private"
        static let scopes =
        "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email%20user-top-read"
    }
    
    public var signInURL : URL? {
        let base = "https://accounts.spotify.com/authorize"
        let string = "\(base)?response_type=code&client_id=\(AuthManager.Constants.clientID)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURI)&show_dialog=TRUE"
        return URL(string: string)
    }
    
    private var refreshingToken: Bool = false
    
    var isSignedIn: Bool {
        return accessToken != nil
    }
    
    private var accessToken : String? {
        return UserDefaults.standard.string(forKey : "access_token")
    }
    
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    private var shouldRefreshToken: Bool {
        guard let expirationDate = tokenExpirationDate else {
            return true
        }
        let currentDate = Date()
        let fiveMinutes: TimeInterval = 300
        return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate
    }
    
    private var onRefreshBlock = [((String)->Void)]()
    
    public func withValidToken(completion: @escaping ((String)->Void)) {
        guard !refreshingToken else{
            onRefreshBlock.append(completion)
            return
        }
        
        if shouldRefreshToken{
            refreshIfNeeded {[weak self] success in
                if let token = self?.accessToken, success{
                    completion(token)
                }
            }
        } else if let token = accessToken{
            print("token: \(token)")
            completion(token)
        }
    }
    
    public func refreshIfNeeded(completion: @escaping (Bool) -> Void) {
        
        guard !refreshingToken else {
            return
        }
        
        guard shouldRefreshToken else {
            completion(true)
            return
        }
        guard let refreshToken = self.refreshToken else { return }
        
        guard let url = URL(string: Constants.tokenAPIURL) else { return }
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name : "grant_type",
                         value : "refresh_token"),
            URLQueryItem(name : "refresh_token",
                         value : refreshToken),
            
        ]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField : "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        let basicToken = Constants.clientID + ":" + Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("failure")
            completion(false)
            return
        }
        
        request.setValue("Basic \(base64String)", forHTTPHeaderField : "Authorization")
        
        let task = URLSession.shared.dataTask(with : request) { data, URLResponse, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            
            
            do{
                let result = try JSONDecoder().decode(AuthResponse.self,
                                                      from: data)
                print("Refresh Ok")
                self.cacheToken(result: result) //PRIMA C'ERA UN ? DOPO self
                completion(true)
            }catch{
                print(error.localizedDescription)
                completion(false)
            }
        }
        task.resume()
    }
    
    public func exchangeCodeForToken(code : String, completion: @escaping ((Bool)->Void)) {
        guard let url = URL(string: Constants.tokenAPIURL) else { return }
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name : "grant_type",
                         value : "authorization_code"),
            URLQueryItem(name : "code",
                         value : code),
            URLQueryItem(name : "redirect_uri",
                         value : Constants.redirectURI),
            
        ]
        print("code: \(code)")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField : "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        let basicToken = Constants.clientID + ":" + Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("failure")
            completion(false)
            return
        }
        
        request.setValue("Basic \(base64String)", forHTTPHeaderField : "Authorization")
        
        let task = URLSession.shared.dataTask(with : request) { data, URLResponse, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            
            
            do{
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self.cacheToken(result: result)
                completion(true)
                //                print("TOKEN: \(result)")
            }catch{
                print(error.localizedDescription)
                completion(false)
            }
        }
        task.resume()
    }
    
    internal func cacheToken(result: AuthResponse) {
        UserDefaults.standard.set(result.access_token,
                                  forKey: "access_token")
        
        if let refresh_token = result.refresh_token {
            UserDefaults.standard.set(result.refresh_token,
                                      forKey: "refresh_token")
        }
        
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)),
                                       forKey: "expirationDate")
    }
    
    public func signOut(completion: (Bool)-> Void) {
        UserDefaults.standard.setValue(nil, forKey: "access_token")
        print("accessToken: \(String(describing: accessToken))")
        UserDefaults.standard.setValue(nil, forKey: "refresh_token")
        print("refreshToken: \(String(describing: refreshToken))")
        UserDefaults.standard.setValue(nil, forKey: "expirationDate")
        print("tokenExpirationDate: \(String(describing: tokenExpirationDate))")
        completion(true)
    }
}
