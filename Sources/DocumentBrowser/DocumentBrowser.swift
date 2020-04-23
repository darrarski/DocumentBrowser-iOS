import UIKit

public class DocumentBrowser: NSObject, DocumentBrowsing, UIDocumentBrowserViewControllerDelegate {

  public init(viewControllerFactory: DocumentBrowserViewControllerCreating,
              documentInitializer: DocumentInitializing,
              documentCreator: DocumentCreating,
              documentPresenter: DocumentPresenting) {
    self.viewControllerFactory = viewControllerFactory
    self.documentInitializer = documentInitializer
    self.documentCreator = documentCreator
    self.documentPresenter = documentPresenter
    super.init()
  }

  let viewControllerFactory: DocumentBrowserViewControllerCreating
  let documentInitializer: DocumentInitializing
  let documentCreator: DocumentCreating
  let documentPresenter: DocumentPresenting

  // MARK: - DocumentBrowsing

  public var viewController: UIViewController { browserViewController }

  public func openDocument(at url: URL) {
    browserViewController.revealDocument(at: url, importIfNeeded: true) { url, _ in
      guard let url = url else { return }
      let document = self.documentInitializer.initializeDocument(with: url)
      document.open { success in
        guard success else { return }
        self.documentPresenter.presentDocument(document, from: self.viewController)
      }
    }
  }

  // MARK: - UIDocumentBrowserViewControllerDelegate

  public func documentBrowser(
    _ controller: UIDocumentBrowserViewController,
    didRequestDocumentCreationWithHandler
    importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void
  ) {
    documentCreator.createDocument(importHandler: importHandler)
  }

  public func documentBrowser(
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

  public func documentBrowser(
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

  // MARK: - Private

  private lazy var browserViewController: UIDocumentBrowserViewController = {
    let controller = viewControllerFactory.createViewController()
    controller.allowsDocumentCreation = true
    controller.allowsPickingMultipleItems = false
    controller.delegate = self
    return controller
  }()

}
