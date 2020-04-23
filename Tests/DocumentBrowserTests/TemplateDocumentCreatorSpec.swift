import Quick
import Nimble
import UIKit
@testable import DocumentBrowser

class TemplateDocumentCreatorSpec: QuickSpec {
  override func spec() {
    context("init") {
      var sut: TemplateDocumentCreator!
      var templateURL: URL!

      beforeEach {
        templateURL = URL(fileURLWithPath: "document-template-url")
        sut = TemplateDocumentCreator(templateURL: templateURL)
      }

      context("create document") {
        var imports: [(url: URL?, mode: UIDocumentBrowserViewController.ImportMode)]!

        beforeEach {
          imports = []
          sut.createDocument(importHandler: { imports.append(($0, $1)) })
        }

        afterEach {
          imports = nil
        }

        it("should call import handler with template url and copy mode") {
          expect(imports).to(haveCount(1))
          expect(imports.first?.url) == templateURL
          expect(imports.first?.mode) == .copy
        }
      }
    }
  }
}
