import XCTest
import Quick
@testable import MoyaObjectMapperTests
@testable import ReactiveMoyaObjectMapperTests
@testable import RxMoyaObjectMapperTests

Quick.QCKMain([
    MoyaObjectMapperSpec.self,
    ReactiveMoyaObjectMapperSpec.self,
    RxMoyaObjectMapperSpec.self
])
