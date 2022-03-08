//
//  NewInstagramView.swift
//  Atti
//
//  Created by 박승렬 on 2022/01/20.
//

import SwiftUI
import WebKit

struct NewInstagramView : UIViewRepresentable {
    
    var url = URL(string:
                        "http://www.instagram.com/blackpinkofficial")
     
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
 
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url!)
        webView.load(request)
    }
    
}

struct NewInstagramView_Previews : PreviewProvider {
    static var previews: some View {
        NewInstagramView(url: URL(string:
                                    "http://www.instagram.com/blackpinkofficial")!)
    }
}
