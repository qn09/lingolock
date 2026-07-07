// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "WordOfTheDay",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "WordOfTheDay",
            targets: ["WordOfTheDay"]
        ),
        .library(
            name: "WordOfTheDayWidget",
            targets: ["WordOfTheDayWidget"]
        ),
        .executable(
            name: "TestFetch",
            targets: ["TestFetch"]
        )
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
        ),
        .executableTarget(
            name: "TestFetch",
            dependencies: [
                "Shared"
            ],
            path: "ios/TestFetch"
        )
    ]
)
