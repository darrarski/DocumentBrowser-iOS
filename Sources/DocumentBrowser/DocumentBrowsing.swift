import UIKit

public protocol DocumentBrowsing {
  var viewController: UIViewController { get }
  func openDocument(at url: URL)
}
