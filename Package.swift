// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HMSRoomModels",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "HMSRoomModels",
            targets: ["HMSRoomModels"]),
        .library(
            name: "HMSSDK",
            targets: ["HMSSDK"]),
        .library(
            name: "HMSAnalyticsSDK",
            targets: ["HMSAnalyticsSDK"]),
        .library(
            name: "HMSHLSPlayerSDK",
            targets: ["HMSHLSPlayerSDK"]),
        .library(
            name: "HMSBroadcastExtensionSDK",
            targets: ["HMSBroadcastExtensionSDK"]),
        .library(
            name: "WebRTC",
            targets: ["WebRTC"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/auth0/JWTDecode.swift", from: "3.1.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "HMSRoomModels",
            dependencies: [.product(name: "JWTDecode", package: "JWTDecode.swift")]
        ),
        .binaryTarget(
            name: "HMSSDK",
            url: "https://github.com/100mslive/100ms-ios-sdk-staging/releases/download/1.7.0/HMSSDK.xcframework.zip",
                        checksum: "135155e1e7ab4525b646cb275ed87a71a91bf05bae39c56e83f5267adcf05e0c"
        ),
        .binaryTarget(
            name: "HMSAnalyticsSDK",
            url: "https://github.com/100mslive/100ms-ios-analytics-sdk/releases/download/0.0.2/HMSAnalyticsSDK.xcframework.zip",
            checksum: "40229908576cac8afab7f9ba8b3bd9b1408f97f7bff63f83dca5b4f60f4378f0"
        ),
        .binaryTarget(
            name: "HMSHLSPlayerSDK",
            url: "https://github.com/100mslive/100ms-ios-hls-sdk/releases/download/0.0.2/HMSHLSPlayerSDK.xcframework.zip",
            checksum: "470932129c8dd358ebbe748bc1e05739f33c642779513fee17e42a117329dce2"
        ),
        .binaryTarget(
            name: "WebRTC",
            url: "https://github.com/100mslive/webrtc-ios/releases/download/1.0.5118/WebRTC.xcframework.zip",
            checksum: "f80dde0250940647633340627f1a2aec83d8d53889e79ab34d0d168bcb16d253"
        ),
        .binaryTarget(
            name: "HMSBroadcastExtensionSDK",
            url: "https://github.com/100mslive/100ms-ios-broadcast-sdk/releases/download/1.0.0/HMSBroadcastExtensionSDK.xcframework.zip",
            checksum: "589a000dfdc948f938482d8affb333644ccc74300e5c7df2ea1aa887a94ae0b9"
        ),
    ]
)
