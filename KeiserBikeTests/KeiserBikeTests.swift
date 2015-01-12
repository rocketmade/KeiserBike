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
    
    func testExample() {
        
        //Sample test data taken from the Keiser developer website
        let bytes: [UInt8] = [0x02, 0x01, 0x06, 0x13, 0x00, 0x38, 0x38, 0x03, 0x46, 0x05, 0x73, 0x00, 0x0D, 0x00, 0x04, 0x27, 0x01, 0x00, 0x0A]
        var testData = NSMutableData(bytes: bytes, length: bytes.count)
        let bikeData = BikeData.fromNSData(testData)
        XCTAssert(bikeData.buildMajor == 6, "")
        XCTAssert(bikeData.buildMinor == 19, "")
        XCTAssert(bikeData.dataType == 0, "")
        XCTAssert(bikeData.bikeId == 56, "")
        XCTAssert(bikeData.rpm == 82.4, "")
        XCTAssert(bikeData.heartRate == 135.0, "")
        XCTAssert(bikeData.power == 115, "")
        XCTAssert(bikeData.kCal == 13, "")
        XCTAssert(bikeData.minutes == 4, "")
        XCTAssert(bikeData.seconds == 39, "")
        XCTAssert(bikeData.trip == 0.1, "")
        XCTAssert(bikeData.gear == 10, "")
    }
}
