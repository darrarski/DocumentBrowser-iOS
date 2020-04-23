import UIKit

public class DocumentBrowser: DocumentBrowsing {

  public init(viewControllerFactory: DocumentBrowserViewControllerCreating,
              documentInitializer: DocumentInitializing,
              documentCreator: DocumentCreating,
              documentPresenter: DocumentPresenting) {
    self.viewControllerFactory = viewControllerFactory
    self.documentInitializer = documentInitializer
    self.documentPresenter = documentPresenter
    self.viewControllerDelegate = DocumentBrowserViewControllerDelegate(
      documentInitializer: documentInitializer,
      documentCreator: documentCreator,
      documentPresenter: documentPresenter
    )
  }

  let viewControllerFactory: DocumentBrowserViewControllerCreating
  let documentInitializer: DocumentInitializing
  let documentPresenter: DocumentPresenting
  let viewControllerDelegate: DocumentBrowserViewControllerDelegate

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

  // MARK: - Private

  private lazy var browserViewController: UIDocumentBrowserViewController = {
    let controller = viewControllerFactory.createViewController()
    controller.allowsDocumentCreation = true
    controller.allowsPickingMultipleItems = false
    controller.delegate = self.viewControllerDelegate
    return controller
  }()

}
