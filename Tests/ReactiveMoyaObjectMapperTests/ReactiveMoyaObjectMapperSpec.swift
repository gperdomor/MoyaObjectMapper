//
//  ReactiveMoyaObjectMapperSpec.swift
//  MoyaObjectMapper
//
//  Created by Gustavo Perdomo on 2/20/17.
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
import Quick
import Nimble
import ReactiveMoya
import ReactiveMoyaObjectMapper
import Moya

class ReactiveMoyaObjectMapperSpec: QuickSpec {
    override func spec() {
        describe("ReactiveMoyaObjectMapper") {
            var provider: ReactiveSwiftMoyaProvider<GitHub>!

            beforeEach {
                provider = ReactiveSwiftMoyaProvider<GitHub>(stubClosure: ReactiveSwiftMoyaProvider.immediatelyStub)
            }

            describe("Map to Object") {
                var repo: Repository?
                var error: MoyaError?

                beforeEach {
                    repo = nil
                    error = nil
                }

                it("Can map response to object") {
                    waitUntil { done in
                        provider
                            .request(GitHub.repo(fullName: "gperdomor/sygnaler", keyPath: false))
                            .map(to: Repository.self)
                            .start { event in
                                switch event {
                                case .value(let object):
                                    repo = object
                                case .completed:
                                    done()
                                default: break
                                }
                        }
                    }

                    expect(repo).toNot(beNil())
                    expect(repo?.identifier).to(equal(1))
                    expect(repo?.name).to(equal("sygnaler"))
                    expect(repo?.fullName).to(equal("gperdomor/sygnaler"))
                    expect(repo?.language).to(equal("Swift"))

                }

                it("Can throws error if mapping fails") {
                    waitUntil { done in
                        provider
                            .request(GitHub.repo(fullName: "gperdomor/sygnaler", keyPath: true))
                            .map(to: Repository.self)
                            .start { event in
                                switch event {
                                case .value(let object):
                                    repo = object
                                case .failed(let e):
                                    error = e
                                    done()
                                default: break
                                }
                        }
                    }

                    expect(repo).to(beNil())
                    expect(error).toNot(beNil())
                    expect(error).to(beAnInstanceOf(MoyaError.self))
                }

                context("Optionals") {
                    it("Can map response to optional object") {
                        waitUntil { done in
                            provider
                                .request(GitHub.repo(fullName: "gperdomor/sygnaler", keyPath: false))
                                .mapOptional(to: Repository.self)
                                .start { event in
                                    switch event {
                                    case .value(let object):
                                        repo = object
                                    case .completed:
                                        done()
                                    default: break
                                    }
                            }
                        }

                        expect(repo).toNot(beNil())
                        expect(repo?.identifier).to(equal(1))
                        expect(repo?.name).to(equal("sygnaler"))
                        expect(repo?.fullName).to(equal("gperdomor/sygnaler"))
                        expect(repo?.language).to(equal("Swift"))

                    }

                    it("Can return nil if mapping fails") {
                        waitUntil { done in
                            provider
                                .request(GitHub.repo(fullName: "gperdomor/sygnaler", keyPath: true))
                                .mapOptional(to: Repository.self)
                                .start { event in
                                    switch event {
                                    case .value(let object):
                                        repo = object
                                        done()
                                    default: break
                                    }
                            }
                        }

                        expect(repo).to(beNil())
                    }
                }
            }

            describe("Map to Array") {
                var repos: [Repository]?
                var error: MoyaError?

                beforeEach {
                    repos = nil
                    error = nil
                }

                it("can mapped to array of objects") {
                    waitUntil { done in
                        provider
                            .request(GitHub.repos(username: "gperdomor", keyPath: false))
                            .map(to: [Repository.self])
                            .start { event in
                                switch event {
                                case .value(let objects):
                                    repos = objects
                                case .completed:
                                    done()
                                default: break
                                }
                        }
                    }

                    expect(repos).toNot(beNil())
                    expect(repos?.count).to(equal(1))
                    expect(repos?[0].identifier).to(equal(1))
                    expect(repos?[0].name).to(equal("sygnaler"))
                    expect(repos?[0].fullName).to(equal("gperdomor/sygnaler"))
                    expect(repos?[0].language).to(equal("Swift"))
                }

                it("Can throws error if mapping fails") {
                    waitUntil { done in
                        provider
                            .request(GitHub.repos(username: "gperdomor", keyPath: true))
                            .map(to: [Repository.self])
                            .start { event in
                                switch event {
                                case .value(let object):
                                    repos = object
                                case .failed(let e):
                                    error = e
                                    done()
                                default: break
                                }
                        }
                    }

                    expect(repos).to(beNil())
                    expect(error).toNot(beNil())
                    expect(error).to(beAnInstanceOf(MoyaError.self))
                }

                context("Optionals") {
                    it("can mapped to array of objects") {
                        waitUntil { done in
                            provider
                                .request(GitHub.repos(username: "gperdomor", keyPath: false))
                                .mapOptional(to: [Repository.self])
                                .start { event in
                                    switch event {
                                    case .value(let objects):
                                        repos = objects
                                    case .completed:
                                        done()
                                    default: break
                                    }
                            }
                        }

                        expect(repos).toNot(beNil())
                        expect(repos?.count).to(equal(1))
                        expect(repos?[0].identifier).to(equal(1))
                        expect(repos?[0].name).to(equal("sygnaler"))
                        expect(repos?[0].fullName).to(equal("gperdomor/sygnaler"))
                        expect(repos?[0].language).to(equal("Swift"))
                    }

                    it("Can return nil if mapping fails") {
                        waitUntil { done in
                            provider
                                .request(GitHub.repos(username: "gperdomor", keyPath: true))
                                .mapOptional(to: [Repository.self])
                                .start { event in
                                    switch event {
                                    case .value(let object):
                                        repos = object
                                        done()
                                    default: break
                                    }
                            }
                        }

                        expect(repos).to(beNil())
                    }
                }
            }
        }
    }
}
