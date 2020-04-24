# 📦 DocumentBrowser-iOS

![swift v5.2](https://img.shields.io/badge/swift-v5.2-orange.svg)
![swift package manager compatible](https://img.shields.io/badge/swift%20package%20manager-✓-green.svg)
![platform iOS v11](https://img.shields.io/badge/platform-iOS%20v11-blue.svg)
![test coverage 100%](https://img.shields.io/badge/test_covergage-100%25-green.svg)

**DocumentBrowser** is a convenient wrapper for `UIDocumentBrowserViewController` for use in document-based iOS applications.

## 🛠 Tech stack

- [Swift](https://swift.org/) 5.2
- [Xcode](https://developer.apple.com/xcode/) 11.4.1
- [iOS](https://www.apple.com/pl/ios/) 11.0

## 🧰 Installation

**DocumentBrowser** is compatible with [Swift Package Manager](https://swift.org/package-manager/). You can add it as a dependency to your [Xcode project](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app) or [swift package](https://github.com/apple/swift-package-manager/blob/master/Documentation/Usage.md#defining-dependencies). The minimum deployment target for the library is **iOS 11**.

## 📝 Usage

`DocumentBrowsing` protocol is the main interface of the package. It provides an instance of document browser view controller that you can present in your app. Is also allows to open document located at provided URL, which is the feature you want to use when implementing deep-links.

```swift
public protocol DocumentBrowsing {
  var viewController: UIViewController { get }
  func openDocument(at url: URL)
}
```

To create an instance of `DocumentBrowser`, which implements `DocumentBrowsing` protocol:

```swift
let browser: DocumentBrowsing = DocumentBrowser(
  viewControllerFactory: /* DocumentBrowserViewControllerCreating */,
  documentInitializer: /* DocumentInitializing */,
  documentCreator: /* DocumentCreating */,
  documentPresenter: /* DocumentPresenting */
)
```

### Dependencies

#### 🧩 `DocumentBrowserViewControllerCreating`

```swift
public protocol DocumentBrowserViewControllerCreating {
  func createViewController() -> UIDocumentBrowserViewController
}
```

Document browser view controller factory. You can implement it by conforming to `DocumentBrowserViewControllerCreating` protocol or use `DocumentBrowserViewControllerFactory` implementation for your convenience.

#### 🧩 `DocumentInitializing`

```swift
public protocol DocumentInitializing {
  func initializeDocument(with url: URL) -> UIDocument
}
```

Document object factory you can implement by conforming to `DocumentInitializing` protocol. The factory should return an instance of `UIDocument` subclass.

#### 🧩 `DocumentCreating`

```swift
public protocol DocumentCreating {
  func createDocument(importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void)
}
```

Factory for creating new documents. It's used when user requests new document creation from the browser. You can implement the logic by confirming to `DocumentCreating` protocol, or use one of the included implemenations:

- `EmptyDocumentCreator` - creates new document file in a temporary directory and then imports (moves) it into desired location
- `TemplateDocumentCreator` - creates new document file by copying given template file into desired location

#### 🧩 `DocumentPresenting`

```swift
public protocol DocumentPresenting {
  func presentDocument(_ document: UIDocument, from presenting: UIViewController)
}
```

Document user interface presenter. You should implement the logic of presenting `UIDocument` in your app by conforming to `DocumentPresenting` protocol.

## 🛠 Development

You can open `Package.swift` in Xcode:

```sh
open Package.swift
```

Xcode build scheme is set up for building the library and running unit tests suit.

## 📄 License

Copyright © 2020 [Dariusz Rybicki Darrarski](http://www.darrarski.pl)

License: [GNU GPLv3](LICENSE)
