//
//  TransformersAPITests.swift
//  AequilibriumTransformersTests
//
//  Created by Lucas Skierkowski on 30/12/2020.
//

import XCTest
@testable import AequilibriumTransformers

class TransformersAPITests: XCTestCase {

    var api = TransformersAPI(randomToken: true)

    func testCreateGetTransformer() {
        let exp = expectation(description: "API callback")
        api.createUpdateTransformer(Transformer(name: "TestGet", team: .Autobot, rank: 10, parametersValue: 10)) {[weak self] (transformer, error) in
            guard error == nil, let self = self else {
                XCTFail("Fail")
                exp.fulfill()
                return
            }

            self.api.getTransformers { (transformers, error) in
                if error != nil { XCTFail("Fail") }
                XCTAssert(transformers?.contains(where: { $0.name == "TestGet" }) ?? false)
                exp.fulfill()
            }
        }
        waitForExpectations(timeout: 20)
    }
    
    func testEditTransformer() {
        let exp = expectation(description: "API callback")
        api.createUpdateTransformer(Transformer(name: "TestEdit", team: .Autobot, rank: 10, parametersValue: 10)) {[weak self] (transformer, error) in
            guard error == nil, let transformer = transformer, let self = self else {
                XCTFail("Fail")
                exp.fulfill()
                return
            }
            
            XCTAssert(transformer.id != nil)
            var editTransformer = transformer
            editTransformer.name = "TestEdit2"
            self.api.createUpdateTransformer(editTransformer) { (transformerEdited, error) in
                if error != nil { XCTFail("Fail") }
                
                XCTAssert(transformerEdited?.name == "TestEdit2")
                exp.fulfill()
            }
        }
        waitForExpectations(timeout: 20)
    }
    
    func testDeleteTransformer() {
        let exp = expectation(description: "API callback")
        api.createUpdateTransformer(Transformer(name: "TestDelete", team: .Autobot, rank: 10, parametersValue: 10)) {[weak self] (transformer, error) in
            guard error == nil, let id = transformer?.id, let self = self else {
                XCTFail("Fail")
                exp.fulfill()
                return
            }
            
            self.api.deleteTransformer(id: id) { (error) in
                if error != nil { XCTFail("Fail") }
                exp.fulfill()
            }
        }
        waitForExpectations(timeout: 20)
    }
}
