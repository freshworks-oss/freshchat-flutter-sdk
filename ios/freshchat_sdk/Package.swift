// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "freshchat_sdk",
    platforms: [
        .iOS("12.0"),
    ],
    products: [
        .library(name: "freshchat-sdk", targets: ["freshchat_sdk"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        .package(
            url: "https://github.com/freshworks-oss/freshchat-ios.git",
            .upToNextMajor(from: "6.4.9"),
        )
    ],
    targets: [
        .target(
            name: "freshchat_sdk",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "FreshchatSDK", package: "freshchat-ios")
            ],
            resources: [
                // TODO: If your plugin requires a privacy manifest
                // (in other words, if it uses any required reason APIs),
                // update the PrivacyInfo.xcprivacy file
                // to describe your plugin's privacy impact, and then uncomment this line.
                // For more information, visit:
                // https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
                // .process("PrivacyInfo.xcprivacy"),

                // TODO: If you have other resources that need to be bundled with your plugin, refer to
                // the following instructions to add them:
                // https://developer.apple.com/documentation/xcode/bundling-resources-with-a-swift-package
            ],
            cSettings: [
                .headerSearchPath("include/freshchat_sdk")
            ]
        )
    ]
)
