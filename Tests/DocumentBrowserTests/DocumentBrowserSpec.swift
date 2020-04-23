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

      it("should have correct browser view controller delegate") {
        expect(sut.viewControllerDelegate.documentInitializer) === documentInitializer
        expect(sut.viewControllerDelegate.documentCreator) === documentCreator
        expect(sut.viewControllerDelegate.documentPresenter) === documentPresenter
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
          expect(viewControllerFactory.mockedViewController.delegate) === sut.viewControllerDelegate
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
    }
  }
}
