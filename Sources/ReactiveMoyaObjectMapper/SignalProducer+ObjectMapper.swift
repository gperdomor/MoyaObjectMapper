//
//  SignalProducer+ObjectMapper.swift
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
import ReactiveSwift
import Moya
import ObjectMapper
import MoyaObjectMapper

extension SignalProducerProtocol where Value == Moya.Response, Error == MoyaError {

    /// Maps data received from the signal into an object which implements the Mappable protocol.
    ///
    /// - Parameters:
    ///   - type: Type of the object which implements the Mappable protocol.
    ///   - context: The map context.
    /// - Returns: Signal with the object as value or error if the data can't be mapped.
    public func map<T: Mappable>(to type: T.Type, context: MapContext? = nil) -> SignalProducer<T, MoyaError> {
        return producer.flatMap(.latest) { response -> SignalProducer<T, Error> in
            return unwrapThrowable { try response.map(to: type, context: context) }
        }
    }

    /// Maps data received from the signal into an array of objects which implements the Mappable protocol
    ///
    /// - Parameters:
    ///   - type: Type of the object which implements the Mappable protocol
    ///   - context: The map context.
    /// - Returns: Signal with the array as value or error if the data can't be mapped.
    public func map<T: Mappable>(to type: [T.Type], context: MapContext? = nil) -> SignalProducer<[T], MoyaError> {
        return producer.flatMap(.latest) { response -> SignalProducer<[T], Error> in
            return unwrapThrowable { try response.map(to: type, context: context) }
        }
    }

    /// Maps data received from the signal into an object which implements the Mappable protocol.
    ///
    /// - Parameters:
    ///   - type: Type of the object which implements the Mappable protocol.
    ///   - context: The map context.
    /// - Returns: Signal with the object or nil, as value.
    public func mapOptional<T: Mappable>(to type: T.Type, context: MapContext? = nil) -> SignalProducer<T?, MoyaError> {
        return producer.flatMap(.latest) { response -> SignalProducer<T?, Error> in
            return unwrapOptionalThrowable { try response.map(to: type, context: context) }
        }
    }

    /// Maps data received from the signal into an array of objects which implements the Mappable protocol.
    ///
    /// - Parameters:
    ///   - type: Type of the object which implements the Mappable protocol.
    ///   - context: The map context.
    /// - Returns: Signal with the array or nil as value.
    public func mapOptional<T: Mappable>(to type: [T.Type], context: MapContext? = nil) -> SignalProducer<[T]?, MoyaError> {
        return producer.flatMap(.latest) { response -> SignalProducer<[T]?, Error> in
            return unwrapOptionalThrowable { try response.map(to: type, context: context) }
        }
    }
}

// Maps throwable to SignalProducer
///
/// - Parameter throwable: Throwable closure
/// - Returns: SignalProducer
private func unwrapThrowable<T>(throwable: () throws -> T) -> SignalProducer<T, MoyaError> {
    do {
        return SignalProducer(value: try throwable())
    } catch {
        return SignalProducer(error: error as! MoyaError)
    }
}

/// Maps throwable to SignalProducer
///
/// - Parameter throwable: Throwable closure
/// - Returns: SignalProducer
private func unwrapOptionalThrowable<T>(throwable: () throws -> T) -> SignalProducer<T?, MoyaError> {
    do {
        return SignalProducer(value: try throwable())
    } catch {
        return SignalProducer(value: nil)
    }
}
