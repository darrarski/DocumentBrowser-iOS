import Quick
import Nimble
@testable import DocumentBrowser
import UIKit

class DocumentBrowserViewControllerFactorySpec: QuickSpec {
  override func spec() {
    context("init") {
      var sut: DocumentBrowserViewControllerFactory!
      var contentTypes: [String]?
      
      beforeEach {
        contentTypes = ["type-1", "type-2"]
        sut = DocumentBrowserViewControllerFactory(contentTypes: contentTypes)
      }
      
      context("create view controller") {
        var viewController: UIDocumentBrowserViewController!
        
        beforeEach {
          viewController = sut.createViewController()
        }
        
        it("should create instance of UIDocumentBrowserViewController") {
          expect(viewController).to(beAnInstanceOf(UIDocumentBrowserViewController.self))
        }
        
        it("should created view controller have correct allowed content types") {
          expect(viewController.allowedContentTypes) == contentTypes
        }
      }
    }
  }
}
