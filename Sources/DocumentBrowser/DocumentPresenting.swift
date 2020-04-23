import UIKit

public protocol DocumentPresenting {
  func presentDocument(_ document: UIDocument, from presenting: UIViewController)
}
