//
//  PizzabotTests.swift
//  PizzabotTests
//
//  Created by Anastasia Kovaleva on 16.09.21.
//

import XCTest
@testable import Pizzabot

class PizzabotTests: XCTestCase {

    private var pizzaBotVC: PizzabotViewController?

    override func setUpWithError() throws {
        try super.setUpWithError()
        pizzaBotVC = PizzabotViewController()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        pizzaBotVC = nil
    }

    func testPizzabot() {
        XCTAssertEqual(pizzaBotVC?.pizzabot(path: "5x5 (1, 3) (4, 4)"), "E N N N D E E E N D")
        XCTAssertEqual(pizzaBotVC?.pizzabot(path: "5x5 (1, 3) (4, 4)."), "E N N N D E E E N D")
        XCTAssertEqual(pizzaBotVC?.pizzabot(path: " 5x5 (1, 3) (4, 4) "), "E N N N D E E E N D")
        XCTAssertEqual(pizzaBotVC?.pizzabot(
                        path: "5x5 (0, 0) (1, 3) (4, 4) (4, 2) (4, 2) (0, 1) (3, 2) (2, 3) (4, 1)"),
                       "D E N N N D E E E N D S S D D W W W W S D E E E N D W N D E E S S D")
    }

    func testErrorPizzabot() {
        XCTAssertEqual(pizzaBotVC?.pizzabot(path: "3x3 (4, 4) (1, 4)"), nil)
        XCTAssertEqual(pizzaBotVC?.pizzabot(path: "5x5 (1, 2) 1, 4"), nil)
    }

    func testCoordinates() {
        let answer = [(x: 1, y: 3), (x: 4, y: 4)]
        pizzaBotVC?.getCoordinates(from: "5x5 (1, 3) (4, 4)")?.enumerated().forEach {
            XCTAssertEqual($0.element.x, answer[$0.offset].x)
            XCTAssertEqual($0.element.y, answer[$0.offset].y)
        }
    }

}
