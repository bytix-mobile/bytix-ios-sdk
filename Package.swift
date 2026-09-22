// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "Bytix",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "Bytix",
            targets: ["Bytix"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "Bytix",
            path: "Bytix.xcframework"
        )
    ]
)
