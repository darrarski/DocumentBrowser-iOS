import UIKit

public protocol DocumentInitializing {
  func initializeDocument(with url: URL) -> UIDocument
}
