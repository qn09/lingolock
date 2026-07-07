// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "WordOfTheDay",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        // App targets must be exposed as library products in SwiftPM for xtool.
        .library(
            name: "WordOfTheDay",
            targets: ["WordOfTheDay"]
        ),
        .library(
            name: "WordOfTheDayWidget",
            targets: ["WordOfTheDayWidget"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Shared",
            path: "ios/Shared"
        ),
        .target(
            name: "WordOfTheDay",
            dependencies: [
                "Shared"
            ],
            path: "ios/WordOfTheDay"
        ),
        .target(
            name: "WordOfTheDayWidget",
            dependencies: [
                "Shared"
            ],
            path: "ios/WordOfTheDayWidget",
            swiftSettings: [
                .define("WIDGET_EXTENSION")
            ]
        )
    ]
)
