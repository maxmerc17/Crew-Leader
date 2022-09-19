//
//  CacheCalculatorTests.swift
//  Crew LeaderTests
//
//  Created by Max Mercer on 2022-09-14.
//

import XCTest
@testable import Crew_Leader

final class CacheCalculatorTests: XCTestCase {
    var sut : CacheCalculator!
    var desiredTrees : Int = 15000
    var cuts = [
        (Species(name: "testSpecies", numTrees: 100, treesPerBundle: 10), 50),
        (Species(name: "testSpecies2", numTrees: 420, treesPerBundle: 20), 50)
    ]

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = CacheCalculator(desiredTrees: desiredTrees, cuts: cuts)
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testCutNumBoxes() throws {
        let newCut = Cut(tuple: cuts[0])
        
        var numBoxes = newCut.numBoxes(500)
        XCTAssertEqual(3, numBoxes)
        numBoxes = newCut.numBoxes(1000)
        XCTAssertEqual(5, numBoxes)
        numBoxes = newCut.numBoxes(1500)
        XCTAssertEqual(8, numBoxes)
        numBoxes = newCut.numBoxes(15000)
        XCTAssertEqual(75, numBoxes)
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
