import UIKit

class UIDocumentDouble: UIDocument {

  convenience init() {
    self.init(fileURL: URL(fileURLWithPath: ""))
  }

  private(set) var didOpenWithCompletion = [((Bool) -> Void)?]()
  private(set) var didSave = [(to: URL, for: UIDocument.SaveOperation, completion: ((Bool) -> Void)?)]()
  private(set) var didCloseWithCompletion = [((Bool) -> Void)?]()

  // MARK: - UIDocument

  override func open(completionHandler: ((Bool) -> Void)? = nil) {
    didOpenWithCompletion.append(completionHandler)
  }

  override func save(
    to url: URL,
    for saveOperation: UIDocument.SaveOperation,
    completionHandler: ((Bool) -> Void)? = nil
  ) {
    didSave.append((url, saveOperation, completionHandler))
  }

  override func close(completionHandler: ((Bool) -> Void)? = nil) {
    didCloseWithCompletion.append(completionHandler)
  }

}
