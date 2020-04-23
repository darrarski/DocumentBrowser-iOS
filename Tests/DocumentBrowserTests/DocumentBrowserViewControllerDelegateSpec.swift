import Quick
import Nimble
@testable import DocumentBrowser
import UIKit

class DocumentBrowserViewControllerDelegateSpec: QuickSpec {
  override func spec() {
    context("init") {
      var sut: DocumentBrowserViewControllerDelegate!
      var documentInitializer: DocumentInitializerDouble!
      var documentCreator: DocumentCreatorDouble!
      var documentPresenter: DocumentPresenterDouble!

      beforeEach {
        documentInitializer = DocumentInitializerDouble()
        documentCreator = DocumentCreatorDouble()
        documentPresenter = DocumentPresenterDouble()
        sut = DocumentBrowserViewControllerDelegate(
          documentInitializer: documentInitializer,
          documentCreator: documentCreator,
          documentPresenter: documentPresenter
        )
      }

      afterEach {
        documentInitializer = nil
        documentCreator = nil
        documentPresenter = nil
        sut = nil
      }

      context("when browser did request document creation") {
        var didImport: [(url: URL?, mode: UIDocumentBrowserViewController.ImportMode)]!

        beforeEach {
          didImport = []
          sut.documentBrowser(
            UIDocumentBrowserViewControllerDouble(),
            didRequestDocumentCreationWithHandler: {
              didImport.append((url: $0, mode: $1))
          })
        }

        afterEach {
          didImport = nil
        }

        it("should creare document") {
          expect(documentCreator.didCreateWithImportHandler).to(haveCount(1))
        }

        context("when create succeed with move mode") {
          var url: URL!

          beforeEach {
            url = URL(fileURLWithPath: "created-document-url")
            documentCreator.didCreateWithImportHandler.first?(url, .move)
          }

          it("should import with correct url and move mode") {
            expect(didImport).to(haveCount(1))
            expect(didImport.first?.url) == url
            expect(didImport.first?.mode) == .move
          }
        }

        context("when create succeed with copy mode") {
          var url: URL!

          beforeEach {
            url = URL(fileURLWithPath: "created-document-url")
            documentCreator.didCreateWithImportHandler.first?(url, .copy)
          }

          it("should import with correct url and copy mode") {
            expect(didImport).to(haveCount(1))
            expect(didImport.first?.url) == url
            expect(didImport.first?.mode) == .copy
          }
        }

        context("when create fails") {
          beforeEach {
            documentCreator.didCreateWithImportHandler.first?(nil, .none)
          }

          it("should import with nil url and none mode") {
            expect(didImport).to(haveCount(1))
            expect(didImport.first?.url).to(beNil())
            expect(didImport.first?.mode) == UIDocumentBrowserViewController.ImportMode.none
          }
        }
      }

      context("when browser did pick document at urls") {
        var controller: UIDocumentBrowserViewControllerDouble!
        var urls: [URL]!

        beforeEach {
          controller = UIDocumentBrowserViewControllerDouble()
          urls = [URL(fileURLWithPath: "first-url"), URL(fileURLWithPath: "second-url")]
          sut.documentBrowser(controller, didPickDocumentsAt: urls)
        }

        it("should initialize document with first url") {
          expect(documentInitializer.didInitializedDocuments).to(haveCount(1))
          expect(documentInitializer.didInitializedDocuments.first?.url) == urls.first!
        }

        describe("document") {
          var document: UIDocumentDouble?

          beforeEach {
            document = documentInitializer.didInitializedDocuments.first?.document
          }

          it("should open") {
            expect(document?.didOpenWithCompletion).to(haveCount(1))
          }

          context("when open succeed") {
            beforeEach {
              document?.didOpenWithCompletion.first??(true)
            }

            it("should present document") {
              expect(documentPresenter.didPresent).to(haveCount(1))
              expect(documentPresenter.didPresent.first?.document) === document
              expect(documentPresenter.didPresent.first?.from) === controller
            }
          }

          context("when open fails") {
            beforeEach {
              document?.didOpenWithCompletion.first??(false)
            }

            it("should not present document") {
              expect(documentPresenter.didPresent).to(beEmpty())
            }
          }
        }
      }

      context("when browser did pick empty document urls") {
        beforeEach {
          sut.documentBrowser(UIDocumentBrowserViewControllerDouble(), didPickDocumentsAt: [])
        }

        it("should not initialize document") {
          expect(documentInitializer.didInitializedDocuments).to(beEmpty())
        }
      }

      context("when browser did import document") {
        var controller: UIDocumentBrowserViewControllerDouble!
        var desitnationURL: URL!

        beforeEach {
          controller = UIDocumentBrowserViewControllerDouble()
          let documentURL = URL(fileURLWithPath: "document-url")
          desitnationURL = URL(fileURLWithPath: "destination-url")
          sut.documentBrowser(controller, didImportDocumentAt: documentURL, toDestinationURL: desitnationURL)
        }

        it("should initialize document with destination url") {
          expect(documentInitializer.didInitializedDocuments).to(haveCount(1))
          expect(documentInitializer.didInitializedDocuments.first?.url) == desitnationURL
        }

        describe("document") {
          var document: UIDocumentDouble?

          beforeEach {
            document = documentInitializer.didInitializedDocuments.first?.document
          }

          it("should open") {
            expect(document?.didOpenWithCompletion).to(haveCount(1))
          }

          context("when open succeed") {
            beforeEach {
              document?.didOpenWithCompletion.first??(true)
            }

            it("should present document") {
              expect(documentPresenter.didPresent).to(haveCount(1))
              expect(documentPresenter.didPresent.first?.document) === document
              expect(documentPresenter.didPresent.first?.from) === controller
            }
          }

          context("when open fails") {
            beforeEach {
              document?.didOpenWithCompletion.first??(false)
            }

            it("should not present document") {
              expect(documentPresenter.didPresent).to(beEmpty())
            }
          }
        }
      }
    }
  }
}
