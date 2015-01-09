//
//  KeiserBikeManager.swift
//  KeiserTest
//
//  Created by Brandon Roth on 1/9/15.
//  Copyright (c) 2015 Brandon Roth. All rights reserved.
//

import Foundation
import CoreBluetooth

protocol KeiserBikeManagerDelegate {
    func didRecieveBikeData(data: BikeData, device: CBPeripheral)
}

class KeiserBikeManager: NSObject, CBCentralManagerDelegate {
    
    var delegate: KeiserBikeManagerDelegate?
    private lazy var manager = CBCentralManager()
    
    //Upon initialization automatically starts scanning for bikes
    init(delegate: KeiserBikeManagerDelegate) {
        super.init()
        //we are in a Swift initalizer conumdrum here.  We need to init our member variables before calling super but we can't
        //call super because our initalization requires us to reference self.  A simple solution is to declare the manager as
        //lazy so we can bypass the swift requirement
        self.delegate = delegate
        manager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func isReady() -> Bool {
        return manager.state == CBCentralManagerState.PoweredOn
    }
    
    func start() {
        self.manager.scanForPeripheralsWithServices(nil, options: nil)
    }
    
    func stop() {
        self.manager.stopScan()
    }
    
    func centralManagerDidUpdateState(central: CBCentralManager!) {
        if central.state == CBCentralManagerState.PoweredOn {
            self.manager.scanForPeripheralsWithServices(nil, options: nil)
        }
    }
    
    func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
        
        if let name = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
            if name == "M3" {
                let uuid = peripheral.identifier.UUIDString
                let data = advertisementData[CBAdvertisementDataManufacturerDataKey] as NSData
                
                if let d = delegate {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        d.didRecieveBikeData(BikeData.fromNSData(data), device: peripheral)
                    })
                }
            }
        }
    }
}

struct BikeData {
    let buildMajor: UInt8
    let buildMinor: UInt8
    let dataType: UInt8
    let bikeId: UInt8
    let rpm: Float
    let heartRate: Float
    let power: UInt16
    let kCal: UInt16
    let minutes: UInt8
    let seconds: UInt8
    let trip: Float
    let gear: UInt8
    
    static func fromNSData(data: NSData) -> BikeData {
        
        //Data has to be 19 bytes accoring to specs and for memcpy to work as expected
        assert(data.length == 19, "Data was not the correct length, expected length 19, got \(data.length)")
        
        //a temp struct laid out the same as in the specifcation so we can just use a memcpy to extract all the values
        //We could just return this temp struct as the main data type but by re-wrapping it we get the correct data types (floats)
        //and don't have to deal with things like endianess.  It's possible to strip the first two bytes (prefix bits) from the incoming
        //data but it's just extra code and complexity when we can just add it to the struct and ignore it's value.
        struct TempBikeDataStruct {
            var prefixBits: UInt16 = 0
            var buildMajor: UInt8 = 0
            var buildMinor: UInt8 = 0
            var dataType: UInt8 = 0
            var bikeId: UInt8 = 0
            var rpm: UInt16 = 0
            var heartRate: UInt16 = 0
            var power: UInt16 = 0
            var kCal: UInt16 = 0
            var minutes: UInt8 = 0
            var seconds: UInt8 = 0
            var trip: UInt16 = 0
            var gear: UInt8 = 0
        }
        
        var t = TempBikeDataStruct()
        memcpy(&t, data.bytes, UInt(data.length))
        
        return BikeData(buildMajor: t.buildMajor,
            buildMinor: t.buildMinor,
            dataType: t.dataType,
            bikeId: t.bikeId,
            rpm: Float(t.rpm) / 10.0,
            heartRate: Float(t.heartRate) / 10.0,
            power: t.power,
            kCal: t.kCal,
            minutes: t.minutes,
            seconds: t.seconds,
            trip: Float(t.trip) / 10.0,
            gear: t.gear)
    }
    
    func description() -> String {
        var string: String = "BuildMajor: \(buildMajor)\nBuildMinor: \(buildMinor)\nDataType: \(dataType)\nBikeID: \(bikeId)\nRPM: \(rpm)\nHeartRate: \(heartRate)\nPower: \(power)\nKcal: \(kCal)\nTime: \(minutes):\(seconds)\nTrip: \(trip)\nGear: \(gear)"
        
        return string
    }
}