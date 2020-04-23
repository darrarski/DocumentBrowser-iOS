import DocumentBrowser
import UIKit

class DocumentInitializerDouble: DocumentInitializing {
  
  private(set) var didInitializedDocuments = [(url: URL, document: UIDocumentDouble)]()
  
  // MARK: - DocumentInitializing
  
  func initializeDocument(with url: URL) -> UIDocument {
    let document = UIDocumentDouble(fileURL: url)
    didInitializedDocuments.append((url, document))
    return document
  }
  
}
