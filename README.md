
# WKDownloadManager

WKDownloadManager is used to manage downloads from WKWebView and is a lightweight and easy to use package.

## Requirements

     iOS 14.5 or later


## Installation

Package Manager support from Xcode 11+ :

1. Select File -> Swift Packages -> Add Package Dependency. Enter `https://github.com/kuttz/WKDownloadManager` in the "Choose Package Repository" dialog.
2. In the next page, specify the version resolving rule.
3. After Xcode checked out the source and resolving the version, you can choose the "WKDownloadManager" library and add it to your app target.

**-OR-**

Alternatively, you can also add CountryDialCode to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/kuttz/WKDownloadManager", branch: "main")
]
```

For more info, read [Adding Package Dependencies to Your App](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app) from Apple.

## Example

```swift
fileprivate var downloadManager: WKDownloadManager!

let mimeTypes = ["image/svg+xml",
                 "image/png",
                 "image/jpeg",
                 "application/pdf"]
downloadManager = WKDownloadManager(delegate: self,
                                    supportedMimeTypes: mimeTypes)
webView.navigationDelegate = downloadManager
```

