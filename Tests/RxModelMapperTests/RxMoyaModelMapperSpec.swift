//
//  RxMoyaModelMapperTests.swift
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
import RxMoya
import RxMoyaModelMapper
import RxBlocking

class RxMoyaModelMapperSpec: QuickSpec {
    let provider = RxMoyaProvider<GitHub>(stubClosure: RxMoyaProvider.immediatelyStub)
    
    override func spec() {
        describe("RxMoyaModelMapper") {
            it("can mapped to array of objects") {
                do {
                    let repos: [Repository]!
                    
                    repos = try self.provider.request(GitHub.repos(username: "gperdomor", keyPath: false))
                        .map(to: [Repository.self])
                        .toBlocking()
                        .single()
                    
                    expect(repos!.count).to(equal(1))
                    expect(repos![0].identifier).to(equal(1))
                    expect(repos![0].name).to(equal("sygnaler"))
                    expect(repos![0].fullName).to(equal("gperdomor/sygnaler"))
                    expect(repos![0].language).to(equal("Swift"))
                    
                } catch {
                    expect(true).to(beFalse())
                }
            }
            
            it("can mapped to array of objects with key path") {
                do {
                    let repos: [Repository]!
                    
                    repos = try self.provider.request(GitHub.repos(username: "gperdomor", keyPath: true))
                        .map(to: [Repository.self], fromKey: "data")
                        .toBlocking()
                        .single()
                    
                    expect(repos.count).to(equal(1))
                    expect(repos[0].identifier).to(equal(1))
                    expect(repos[0].name).to(equal("sygnaler"))
                    expect(repos[0].fullName).to(equal("gperdomor/sygnaler"))
                    expect(repos[0].language).to(equal("Swift"))
                    
                } catch {
                    expect(true).to(beFalse())
                }
            }
            
            it("can mapped to objects") {
                do {
                    let repo: Repository!
                    
                    repo = try self.provider.request(GitHub.repo(fullName: "gperdomor/sygnaler", keyPath: false))
                        .map(to: Repository.self)
                        .toBlocking()
                        .single()
                    
                    expect(repo.identifier).to(equal(1))
                    expect(repo.name).to(equal("sygnaler"))
                    expect(repo.fullName).to(equal("gperdomor/sygnaler"))
                    expect(repo.language).to(equal("Swift"))
                    
                } catch {
                    expect(true).to(beFalse())
                }
            }
            
            it("can mapped to objects") {
                do {
                    let repo: Repository!
                    
                    repo = try self.provider.request(GitHub.repo(fullName: "gperdomor/sygnaler", keyPath: true))
                        .map(to: Repository.self, fromKey: "data")
                        .toBlocking()
                        .single()
                    
                    expect(repo.identifier).to(equal(1))
                    expect(repo.name).to(equal("sygnaler"))
                    expect(repo.fullName).to(equal("gperdomor/sygnaler"))
                    expect(repo.language).to(equal("Swift"))
                    
                } catch {
                    expect(true).to(beFalse())
                }
            }
            
            it("can throws error if keyPath not exists") {
                do {
                    let repo: Repository!
                    
                    repo = try self.provider.request(GitHub.repo(fullName: "gperdomor/sygnaler", keyPath: true))
                        .map(to: Repository.self, fromKey: "tests")
                        .toBlocking()
                        .single()
                    
                    expect(repo.identifier).to(equal(1))
                    expect(repo.name).to(equal("sygnaler"))
                    expect(repo.fullName).to(equal("gperdomor/sygnaler"))
                    expect(repo.language).to(equal("Swift"))
                    
                } catch {
                    expect(true).to(beTrue())
                }
            }
            
            it("can map optionals") {
                do {
                    var repo: Repository?
                    
                    repo = try self.provider.request(GitHub.repo(fullName: "gperdomor/sygnaler", keyPath: true))
                        .mapOptional(to: Repository.self, fromKey: "tests")
                        .toBlocking()
                        .single()!
                    
                    expect(repo).to(beNil())
                    
                    repo = try self.provider.request(GitHub.repo(fullName: "gperdomor/sygnaler", keyPath: true))
                        .mapOptional(to: Repository.self, fromKey: "data")
                        .toBlocking()
                        .single()!
                    
                    expect(repo).toNot(beNil())
                } catch {
                    expect(true).to(beTrue())
                }
            }
        }
    }
}
