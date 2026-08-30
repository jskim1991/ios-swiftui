//
//  color_mixer_appUITests.swift
//  color-mixer-appUITests
//
//  Created by jay on 8/29/26.
//

import XCTest

final class color_mixer_appUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testTypedValueAboveMaxIsClampedOnDone() throws {
        let app = XCUIApplication()
        app.launch()

        let redField = app.textFields["RedField"]
        XCTAssertTrue(redField.waitForExistence(timeout: 5))

        redField.tap()
        redField.typeText("999")
        app.staticTexts["Color Preview"].tap()

        XCTAssertEqual(redField.value as? String, "255")
    }

    @MainActor
    func testTypedValueInsideRangeIsPreservedOnDone() throws {
        let app = XCUIApplication()
        app.launch()

        let greenField = app.textFields["GreenField"]
        XCTAssertTrue(greenField.waitForExistence(timeout: 5))

        greenField.tap()
        greenField.typeText("128")
        app.staticTexts["Color Preview"].tap()

        XCTAssertEqual(greenField.value as? String, "128")
    }
}
