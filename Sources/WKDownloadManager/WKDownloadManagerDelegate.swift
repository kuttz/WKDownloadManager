//
//  WKDownloadManagerDelegate.swift
//  WKDownloadManager
//
//  Created by Sreekuttan D on 07/10/23.
//
//  Copyright © 2023 Sreekuttan  - All rights reserved.
//

import Foundation
import WebKit

public protocol WKDownloadManagerDelegate: AnyObject {
    
    /// Decides whether to allow or cancel a navigation.
    /// - Parameters:
    ///   - webView: The web view invoking the delegate method.
    ///   - url: The URL trying open
    /// - Returns: Return true to allow the navigation
    func webView(_ webView: WKWebView, decidePolicyFor url: URL) -> Bool
    
    /// Use this method to specify the destination where the downloaded file must be saved.
    /// The default implementation returns a temporary file location.
    /// - Parameter name: The suggested filename
    /// - Returns: The destination URL where the downloaded file must be saved.
    func destinationUrlForFile(withName name: String) -> URL?
    
    /// Method invoked after a file download completed.
    /// - Parameter url: The destination URL where the file saved.
    func downloadDidFinish(location url: URL)
    
    /// Method invoked if a download failed with an error.
    /// - Parameter error: The error indicating the failure reason.
    func downloadDidFailed(withError error: Error)
    
}

extension WKDownloadManagerDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor url: URL) -> Bool {
        return true
    }
    
    func destinationUrlForFile(withName name: String) -> URL? {
        let temporaryDir = NSTemporaryDirectory()
        let url = URL(fileURLWithPath: temporaryDir)
            .appendingPathComponent(UUID().uuidString)
        
        if ((try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: false)) == nil) {
            return nil
        }
        
        return url.appendingPathComponent(name)
    }
    
    func downloadDidFailed(withError error: Error) {
        
    }
    
}
