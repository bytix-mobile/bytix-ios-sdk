// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Bytix",
    platforms: [.iOS(.v12)],
    products: [
        .library(name: "Bytix",
                 targets: ["Bytix"])
    ],
    targets: [
        .binaryTarget(name: "Bytix",
                      path: "Bytix.xcframework")
    ]
)
