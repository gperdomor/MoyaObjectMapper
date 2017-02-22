# MoyaObjectMapper
[![Build Status](https://travis-ci.org/gperdomor/MoyaObjectMapper.svg?branch=master)](https://travis-ci.org/gperdomor/MoyaObjectMapper)
[![codecov](https://codecov.io/gh/gperdomor/MoyaObjectMapper/branch/master/graph/badge.svg)](https://codecov.io/gh/gperdomor/MoyaObjectMapper)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)

[ObjectMapper](https://github.com/Hearst-DD/ObjectMapper) bindings for 
[Moya](https://github.com/Moya/Moya) for easier JSON serialization. Includes
[RxSwift](https://github.com/ReactiveX/RxSwift) and [ReactiveSwift](https://github.com/ReactiveCocoa/ReactiveSwift) bindings as well.

# Installation

## CocoaPods
Use the following entry in your Podfile
```
pod 'MoyaObjectMapper', '1.0.0'
```

The subspec if you want to use the bindings over RxSwift.
```
pod 'MoyaObjectMapper/RxSwift', '1.0.0'
```

And the subspec if you want to use the bindings over ReactiveSwift.
```
pod 'MoyaObjectMapper/ReactiveSwift', '1.0.0'
```

# Usage

Create a model struct or class. It needs to implement protocol Mappable. More details about model creation [here](https://github.com/lyft/mapper/)

```swift
import Foundation
import ObjectMapper

struct Repository: Mappable {
    var identifier: Int!
    var name: String!
    var fullName: String!
    var language: String?
    
    init?(map: Map) {
        if map.JSON["id"] == nil {
            return nil
        }
    }
    
    mutating func mapping(map: Map) {
        identifier <- map["id"]
        name <- map["name"]
        fullName <- map["full_name"]
        language <- map["language"]
    }
}
```

Then you have methods that extends the response from Moya. These methods are:
```swift
map(to: type, context: MapContext? = nil) // map object
map(to: [type], context: MapContext? = nil) // map array of objects
```

For `RxSwift` and `ReactiveCocoa` additionally methods for optional mapping are provided.
These methods are:

```swift
mapOptional(to: type, context: MapContext? = nil)
mapOptional(to: [type], context: MapContext? = nil)
```

See examples below, or in a Demo project.

## 1. Normal usage (without RxSwift or ReactiveCocoa)

```swift
provider = MoyaProvider<GitHub>()
provider.request(GitHub.repos(username: "gperdomor")) { (result) in
    if case .success(let response) = result {
        do {
            let repos = try response.map(to: [Repository.self])
            print(repos)
        } catch Error.jsonMapping(let error) {
            print(try? error.mapString())
        } catch {
            print(":(")
        }
    }
}
```

## 2. RxSwift
```swift
provider = RxMoyaProvider<GitHub>()
provider.request(GitHub.repo(fullName: "gperdomor/sygnaler"))
        .map(to: Repository.self)
        .subscribe { event in
            switch event {
            case .next(let repo):
                print(repo)
            case .error(let error):
                print(error)
            default: break
            }
        }
```

Additionally, modules for `RxSwift` contains optional mappings. It basically means that if the mapping fails, mapper doesn't throw errors but returns nil. For instance:

```swift
provider = RxMoyaProvider<GitHub>()
provider
    .request(GitHub.repos(username: "gperdomor"))
    .mapOptional(to: [Repository.self])
    .subscribe { event in
        switch event {
        case .next(let repos):
            // Here we can have either nil or [Repository] object.
            print(repos)
        case .error(let error):
            print(error)
        default: break
        }
    }
```

## 3. ReactiveSwift
```swift
provider = ReactiveSwiftMoyaProvider<GitHub>()
provider
    .request(GitHub.repos(username: "gperdomor"))
    .map(to: [Repository.self])
    .start { event in
        switch event {
        case .value(let repos):
            print(repos)
        case .failed(let error):
            print(error)
        default: break
        }
    }
```

Additionally, modules for `ReactiveSwift` contains optional mappings. It basically means that if the mapping fails, mapper doesn't throw errors but returns nil. For instance:

```swift
provider = ReactiveSwiftMoyaProvider<GitHub>()
provider
    .request(GitHub.repos(username: "gperdomor"))
    .mapOptional(to: [Repository.self])
    .start { event in
        switch event {
        case .value(let repos):
            // Here we can have either nil or [Repository] object.
            print(repos)
        case .failed(let error):
            print(error)
        default: break
        }
    }
```

## Sample Project

There's a sample project in the Demo directory. To use it, run `pod install` to download the required libraries. Have fun!

## Contributing

Hey! Like MoyaObjectMapper? Awesome! We could actually really use your help!

Open source isn't just writing code. MoyaObjectMapper could use your help with any of the
following:

- Finding (and reporting!) bugs.
- New feature suggestions.
- Answering questions on issues.
- Documentation improvements.
- Reviewing pull requests.
- Helping to manage issue priorities.
- Fixing bugs/new features.

If any of that sounds cool to you, send a pull request! After a few
contributions, we'll add you as an admin to the repo so you can merge pull
requests and help steer the ship :ship:

## License

MoyaObjectMapper is available under the MIT license. See the LICENSE file for more info.
