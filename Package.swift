// swift-tools-version:5.7.3

import PackageDescription

let package = Package(
    name: "Trash",
    products: [
        .executable(name: "Trash", targets: ["TrashCLI"])
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
