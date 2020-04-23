import UIKit

class UIDocumentBrowserViewControllerDouble: UIDocumentBrowserViewController {
  
  convenience init() {
    self.init(forOpeningFilesWithContentTypes: nil)
  }
  
  private(set) var didRevealDocument = [(at: URL, importIfNeeded: Bool, completion: ((URL?, Error?) -> Void)?)]()
  
  // MARK: - UIDocumentBrowserViewController
  
  override func revealDocument(
    at url: URL,
    importIfNeeded: Bool,
    completion: ((URL?, Error?) -> Void)? = nil
  ) {
    didRevealDocument.append((url, importIfNeeded, completion))
  }
  
}
