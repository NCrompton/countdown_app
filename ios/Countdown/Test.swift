//
//  MTAppPasswordTutorialView.swift
//  MailTime_iOS
//
//  Created by Mason Tsui on 23/9/2024.
//  Copyright © 2024 Mobile Internet Limited. All rights reserved.
//

import SwiftUI
import WebKit

@objcMembers
class MTAppPasswordTutorialViewController: NSObject {
    func makeMTAppPasswordTutorialViewController(url: URL) -> UIViewController{
        let hostCon = UIHostingController(rootView: MTAppPasswordTutorialView(url: url))
        return hostCon
    }
}

struct MTAppPasswordTutorialView: View {
    
    let url: URL
    
    var body: some View {
        VStack {
            WebView(url:url)
                .edgesIgnoringSafeArea(.all)
//                .padding(.bottom, 20)
            Button(action: {
//                if (isDemoFormFilled()) {
//                    self.finishDemoForm()
//                }
            }) {
                Text("Sign In and Set Up App Password")
                    .frame(minWidth: 100, maxWidth: .infinity, minHeight: 44)
                    .background(Color.blue)
                    .contentShape(RoundedRectangle(cornerRadius: 4))
                    .cornerRadius(4)
                    .padding(.all, 16)
                    .tint(.white)
            }
        }.navigationTitle("how to")
    }
}

struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView  {
        let wkwebView = WKWebView()
        let request = URLRequest(url: url)
        wkwebView.load(request)
        return wkwebView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
    }
}

#Preview {
    MTAppPasswordTutorialView(url: URL(string: "https://staging.d2nrhnp1v76mng.amplifyapp.com/app/how-to-link-your-email?provider=icloud")!)
}
