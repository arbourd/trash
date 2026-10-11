// swift-tools-version:6.4

import PackageDescription

let package = Package(
    name: "trash",
    platforms: [
        .macOS(.v12)
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
