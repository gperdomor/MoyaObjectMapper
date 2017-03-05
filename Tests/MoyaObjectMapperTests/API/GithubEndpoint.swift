//
//  GithubEndpoint.swift
//  MoyaObjectMapper
//
//  Created by Gustavo Perdomo on 2/19/17.
//  Copyright (c) 2017 Gustavo Perdomo. Licensed under the MIT license, as follows:
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation
import Moya

private extension String {
    var URLEscapedString: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}

enum GitHub {
    case repos(username: String, keyPath: Bool)
    case repo(fullName: String, keyPath: Bool)
}

extension GitHub: TargetType {
    var baseURL: URL { return URL(string: "https://api.github.com")! }

    var path: String {
        switch self {
        case .repos(let name, _):
            return "/users/\(name.URLEscapedString)/repos"
        case .repo(let name, _):
            return "/repos/\(name)"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var parameters: [String: Any]? {
        return nil
    }

    var sampleData: Data {
        switch self {
        case .repos(_, let keyPath):
            if keyPath {
                return "{\"data\": [{\"id\": 1, \"name\": \"sygnaler\", \"full_name\": \"gperdomor/sygnaler\", \"language\": \"Swift\"}]}".data(using: .utf8)!
            }
            return "[{\"id\": 1, \"name\": \"sygnaler\", \"full_name\": \"gperdomor/sygnaler\", \"language\": \"Swift\"}]".data(using: .utf8)!
        case .repo(_, let keyPath):
            if keyPath {
                return "{\"data\": {\"id\": 1, \"name\": \"sygnaler\", \"full_name\": \"gperdomor/sygnaler\", \"language\": \"Swift\"}}".data(using: .utf8)!
            }
            return "{\"id\": 1, \"name\": \"sygnaler\", \"full_name\": \"gperdomor/sygnaler\", \"language\": \"Swift\"}".data(using: .utf8)!
        }
    }

    var task: Task {
        return .request
    }

    var parameterEncoding: ParameterEncoding {
        return JSONEncoding.default
    }
}
