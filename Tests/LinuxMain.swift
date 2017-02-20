import XCTest
import Quick
@testable import MoyaModelMapperTests
@testable import ReactiveMoyaModelMapperTests
@testable import RxMoyaModelMapperTests

Quick.QCKMain([
    MoyaModelMapperSpec.self,
    ReactiveMoyaModelMapperSpec.self,
    RxMoyaModelMapperSpec.self
])
