//
//  AequilibriumTransformersUITests.swift
//  AequilibriumTransformersUITests
//
//  Created by Lucas Skierkowski on 30/12/2020.
//

import XCTest

class AequilibriumTransformersUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments += ["UI-TESTING"]
        app.launch()
    }
    
    func testTransformersListCount() {
        XCTAssertEqual(app.tables.children(matching: .cell).count, 6)
    }
    
    func testAddNewTransformer() {
        app.navigationBars["Transformers"].buttons["Add"].tap()
        app.tables.cells.containing(.staticText, identifier: "Name").children(matching: .textField).element.tap()
        app.tables.cells.containing(.staticText, identifier: "Name").children(matching: .textField).element.typeText("UITest")
        app.navigationBars["New"].buttons["Save"].tap()
        XCTAssert(app.tables.cells.containing(.staticText, identifier: "UITest").firstMatch.exists)
    }
    
    func testAddNewTransformerWithoutName() {
        app.navigationBars["Transformers"].buttons["Add"].tap()
        app.navigationBars["New"].buttons["Save"].tap()
        XCTAssert(app.alerts.containing(.staticText, identifier: "Please provide name").firstMatch.exists)
    }
    
    func testEditTransformer() {
        app.tables.cells.containing(.staticText, identifier: "Autobot1").element.tap()
        app.tables.cells.containing(.staticText, identifier: "Name").children(matching: .textField).element.tap()
        app.tables.cells.containing(.staticText, identifier: "Name").children(matching: .textField).element.typeText("23")
        app.navigationBars["Edit"].buttons["Save"].tap()
        XCTAssert(app.tables.cells.containing(.staticText, identifier: "Autobot123").firstMatch.exists)
    }
    
    func testDeleteTransformer() {
        app.tables.cells.containing(.staticText, identifier: "Autobot1").element.swipeLeft()
        app.tables.cells.containing(.staticText, identifier: "Autobot1").element.buttons["Delete"].tap()
        XCTAssertFalse(app.tables.cells.containing(.staticText, identifier: "Autobot1").firstMatch.exists)
    }
    
    func testBattleResult() {
        app.buttons["Start battle!"].tap()
        XCTAssert(app.scrollViews.containing(.staticText, identifier: "3 battles").firstMatch.exists)
        XCTAssert(app.scrollViews.containing(.staticText, identifier: "Winning team (Autobots): Autobot1, Autobot2, Autobot3").firstMatch.exists)
        XCTAssert(app.scrollViews.containing(.staticText, identifier: "Survivors from the losing team (Decepticons):").firstMatch.exists)
    }
}
