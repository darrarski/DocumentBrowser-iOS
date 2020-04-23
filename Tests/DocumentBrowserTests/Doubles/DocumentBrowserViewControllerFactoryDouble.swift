import DocumentBrowser
import UIKit

class DocumentBrowserViewControllerFactoryDouble: DocumentBrowserViewControllerCreating {
  
  private(set) var didCallCreateViewController = 0
  let mockedViewController = UIDocumentBrowserViewControllerDouble()
  
  // MARK: - DocumentBrowserViewControllerCreating
  
  func createViewController() -> UIDocumentBrowserViewController {
    didCallCreateViewController += 1
    return mockedViewController
  }
  
}
