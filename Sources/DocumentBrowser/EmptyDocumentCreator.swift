import UIKit

public struct EmptyDocumentCreator: DocumentCreating {
  
  public init(filename: String, initializer: DocumentInitializing) {
    self.filename = filename
    self.initializer = initializer
  }
  
  let filename: String
  let initializer: DocumentInitializing
  
  // MARK: - DocumentCreating
  
  public func createDocument(importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
    let url = URL(fileURLWithPath: NSTemporaryDirectory())
      .appendingPathComponent(filename)
    let document = initializer.initializeDocument(with: url)
    document.save(to: url, for: .forCreating) { success in
      if success {
        document.close { success in
          if success {
            importHandler(url, .move)
          } else {
            importHandler(nil, .none)
          }
        }
      } else {
        importHandler(nil, .none)
      }
    }
  }
  
}
