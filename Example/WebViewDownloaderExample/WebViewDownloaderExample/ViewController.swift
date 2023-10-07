//
//  ViewController.swift
//  WebViewDownloaderExample
//
//  Created by Sreekuttan D on 07/10/23.
//

import UIKit
import WebKit
import WKDownloadManager

class ViewController: UIViewController {
    
    fileprivate var webView: WKWebView!
    
    fileprivate var downloadManager: WKDownloadManager!
    
    fileprivate let pageUrl: String = "https://www.google.com/"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationItem.title = "WebView"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(loadWebPage))
        
        configureWebView()
        loadWebPage()
    }
    
    /// WebView configuration
    func configureWebView() {
        
        webView = WKWebView(frame: CGRect.zero)
        webView.scrollView.bounces = false
        webView.allowsLinkPreview = false
        webView.allowsBackForwardNavigationGestures = false
        webView.backgroundColor = UIColor.clear
        webView.isOpaque = false
        webView.scrollView.backgroundColor = UIColor.clear
        webView.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        webView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 16.4, *) {
            webView.isInspectable = true
        }
        
        let contentController = WKUserContentController()
        
        webView.configuration.userContentController = contentController
        webView.configuration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        webView.configuration.setValue(true, forKey: "allowUniversalAccessFromFileURLs")
        
        let pref = WKWebpagePreferences.init()
        pref.preferredContentMode = .mobile
        webView.configuration.defaultWebpagePreferences = pref
        
        // Setup downloadManager with supported file types
        let mimeTypes = ["image/svg+xml", "image/png", "image/jpeg", "application/pdf"]
        downloadManager = WKDownloadManager(delegate: self,
                                            supportedMimeTypes: mimeTypes)
        webView.navigationDelegate = downloadManager

        view.addSubview(webView)

        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])
    }
    
    @objc fileprivate func loadWebPage() {
        guard let url = URL(string: pageUrl) else {
            return
        }
        let request = URLRequest(url: url)
        self.webView.load(request)
    }

}

// MARK: - WKDownloadManagerDelegate
extension ViewController: WKDownloadManagerDelegate {
    
    func downloadDidFinish(location url: URL) {
        DispatchQueue.main.async {
            let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            activityVC.popoverPresentationController?.sourceRect = self.view.frame
            activityVC.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    func downloadDidFailed(withError error: Error) {
        
    }
    
}

