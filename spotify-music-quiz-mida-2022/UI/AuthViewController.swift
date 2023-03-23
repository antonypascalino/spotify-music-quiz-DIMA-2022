import UIKit
import WebKit

class AuthViewController: UIViewController, WKNavigationDelegate {
    
    
    var webView: WKWebView = {

        let prefs = WKWebpagePreferences()
        prefs.allowContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defualtWebpagePreferences = prefs
        webView = WKWebView(frame: frame = .zero, configuration : config)
        
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In"

        //background miss

        webView.navigationDelegate = self
        view.addSubview(webView)
        
        guard let url = AuthManager.shared.signInURL else { return }
        webView.load(URLRequest(url: url))
    }

    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
    //da aggiungere nella view di home
    public var completionHandler : ((Bool) -> Void)?



    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else {
            return
        }
        
        guard let code = URLComponents(string: url.absoluteString)?.queryItems?.first(where: { $0.name == "code" })?.value else {
                print("Authentication failed: No code found in callback URL")
                return
            }
        
        
        /*
        if let url = navigationAction.request.url, url.absoluteString.contains("YOUR_REDIRECT_URI") {
            let code = url.absoluteString.components(separatedBy: "=")[1]
            // Make a POST request to exchange the code for an access token
            exchangeCodeForToken(code: code)
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)*/
    }
    /*
    func exchangeCodeForToken(code: String) {
        let headers = [
            "Authorization": "Basic YOUR_BASE64_ENCODED_CLIENT_ID_AND_SECRET",
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let parameters = [
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri": "YOUR_REDIRECT_URI"
        ]
        
        let postData = parameters.map { "\($0)=\($1)" }.joined(separator: "&").data(using: .utf8)!
        
        var request = URLRequest(url: URL(string: "https://accounts.spotify.com/api/token")!)
        request.allHTTPHeaderFields = headers
        request.httpMethod = "POST"
        request.httpBody = postData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                return
            }
            let accessToken = json["access_token"] as? String
            let expiresIn = json["expires_in"] as? Int
            let refreshToken = json["refresh_token"] as? String
            
            // Save the access token, expiration date, and refresh token
        }
        
        task.resume()
        */
    }
}
