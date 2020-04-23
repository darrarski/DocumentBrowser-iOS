import UIKit

public struct DocumentBrowserViewControllerFactory: DocumentBrowserViewControllerCreating {
  
  public init(contentTypes: [String]?) {
    self.contentTypes = contentTypes
  }
  
  let contentTypes: [String]?
  
  // MARK: - DocumentBrowserViewControllerCreating
  
  public func createViewController() -> UIDocumentBrowserViewController {
    UIDocumentBrowserViewController(forOpeningFilesWithContentTypes: contentTypes)
  }
  
}
