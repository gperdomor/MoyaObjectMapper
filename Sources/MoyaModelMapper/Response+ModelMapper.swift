//
//  Response+ModelMapper.swift
//  MoyaModelMapper
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
import Mapper

public extension Response {
    public func map<T: Mappable>(to type: T.Type) throws -> T {
        guard let jsonDictionary = try mapJSON() as? NSDictionary,
            let object = T.from(jsonDictionary) else {
                throw MoyaError.jsonMapping(self)
        }
        
        return object
    }
    
    public func map<T: Mappable>(to type: T.Type, fromKey keyPath: String?) throws -> T {
        guard let keyPath = keyPath else { return try map(to: type) }
        
        guard let jsonDictionary = try mapJSON() as? NSDictionary,
            let objectDictionary = jsonDictionary.value(forKeyPath: keyPath) as? NSDictionary,
            let object = T.from(objectDictionary) else {
                throw MoyaError.jsonMapping(self)
        }
        
        return object
    }
    
    public func map<T: Mappable>(to type: [T.Type]) throws -> [T] {
        guard let data = try mapJSON() as? NSArray,
            let object = T.from(data) else {
                throw MoyaError.jsonMapping(self)
        }
        return object
        
    }
    
    public func map<T: Mappable>(to type: [T.Type], fromKey keyPath: String? = nil) throws -> [T] {
        guard let keyPath = keyPath else { return try map(to: type) }
        
        guard let data = try mapJSON() as? NSDictionary,
            let objectArray = data.value(forKeyPath: keyPath) as? NSArray,
            let object = T.from(objectArray) else {
                throw MoyaError.jsonMapping(self)
        }
        
        return object
    }
}
