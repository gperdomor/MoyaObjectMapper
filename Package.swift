import PackageDescription

let package = Package(
    name: "MoyaModelMapper",
    targets: [
        Target(name: "MoyaModelMapper"),
        Target(name: "RxMoyaModelMapper", dependencies: ["MoyaModelMapper"]),
        Target(name: "ReactiveMoyaModelMapper", dependencies: ["MoyaModelMapper"])
    ],
    dependencies: [
        .Package(url: "https://github.com/Quick/Nimble.git", majorVersion: 6),
        .Package(url: "https://github.com/Quick/Quick.git", majorVersion: 1),
        .Package(url: "https://github.com/Moya/Moya", majorVersion: 8),
        .Package(url: "https://github.com/lyft/mapper", majorVersion: 6)
    ],
    exclude: [
        "Carthage",
        "Configs",
        "Demo",
        "scripts"
    ]
)
