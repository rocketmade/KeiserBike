//
//  ViewController.swift
//  KeiserTest
//
//  Created by Brandon Roth on 1/8/15.
//  Copyright (c) 2015 Brandon Roth. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, KeiserBikeManagerDelegate {
    
    var bikeManager: KeiserBikeManager!
    
    @IBOutlet weak var rpm: UITextField!
    @IBOutlet weak var power: UITextField!
    @IBOutlet weak var kCal: UITextField!
    @IBOutlet weak var trip: UITextField!
    @IBOutlet weak var gear: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        bikeManager = KeiserBikeManager(delegate: self)
        
        for field in [rpm,power,kCal,trip,gear] {
            field.userInteractionEnabled = false
        }
    }
    
    func didRecieveBikeData(data: BikeData, device: CBPeripheral) {
        println("Bike data for bike \(device.identifier.UUIDString)\n\(data.description())\n")
        
        rpm.text = "\(data.rpm)"
        power.text = "\(data.power)"
        kCal.text = "\(data.kCal)"
        trip.text = "\(data.minutes):\(data.seconds)"
        gear.text = "\(data.gear)"
    }
}

