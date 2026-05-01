//
//  MidtransPaymentView.swift
//  NFC-Konekt
//
//  Created by Rei Soemanto on 01/05/26.
//

import SwiftUI
import WebKit

struct MidtransPaymentView: UIViewRepresentable {
    let urlString: String
    let onClose: () -> Void
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: urlString) {
            uiView.load(URLRequest(url: url))
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: MidtransPaymentView
        
        init(_ parent: MidtransPaymentView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let url = navigationAction.request.url?.absoluteString {
                if url.contains("yourdomain.com/payment/success") || url.contains("yourdomain.com/payment/failed") {
                    parent.onClose()
                    decisionHandler(.cancel)
                    return
                }
            }
            decisionHandler(.allow)
        }
    }
}

struct PaymentWebViewContainer: View {
    let urlString: String
    let onClose: () -> Void
    
    var body: some View {
        NavigationView {
            MidtransPaymentView(urlString: urlString, onClose: onClose)
                .navigationBarTitle("Secure Checkout", displayMode: .inline)
                .navigationBarItems(leading: Button(action: onClose) {
                    Image(systemName: "xmark").foregroundColor(.primary)
                })
        }
    }
}
