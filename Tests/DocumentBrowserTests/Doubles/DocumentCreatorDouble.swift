import DocumentBrowser
import UIKit

class DocumentCreatorDouble: DocumentCreating {
  
  private(set) var didCreateWithImportHandler = [(URL?, UIDocumentBrowserViewController.ImportMode) -> Void]()
  
  // MARK: - DocumentCreating
  
  func createDocument(importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
    didCreateWithImportHandler.append(importHandler)
  }
  
}
