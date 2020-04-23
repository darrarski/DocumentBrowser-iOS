import DocumentBrowser
import UIKit

class DocumentPresenterDouble: DocumentPresenting {
  
  private(set) var didPresent = [(document: UIDocument, from: UIViewController)]()
  
  // MARK: - DocumentPresenting
  
  func presentDocument(_ document: UIDocument, from presenting: UIViewController) {
    didPresent.append((document, presenting))
  }
  
}
