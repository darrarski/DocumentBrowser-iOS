// swift-tools-version:5.2
import PackageDescription

let package = Package(
  name: "DocumentBrowser",
  platforms: [
    .iOS(.v11)
  ],
  products: [
    .library(
      name: "DocumentBrowser",
      targets: [
        "DocumentBrowser"
      ]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/Quick/Quick.git", .upToNextMajor(from: "2.2.0")),
    .package(url: "https://github.com/Quick/Nimble.git", .upToNextMajor(from: "8.0.7"))
  ],
  targets: [
    .target(
      name: "DocumentBrowser"
    ),
    .testTarget(
      name: "DocumentBrowserTests",
      dependencies: [
        "DocumentBrowser",
        "Quick",
        "Nimble"
      ]
    )
  ]
)
