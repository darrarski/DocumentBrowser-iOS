import Quick
import Nimble
@testable import DocumentBrowser
import UIKit

class DocumentBrowserSpec: QuickSpec {
  override func spec() {
    context("init") {
      var sut: DocumentBrowser!
      var viewControllerFactory: DocumentBrowserViewControllerFactoryDouble!
      var documentInitializer: DocumentInitializerDouble!
      var documentCreator: DocumentCreatorDouble!
      var documentPresenter: DocumentPresenterDouble!

      beforeEach {
        viewControllerFactory = DocumentBrowserViewControllerFactoryDouble()
        documentInitializer = DocumentInitializerDouble()
        documentCreator = DocumentCreatorDouble()
        documentPresenter = DocumentPresenterDouble()
        sut = DocumentBrowser(
          viewControllerFactory: viewControllerFactory,
          documentInitializer: documentInitializer,
          documentCreator: documentCreator,
          documentPresenter: documentPresenter
        )
      }

      afterEach {
        viewControllerFactory = nil
        documentInitializer = nil
        documentCreator = nil
        documentPresenter = nil
        sut = nil
      }

      context("get view controller") {
        var viewController: UIViewController!

        beforeEach {
          viewController = sut.viewController
        }

        afterEach {
          viewController = nil
        }

        it("should create view controller") {
          expect(viewControllerFactory.didCallCreateViewController) == true
        }

        it("should return created view controller") {
          expect(viewController) === viewControllerFactory.mockedViewController
        }

        it("should configure created view controller") {
          expect(viewControllerFactory.mockedViewController.allowsDocumentCreation) == true
          expect(viewControllerFactory.mockedViewController.allowsPickingMultipleItems) == false
          expect(viewControllerFactory.mockedViewController.delegate) === sut
        }

        context("get view controller again") {
          var newViewController: UIViewController!

          beforeEach {
            newViewController = sut.viewController
          }

          afterEach {
            newViewController = nil
          }

          it("should not create another view controller") {
            expect(viewControllerFactory.didCallCreateViewController) == 1
          }

          it("should return the same view controller") {
            expect(newViewController) === viewController
          }
        }
      }

      context("open document") {
        var url: URL!

        beforeEach {
          url = URL(fileURLWithPath: "document-url")
          sut.openDocument(at: url)
        }

        it("should reveal document in browser view controller") {
          let controller = viewControllerFactory.mockedViewController
          expect(controller.didRevealDocument).to(haveCount(1))
          expect(controller.didRevealDocument.first?.at) == url
          expect(controller.didRevealDocument.first?.importIfNeeded) == true
        }

        context("when document is revealed") {
          var revealedURL: URL!

          beforeEach {
            revealedURL = URL(fileURLWithPath: "revealed-document-url")
            let controller = viewControllerFactory.mockedViewController
            controller.didRevealDocument.first?.completion?(revealedURL, nil)
          }

          it("should initialize document with revealed url") {
            expect(documentInitializer.didInitializedDocuments).to(haveCount(1))
            expect(documentInitializer.didInitializedDocuments.first?.url) == revealedURL
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
                expect(documentPresenter.didPresent.first?.from) === viewControllerFactory.mockedViewController
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

        context("when document could not be revealed") {
          beforeEach {
            let controller = viewControllerFactory.mockedViewController
            controller.didRevealDocument.first?.completion?(nil, nil)
          }

          it("should not initialize document") {
            expect(documentInitializer.didInitializedDocuments).to(beEmpty())
          }
        }
      }

      context("when browser did request document creation") {
        var didImport: [(url: URL?, mode: UIDocumentBrowserViewController.ImportMode)]!

        beforeEach {
          didImport = []
          sut.documentBrowser(
            UIDocumentBrowserViewControllerDouble(),
            didRequestDocumentCreationWithHandler: {
              didImport.append((url: $0, mode: $1))
          }
          )
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
