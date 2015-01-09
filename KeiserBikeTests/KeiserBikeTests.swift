//
//  KeiserBikeTests.swift
//  KeiserBikeTests
//
//  Created by Brandon Roth on 1/9/15.
//  Copyright (c) 2015 Rocketmade. All rights reserved.
//

import UIKit
import XCTest

class KeiserBikeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        
        let bytes: [UInt8] = [0x02, 0x01, 0x06, 0x13, 0x00, 0x38, 0x38, 0x03, 0x46, 0x05, 0x73, 0x00, 0x0D, 0x00, 0x04, 0x27, 0x01, 0x00, 0x0A]
        var testData = NSMutableData(bytes: bytes, length: bytes.count)
        let bikeData = BikeData.fromNSData(testData)
        assert(bikeData.buildMajor == 6, "")
        assert(bikeData.buildMinor == 19, "")
        assert(bikeData.dataType == 0, "")
        assert(bikeData.bikeId == 56, "")
        assert(bikeData.rpm == 82.4, "")
        assert(bikeData.heartRate == 135.0, "")
        assert(bikeData.power == 115, "")
        assert(bikeData.kCal == 13, "")
        assert(bikeData.minutes == 4, "")
        assert(bikeData.seconds == 39, "")
        assert(bikeData.trip == 0.1, "")
        assert(bikeData.gear == 10, "")
    }
}
