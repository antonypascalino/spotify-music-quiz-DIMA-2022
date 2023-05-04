//
//  AuthView.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 27/03/23.
//

//import SwiftUI

/*import WebKit

struct WebView: UIViewRepresentable {
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    
    let url : URL
    
    func makeUIView(context: Context) -> WKWebView {
        
        print("Called makeUIView")
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        print("Called updateUIView")
        webView.load(URLRequest(url: url))
        
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            guard let url = webView.url else {
                return
            }
            
            guard let code = URLComponents(string: url.absoluteString)?.queryItems?.first(where: { $0.name == "code" })?.value else {
                print("Authentication failed: No code found in callback URL")
                return
            }
            webView.isHidden = true
            
            print("Code : \(code)")
            AuthManager.shared.exchangeCodeForToken(code: code){ _ in /*[weak self] success in
                                                                       DispatchQueue.main.async {
                                                                       self?.navigationController?.popToRootViewController(animated: true)
                                                                       self?.completionHandler?(success)*/
            }
            
        }
    }
    
}*/

import SwiftUI
import WebKit

struct AuthView: View {
    let authURL = AuthManager.shared.signInURL!

    @State private var webView = WKWebView()
    @State private var code: String? = nil
    @State private var isLoading = false
    @State private var error: Error?

    var body: some View {
        VStack {
            if let code = code {
                Text("Code: \(code)")
                Button(action: {
                                isLoading = true
                                error = nil
                                
                                AuthManager.shared.exchangeCodeForToken(code: code) { result in
                                    isLoading = false
                                    
                                    switch result {
                                    case .success(let response):
                                        // TODO: Handle successful token exchange
                                        print("Access token: \(response.access_token)")
                                        print("Refresh token: \(response.refresh_token)")
                                        
                                    case .failure(let error):
                                        self.error = error
                                    }
                                }
                            }) {
                                if isLoading {
                                    ProgressView()
                                } else {
                                    Text("Exchange")
                                }
                            }
                            .padding()
                            
                            if let error = error {
                                Text("Error: \(error.localizedDescription)")
                                    .foregroundColor(.red)
                                    .padding()
                            }
            } else {
                Text("Suca")
                WebView(webView: $webView, url: authURL)
                    .onAppear {
                        webView.load(URLRequest(url: authURL))
                    }
                    .onReceive(
                        webView.publisher(for: \.url),
                        perform: { url in
                            guard let url = url else { return }
                            if url.absoluteString.contains("https://localhost:8888/callback?code=") {
                                let components = URLComponents(string: url.absoluteString)
                                code = components?.queryItems?.first(where: { $0.name == "code" })?.value
                                webView.loadHTMLString("<html><body>You have successfully authenticated with Spotify.</body></html>", baseURL: nil)
                            }
                        }
                    )
            }
        }
    }
}
struct WebView: UIViewRepresentable {
    @Binding var webView: WKWebView
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: url))
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
//             AuthManager.shared.exchangeCodeForToken(code: code){ [weak self] success in
//                                                                       DispatchQueue.main.async {
//                                                                       self?.navigationController?.popToRootViewController(animated: true)
//                                                                       self?.completionHandler?(success)
//            }
            decisionHandler(.allow)
        }
    

    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}


