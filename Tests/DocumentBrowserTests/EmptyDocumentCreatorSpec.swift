import Quick
import Nimble
import UIKit
@testable import DocumentBrowser

class EmptyDocumentCreatorSpec: QuickSpec {
  override func spec() {
    context("init") {
      var sut: EmptyDocumentCreator!
      var filename: String!
      var initializer: DocumentInitializerDouble!

      beforeEach {
        filename = "Document.double"
        initializer = DocumentInitializerDouble()
        sut = EmptyDocumentCreator(filename: filename, initializer: initializer)
      }

      afterEach {
        sut = nil
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

        it("should initialize document with correct url") {
          expect(initializer.didInitializedDocuments).to(haveCount(1))
          expect(initializer.didInitializedDocuments.first?.url)
            == URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(filename)
        }

        describe("document") {
          var document: UIDocumentDouble?

          beforeEach {
            document = initializer.didInitializedDocuments.first?.document
          }

          it("should save to correct url for creating") {
            expect(document?.didSave).to(haveCount(1))
            expect(document?.didSave.first?.to) == URL(fileURLWithPath: NSTemporaryDirectory())
              .appendingPathComponent(filename)
            expect(document?.didSave.first?.for) == .forCreating
          }

          context("when save succeed") {
            beforeEach {
              document?.didSave.first?.completion?(true)
            }

            it("should close document") {
              expect(document?.didCloseWithCompletion).to(haveCount(1))
            }

            context("when close succeed") {
              beforeEach {
                document?.didCloseWithCompletion.first??(true)
              }

              it("should call import handler with correct url and move mode") {
                expect(imports).to(haveCount(1))
                expect(imports.first?.url) == URL(fileURLWithPath: NSTemporaryDirectory())
                  .appendingPathComponent(filename)
                expect(imports.first?.mode) == .move
              }
            }

            context("when close fails") {
              beforeEach {
                document?.didCloseWithCompletion.first??(false)
              }

              it("should call import handler without url and none mode") {
                expect(imports).to(haveCount(1))
                expect(imports.first?.url) == .some(nil)
                expect(imports.first?.mode) == .some(.none)
              }
            }
          }

          context("when save fails") {
            beforeEach {
              document?.didSave.first?.completion?(false)
            }

            it("should call import handler without url and none mode") {
              expect(imports).to(haveCount(1))
              expect(imports.first?.url) == .some(nil)
              expect(imports.first?.mode) == .some(.none)
            }
          }
        }
      }
    }
  }
}
