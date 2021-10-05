import SwiftUI
import WebKit

enum TwitterHTMLViewState {
    case loading
    case idle
}


fileprivate class TwitterHTMLViewNavigator: NSObject, WKNavigationDelegate {
    private let checkStateChange: (TwitterHTMLViewState) -> Void

    init(onStateChange: @escaping (TwitterHTMLViewState) -> Void) {
        self.checkStateChange = onStateChange
    }

    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        guard navigationAction.navigationType == .linkActivated else {
            decisionHandler(.allow)
            return
        }
        guard
            let url = navigationAction.request.url,
            UIApplication.shared.canOpenURL(url)
        else {
            decisionHandler(.cancel)
            return
        }

        UIApplication.shared.open(url)
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        checkStateChange(.loading)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        checkStateChange(.idle)
    }
}


struct TwitterHTMLView: UIViewRepresentable {
    private let navigator: WKNavigationDelegate

    init(onStateChange: @escaping (TwitterHTMLViewState) -> Void) {
        self.navigator = TwitterHTMLViewNavigator(
            onStateChange: onStateChange
        )
    }

    func makeUIView(context: Context) -> WKWebView {
        let view = WKWebView(frame: .zero)
        guard
            let htmlFilepath = Bundle.main.path(
                forResource: "TwitterViewTemplate", ofType: "html"
            ),
            let html = try? String(contentsOfFile: htmlFilepath)
        else { fatalError("Twitter Assets not found!") }
        view.loadHTMLString(html, baseURL: nil)
        view.navigationDelegate = navigator
        return view
    }

    func updateUIView(
        _ view: WKWebView,
        context: UIViewRepresentableContext<TwitterHTMLView>
    ) { }
}
