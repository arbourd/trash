// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "trash",
    targets: [
        .target(
            name: "TrashCLI",
            dependencies: ["Trash"]
        ),
        .target(
            name: "Trash"
        ),
        .testTarget(
                name: "TrashTests",
                dependencies: ["Trash"]
        )
    ]
)
