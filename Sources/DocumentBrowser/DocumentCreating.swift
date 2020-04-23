import UIKit

public protocol DocumentCreating {
  func createDocument(importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void)
}
