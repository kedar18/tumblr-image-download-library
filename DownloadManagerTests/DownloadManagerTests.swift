//
//  DownloadManagerTests.swift
//  DownloadManagerTests
//
//  Created by Kedar Navgire on 14/01/17.
//  Copyright © 2017 kedar. All rights reserved.
//

import XCTest
@testable import DownloadManager

class DownloadManagerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExpectation()
    {
        let expect = expectation(description: "Download should be success")
        
        DownloadManager.downloadFrom(stringUrl: "http://\(Model.username).tumblr.com/api/read/json?num=\(10)", completion: {
             url,response,error in
        XCTAssertNil("Error occured \(error!.localizedDescription)")
        XCTAssertNotNil("Payload returns \(response!.debugDescription)")
        
        })
        
        expect.fulfill()
        
        waitForExpectations(timeout: 60, handler: {
            waitHandler in
            
            XCTAssertNotNil("Test timeout \(String(describing: waitHandler?.localizedDescription))")
        
        })
    }
    
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
