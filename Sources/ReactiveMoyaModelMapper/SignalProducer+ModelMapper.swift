//
//  SignalProducer+ModelMapper.swift
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
import ReactiveSwift
import Moya
import Mapper
import MoyaModelMapper

extension SignalProducerProtocol where Value == Moya.Response, Error == MoyaError {
    
    public func map<T: Mappable>(to type: T.Type, fromKey keyPath: String? = nil) -> SignalProducer<T, MoyaError> {
        return producer.flatMap(.latest) { response -> SignalProducer<T, Error> in
            return unwrapThrowable { try response.map(to: type, fromKey: keyPath) }
        }
    }
    
    public func map<T: Mappable>(to type: [T.Type], fromKey keyPath: String? = nil) -> SignalProducer<[T], MoyaError> {
        return producer.flatMap(.latest) { response -> SignalProducer<[T], Error> in
            return unwrapThrowable { try response.map(to: type, fromKey: keyPath) }
        }
    }
    
    public func mapOptional<T: Mappable>(to type: T.Type, fromKey keyPath: String? = nil) -> SignalProducer<T?, MoyaError> {
        return producer.flatMap(.latest) { response -> SignalProducer<T?, Error> in
            return unwrapOptionalThrowable { try response.map(to: type, fromKey: keyPath) }
        }
    }
    
    public func mapOptional<T: Mappable>(to type: [T.Type], fromKey keyPath: String? = nil) -> SignalProducer<[T]?, MoyaError> {
        return producer.flatMap(.latest) { response -> SignalProducer<[T]?, Error> in
            return unwrapOptionalThrowable { try response.map(to: type, fromKey: keyPath) }
        }
    }
}

private func unwrapThrowable<T>(throwable: () throws -> T) -> SignalProducer<T, MoyaError> {
    do {
        return SignalProducer(value: try throwable())
    } catch {
        return SignalProducer(error: error as! MoyaError)
    }
}

private func unwrapOptionalThrowable<T>(throwable: () throws -> T) -> SignalProducer<T?, MoyaError> {
    do {
        return SignalProducer(value: try throwable())
    } catch {
        return SignalProducer(value: nil)
    }
}
