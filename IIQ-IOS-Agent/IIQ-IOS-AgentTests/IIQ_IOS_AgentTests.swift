//
//  IIQ_IOS_AgentTests.swift
//  IIQ-IOS-AgentTests
//
//  Created by Julian Rassolov on 23/12/2023.
//

import XCTest
@testable import IIQ_IOS_Agent

class IIQ_IOS_AgentTests: XCTestCase {
    
    let pid : Int64 = 123456789
    var iiqAgent: IIQAgent!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        iiqAgent = IIQAgent(partnerId: pid)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testConfigutationTest() {
        XCTAssertEqual(iiqAgent.getPartnerId(),pid)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
