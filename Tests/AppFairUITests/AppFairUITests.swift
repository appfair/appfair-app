// This is free software: you can redistribute and/or modify it
// under the terms of the GNU General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import XCTest
import OSLog
import Foundation
@testable import AppFairUI

let logger: Logger = Logger(subsystem: "AppFairUI", category: "Tests")

@available(macOS 13, *)
final class AppFairUITests: XCTestCase {

    func testAppFairUI() throws {
        logger.log("running testAppFairUI")
        XCTAssertEqual(1 + 2, 3, "basic test")
    }

    func testDecodeType() throws {
        // load the TestData.json file from the Resources folder and decode it into a struct
        let resourceURL: URL = try XCTUnwrap(Bundle.module.url(forResource: "TestData", withExtension: "json"))
        let testData = try JSONDecoder().decode(TestData.self, from: Data(contentsOf: resourceURL))
        XCTAssertEqual("AppFairUI", testData.testModuleName)
    }

}

struct TestData : Codable, Hashable {
    var testModuleName: String
}
