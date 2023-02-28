// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Bytix",
    platforms: [.iOS(.v12)],
    products: [
        .library(
            name: "Bytix",
            targets: ["Bytix", "BytixWrapper"]
        )
    ],
    dependencies: [
        .package(name: "SwiftProtobuf", url: "https://github.com/apple/swift-protobuf.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "BytixWrapper",
            dependencies: [
                "SwiftProtobuf"
            ]
        ),
        .binaryTarget(
            name: "Bytix",
            path: "Bytix.xcframework"
        )
    ]
)
