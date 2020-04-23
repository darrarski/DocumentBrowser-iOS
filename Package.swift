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
  targets: [
    .target(
      name: "DocumentBrowser"
    ),
    .testTarget(
      name: "DocumentBrowserTests",
      dependencies: [
        "DocumentBrowser"
      ]
    )
  ]
)
