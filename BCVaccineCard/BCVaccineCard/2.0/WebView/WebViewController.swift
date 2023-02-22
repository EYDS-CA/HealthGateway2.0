//
//  WebViewController.swift
//  HealthGatewayTest
//
//  Created by Amir Shayegh on 2023-02-21.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
   
    @IBOutlet weak var backward: UIButton!
    @IBOutlet weak var forward: UIButton!
    
    @IBOutlet weak var siteLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var webView: WKWebView!
    var url: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        navigationController?.navigationBar.prefersLargeTitles = false
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        style()
        webView.navigationDelegate = self
        if let url = self.url {
            webView.load(url)
        }
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
        if keyPath == "title" {
            if let title = webView.title {
                siteLabel.text = title
            }
        }
        styleArrows()
    }
    
    func style() {
        progressView.tintColor = AppColours.appBlue
        let themeColour = AppColours.appBlue
        backward.tintColor = themeColour
        forward.tintColor = themeColour
        shareButton.tintColor = themeColour
        siteLabel.font = UIFont.bcSansRegularWithSize(size: 12)
        siteLabel.textColor = AppColours.lightGray
        self.navigationController?.navigationBar.tintColor = themeColour
        styleArrows()
    }
    
    func styleArrows() {
        backward.alpha = webView.canGoBack ? 1 : 0.3
        forward.alpha = webView.canGoForward ? 1 : 0.3
    }
    
    @IBAction func goBackward(_ sender: Any) {
        webView.goBack()
        styleArrows()
    }
    
    @IBAction func goForward(_ sender: Any) {
        webView.goForward()
        styleArrows()
    }
    
    @IBAction func share(_ sender: Any) {
        guard let urlString = url, let url = URL(string: urlString) else {return}
        let text = webView.title ?? ""
        let activity = UIActivityViewController(activityItems: [url, text], applicationActivities: nil)
        present(activity, animated: true)
    }
    
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.getElementsByClassName('ftFpPp')[0].remove()") { (result, error) in
        }
    }
}

extension WKWebView {
    func load(_ urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            load(request)
        }
    }
}
