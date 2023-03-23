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
        let redirectURI = ""
        let base = "https://accounts.spotify.com/authorize"
        let string = "\(base)?response_type=code&client_id=\(Costants.clientID)&scope=\(scopes)&redirect_uri=\(redirectURI)&show_dialog=TRUE" 
        return URL(string: String)
    } 

/*
    private let authSession = ASWebAuthenticationSession(
        url: URL(string: "https://accounts.spotify.com/authorize?client_id=CLIENT_ID&response_type=code&redirect_uri=REDIRECT_URI&scope=SCOPE"),
        callbackURLScheme: "SPOTIFY_CALLBACK_URL_SCHEME",
        completionHandler: { (callbackURL: URL?, error: Error?) in
            guard error == nil, let callbackURL = callbackURL else {
                print("Authentication failed: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            let queryItems = URLComponents(string: callbackURL.absoluteString)?.queryItems
            guard let code = queryItems?.first(where: { $0.name == "code" })?.value else {
                print("Authentication failed: No code found in callback URL")
                return
            }
            // Use the code to request an access token from the Spotify API
            // ...
        }
    )
    
    func authenticate() {
        authSession.presentationContextProvider = self
        authSession.start()
    }
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return UIApplication.shared.keyWindow!
    }
}*/

    public func exchangeCodeForToken(
        code : String,
        completion: @escaping ((Bool)->Void)
    ){
        //Token
    }
}
