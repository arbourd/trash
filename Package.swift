// swift-tools-version:5.7.3

import PackageDescription

let package = Package(
    name: "trash",
    platforms: [
        .macOS(.v10_14)
    ],
    products: [
        .executable(name: "trash", targets: ["Trash"])
    ],
    targets: [
        .executableTarget(
            name: "Trash"
        ),
        .testTarget(
                name: "TrashTests",
                dependencies: ["Trash"]
        )
    ]
)
