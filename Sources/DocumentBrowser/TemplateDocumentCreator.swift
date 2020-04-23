import UIKit

public struct TemplateDocumentCreator: DocumentCreating {

  public init(templateURL: URL) {
    self.templateURL = templateURL
  }

  let templateURL: URL

  // MARK: - DocumentCreating

  public func createDocument(importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
    importHandler(templateURL, .copy)
  }

}
