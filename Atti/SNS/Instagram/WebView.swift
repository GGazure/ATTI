import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
        
    @Binding var presentAuth: Bool
    
    @Binding var userData: InstagramTestUser
    
    @Binding var instagramApi: InstagramApi
    
    func makeCoordinator() -> WebView.Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<WebView>) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: UIViewRepresentableContext<WebView>) {
        instagramApi.authorization { (url) in
            DispatchQueue.main.async {
                webView.load(URLRequest(url: url!))
            }
        }
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        
        var parent: WebView
        
        init(parent: WebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            let request = navigationAction.request
            self.parent.instagramApi.getUserIDAndToken(request: request) { (instagramTestUser) in
                self.parent.userData = instagramTestUser
                self.parent.presentAuth = false
            }
            decisionHandler(WKNavigationActionPolicy.allow)
        }
                
    }
    
}
