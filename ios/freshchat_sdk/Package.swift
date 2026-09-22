// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "freshchat_sdk",
  platforms: [
    .iOS("13.0")
  ],
  products: [
    .library(name: "freshchat-sdk", targets: ["freshchat_sdk"])
  ],
  dependencies: [
    // Provided by the Flutter tool at build time (Flutter 3.24+ Swift Package Manager integration).
    .package(name: "FlutterFramework", path: "../FlutterFramework"),
    // Native Freshchat iOS SDK, distributed as a binary xcframework Swift package.
    // Keep this version in sync with the `FreshchatSDK` dependency in freshchat_sdk.podspec.
    .package(url: "https://github.com/freshworks-oss/freshchat-ios.git", exact: "6.4.9")
  ],
  targets: [
    .target(
      name: "freshchat_sdk",
      dependencies: [
        .product(name: "FlutterFramework", package: "FlutterFramework"),
        .product(name: "FreshchatSDK", package: "freshchat-ios")
      ],
      exclude: [
        "include/freshchat_sdk-umbrella.h",
        "include/FreshchatSdkPlugin.modulemap"
      ],
      cSettings: [
        .headerSearchPath("include/freshchat_sdk")
      ]
    )
  ]
)
