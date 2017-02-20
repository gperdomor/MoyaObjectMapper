//
//  MoyaModelMapperTests.swift
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
import Quick
import Nimble
import Moya
import MoyaModelMapper

class MoyaModelMapperSpec: QuickSpec {
    let provider = MoyaProvider<GitHub>(stubClosure: MoyaProvider.immediatelyStub)
    
    override func spec() {
        describe("MoyaModelMapper") {
            it("can mapped to array of objects") {
                waitUntil { done in
                    self.provider.request(GitHub.repos(username: "gperdomor", keyPath: false)) { (result) in
                        if case .success(let response) = result {
                            do {
                                let repos = try response.map(to: [Repository.self])
                                expect(repos.count).to(equal(1))
                                expect(repos[0].identifier).to(equal(1))
                                expect(repos[0].name).to(equal("sygnaler"))
                                expect(repos[0].fullName).to(equal("gperdomor/sygnaler"))
                                expect(repos[0].language).to(equal("Swift"))
                            } catch {
                                expect(true).to(beFalse())
                            }
                            done()
                        }
                    }
                }
            }
            
            it("can mapped to array of objects with key path") {
                waitUntil { done in
                    self.provider.request(GitHub.repos(username: "gperdomor", keyPath: true)) { (result) in
                        if case .success(let response) = result {
                            do {
                                let repos = try response.map(to: [Repository.self], fromKey: "data")
                                expect(repos.count).to(equal(1))
                                expect(repos[0].identifier).to(equal(1))
                                expect(repos[0].name).to(equal("sygnaler"))
                                expect(repos[0].fullName).to(equal("gperdomor/sygnaler"))
                                expect(repos[0].language).to(equal("Swift"))
                            } catch {
                                expect(true).to(beFalse())
                            }
                            done()
                        }
                    }
                }
            }
            
            it("can mapped to objects") {
                waitUntil { done in
                    self.provider.request(GitHub.repo(fullName: "gperdomor/sygnaler", keyPath: false)) { (result) in
                        if case .success(let response) = result {
                            do {
                                let repo = try response.map(to: Repository.self)
                                expect(repo.identifier).to(equal(1))
                                expect(repo.name).to(equal("sygnaler"))
                                expect(repo.fullName).to(equal("gperdomor/sygnaler"))
                                expect(repo.language).to(equal("Swift"))
                            } catch {
                                expect(true).to(beFalse())
                            }
                            done()
                        }
                    }
                }
            }
            
            it("can mapped to objects") {
                waitUntil { done in
                    self.provider.request(GitHub.repo(fullName: "gperdomor/sygnaler", keyPath: true)) { (result) in
                        if case .success(let response) = result {
                            do {
                                let repo = try response.map(to: Repository.self, fromKey: "data")
                                expect(repo.identifier).to(equal(1))
                                expect(repo.name).to(equal("sygnaler"))
                                expect(repo.fullName).to(equal("gperdomor/sygnaler"))
                                expect(repo.language).to(equal("Swift"))
                            } catch {
                                expect(true).to(beFalse())
                            }
                            done()
                        }
                    }
                }
            }
            
            it("can throws error if keyPath not exists") {
                waitUntil { done in
                    self.provider.request(GitHub.repos(username: "gperdomor", keyPath: true)) { (result) in
                        if case .success(let response) = result {
                            do {
                                let repos = try response.map(to: [Repository.self], fromKey: "test")
                                expect(repos.count).to(equal(1))
                                expect(repos[0].identifier).to(equal(1))
                                expect(repos[0].name).to(equal("sygnaler"))
                                expect(repos[0].fullName).to(equal("gperdomor/sygnaler"))
                                expect(repos[0].language).to(equal("Swift"))
                            } catch {
                                expect(true).to(beTrue())
                            }
                            done()
                        }
                    }
                }
            }
        }
    }
}
