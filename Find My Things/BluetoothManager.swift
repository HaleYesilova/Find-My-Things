//
//  BluetoothManager.swift
//  Find My Things
//
//  Created by Halenur Yeşilova
import CoreBluetooth
import Foundation

class BluetoothManager: NSObject, CBCentralManagerDelegate, ObservableObject {
    var centralManager: CBCentralManager!
    @Published var discoveredPeripherals = [MockPeripheral]()
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        
        simulateBluetoothDevices()
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            central.scanForPeripherals(withServices: nil, options: nil)
        }
    }

    
    func simulateBluetoothDevices() {
        let mockPeripheral1 = MockPeripheral(name: "AirPods", rssi: -40)
        let mockPeripheral2 = MockPeripheral(name: "JBL Speaker", rssi: -70)
        let mockPeripheral3 = MockPeripheral(name: "Unknown Device", rssi: -60)
        
        discoveredPeripherals.append(mockPeripheral1)
        discoveredPeripherals.append(mockPeripheral2)
        discoveredPeripherals.append(mockPeripheral3)
    }
    
    
    class MockPeripheral {
        var name: String?
        var rssi: NSNumber?
        
        init(name: String, rssi: Int) {
            self.name = name
            self.rssi = NSNumber(value: rssi)
        }
    }
}



