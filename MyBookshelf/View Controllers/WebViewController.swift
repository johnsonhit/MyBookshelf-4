//
//  WebViewController.swift
//  MyBookshelf
//
//  Created by Jae Kyung Lee on 13/12/2019.
//  Copyright © 2019 Jae Kyung Lee. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    var webkitView: WKWebView!
    
    var progressView: UIProgressView!
    
    var urlStr: String?
    
    private let oberserKeyPath = "estimatedProgress"

    override func viewDidLoad() {
        
        guard let urlStr = urlStr else { return }
        super.viewDidLoad()
        
        setView()
        
        addObserver()

        loadUrl(urlStr: urlStr)
    }
    
    deinit {
        webkitView.removeObserver(self, forKeyPath: oberserKeyPath)
        progressView.removeFromSuperview()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == oberserKeyPath {
            progressView.progress = Float(webkitView.estimatedProgress)
        }
    }
    
    // MARK: Setter
    
    func setView() {
        
        let webConfiguration = WKWebViewConfiguration()
        webkitView = WKWebView(frame: .zero, configuration: webConfiguration)
        webkitView.navigationDelegate = self
        
        self.view.addSubview(webkitView)
        _ = webkitView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 20)
        navigationController?.navigationBar.addSubview(progressView)
        let navigationBarBounds = self.navigationController?.navigationBar.bounds
        progressView.frame = CGRect(x: 0, y: navigationBarBounds!.size.height - 2, width: navigationBarBounds!.size.width, height: 2)
    }
    
    func addObserver() {
        webkitView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    // MARK: Convenience
    
    private func loadUrl(urlStr: String) {
        guard let url = URL(string: urlStr) else {
            return
        }
        progressView.isHidden = false
        
        let request = URLRequest(url: url)

        webkitView.load(request)
    }
    
}

// MARK: WKNavigationDelegate

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard let policy = WKNavigationActionPolicy(rawValue: 1) else { return }
        decisionHandler(policy)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIView.animate(withDuration: 0.33, animations: {
            self.progressView.alpha = CGFloat(0.0) },
            completion: { _ in
            self.progressView.isHidden = true
        })
    }
}
