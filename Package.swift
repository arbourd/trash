// swift-tools-version:5.8

import PackageDescription

let package = Package(
    name: "trash",
    products: [
        .executable(name: "trash", targets: ["TrashCLI"])
    ],
    targets: [
        .executableTarget(
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
