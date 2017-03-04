//
//  Response+ObjectMapper.swift
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
import ObjectMapper

public extension Response {

    /// Maps data received from the server into an object which implements the Mappable protocol.
    ///
    /// - Parameters:
    ///   - type: Type of the object which implements the Mappable protocol.
    ///   - context: The mapping context.
    /// - Returns: The map context.
    /// - Throws: MoyaError if the response can't be mapped.
    public func map<T: Mappable>(to type: T.Type, context: MapContext? = nil) throws -> T {
        guard let data = try mapJSON() as? [String : Any],
            let object = Mapper<T>(context: context).map(JSONObject: data) else {
                throw MoyaError.jsonMapping(self)
        }

        return object
    }

    /// Maps data received from the server into an array of object which implements the Mappable protocol.
    ///
    /// - Parameters:
    ///   - type: Type of the object which implements the Mappable protocol.
    ///   - context: The mapping context.
    /// - Returns: The map context.
    /// - Throws: MoyaError if the response can't be mapped.
    public func map<T: Mappable>(to type: [T.Type], context: MapContext? = nil) throws -> [T] {
        guard let data = try mapJSON() as? [[String : Any]],
            let objects = Mapper<T>(context: context).mapArray(JSONArray: data) else {
                throw MoyaError.jsonMapping(self)
        }
        return objects

    }
}
