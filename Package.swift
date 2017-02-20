import PackageDescription

let package = Package(
    name: "MoyaObjectMapper",
    targets: [
        Target(name: "MoyaObjectMapper"),
        Target(name: "RxMoyaObjectMapper", dependencies: ["MoyaObjectMapper"]),
        Target(name: "ReactiveMoyaObjectMapper", dependencies: ["MoyaObjectMapper"])
    ],
    dependencies: [
        .Package(url: "https://github.com/Quick/Nimble.git", majorVersion: 6),
        .Package(url: "https://github.com/Quick/Quick.git", majorVersion: 1),
        .Package(url: "https://github.com/Moya/Moya", majorVersion: 8),
        .Package(url: "https://github.com/Hearst-DD/ObjectMapper.git", majorVersion: 2, minor: 2)
    ],
    exclude: [
        "Carthage",
        "Configs",
        "Demo",
        "scripts"
    ]
)
