//
//  WKDownloadManager.swift
//  WKDownloadManager
//
//  Created by Sreekuttan D on 26/06/23.
//
//  Copyright © 2023 Sreekuttan  - All rights reserved.
//

import Foundation
import WebKit

public class WKDownloadManager: NSObject {
    
    weak var delegate: WKDownloadManagerDelegate?
    
    fileprivate var downloadDestinationURL: URL?
    
    /// An array of supported Mime types.
    fileprivate var supportedMimeTypes: [String] = []
    
    
    /// Create the WKDownloadManager with a delegate and supported mime types
    /// - Parameters:
    ///   - delegate: delegate object
    ///   - supportedMimeTypes: Array of supported Mime types.
    public init(delegate: WKDownloadManagerDelegate,
                supportedMimeTypes: [String]) {
        super.init()
        self.delegate = delegate
        self.supportedMimeTypes = supportedMimeTypes
    }
    
    fileprivate func isSupported(mimeType: String) -> Bool {
        return supportedMimeTypes.contains(mimeType)
    }
    
}

// MARK: - WKNavigationDelegate
extension WKDownloadManager: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
        
        guard let url = navigationAction.request.url else {
            return .cancel
        }
        let isSafe: Bool = delegate?.webView(webView, decidePolicyFor: url) ?? true
        return isSafe ? .allow : .cancel
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse) async -> WKNavigationResponsePolicy {
        guard let url = navigationResponse.response.url else {
            return .cancel
        }
        
        let isSafe: Bool = delegate?.webView(webView, decidePolicyFor: url) ?? true
        if !isSafe {
            return .cancel
        } else if let mimeType = navigationResponse.response.mimeType,
                  isSupported(mimeType: mimeType) {
            return .download
        } else {
            return .allow
        }
    }
    
    public func webView(_ webView: WKWebView, navigationResponse: WKNavigationResponse, didBecome download: WKDownload) {
        download.delegate = self
    }
    
}

// MARK: - WKDownloadDelegate
extension WKDownloadManager: WKDownloadDelegate {
    
    public func download(_ download: WKDownload, decideDestinationUsing response: URLResponse, suggestedFilename: String) async -> URL? {
        downloadDestinationURL = delegate?.destinationUrlForFile(withName: suggestedFilename)
        return downloadDestinationURL
    }
    
    public func download(_ download: WKDownload, didFailWithError error: Error, resumeData: Data?) {
        delegate?.downloadDidFailed(withError: error)
    }
    
    public func downloadDidFinish(_ download: WKDownload) {
        
        if let url = downloadDestinationURL {
            delegate?.downloadDidFinish(location: url)
        }
    }
    
}
