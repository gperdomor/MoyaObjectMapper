import PackageDescription

let package = Package(
    name: "MoyaModelMapper",
    targets: [
        Target(name: "MoyaModelMapper"),
        Target(name: "RxMoyaModelMapper", dependencies: ["MoyaModelMapper"]),
        Target(name: "ReactiveMoyaModelMapper", dependencies: ["MoyaModelMapper"])
    ],
    dependencies: [
        .Package(url: "https://github.com/Moya/Moya", majorVersion: 8),
        .Package(url: "https://github.com/lyft/mapper", majorVersion: 6)
    ]
)
