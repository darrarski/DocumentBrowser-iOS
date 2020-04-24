import UIKit

final class DocumentBrowserViewControllerDelegate: NSObject, UIDocumentBrowserViewControllerDelegate {

  init(documentInitializer: DocumentInitializing,
       documentCreator: DocumentCreating,
       documentPresenter: DocumentPresenting) {
    self.documentInitializer = documentInitializer
    self.documentCreator = documentCreator
    self.documentPresenter = documentPresenter
    super.init()
  }

  let documentInitializer: DocumentInitializing
  let documentCreator: DocumentCreating
  let documentPresenter: DocumentPresenting

  func documentBrowser(
    _ controller: UIDocumentBrowserViewController,
    didRequestDocumentCreationWithHandler
    importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void
  ) {
    documentCreator.createDocument(importHandler: importHandler)
  }

  func documentBrowser(
    _ controller: UIDocumentBrowserViewController,
    didPickDocumentsAt documentURLs: [URL]
  ) {
    guard let url = documentURLs.first else { return }
    let document = documentInitializer.initializeDocument(with: url)
    document.open { [documentPresenter] success in
      guard success else { return }
      documentPresenter.presentDocument(document, from: controller)
    }
  }

  func documentBrowser(
    _ controller: UIDocumentBrowserViewController,
    didImportDocumentAt sourceURL: URL,
    toDestinationURL destinationURL: URL
  ) {
    let document = documentInitializer.initializeDocument(with: destinationURL)
    document.open { [documentPresenter] success in
      guard success else { return }
      documentPresenter.presentDocument(document, from: controller)
    }
  }

}
