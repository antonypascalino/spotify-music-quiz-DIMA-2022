//
//  AuthView.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 27/03/23.
//

import SwiftUI
import WebKit

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
    
}




struct AuthView: View  {
    var body: some View {
        //print("Call to WebView")
        WebView(url: AuthManager.shared.signInURL!)
        //print("Closed WebView")
    }
}
struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
