//
//  WeatherApp_Jimenez_CarlosUITestsLaunchTests.swift
//  WeatherApp_Jimenez_CarlosUITests
//
//  Created by Carlos Jimenez on 10/19/21.
//

import XCTest

class WeatherApp_Jimenez_CarlosUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
