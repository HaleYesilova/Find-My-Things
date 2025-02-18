//
//  ContentView.swift
//  Find My Things
//
//  Created by Halenur Yeşilova.
//

import SwiftUI
import CoreLocation
import MapKit

struct ContentView: View {
    @StateObject var bluetoothManager = BluetoothManager()
    @StateObject var locationManager = LocationManager()
    
    var body: some View {
        VStack {
            
            Text("Your Location:")
                .font(.headline)
            if let location = locationManager.currentLocation {
                Text("Lat: \(location.coordinate.latitude), Long: \(location.coordinate.longitude)")
                    .padding()
            } else {
                Text("Getting location...")
                    .padding()
            }
            
            Divider()
            
            
            Text("Nearby Bluetooth Devices:")
                .font(.headline)
                .padding()
            List(bluetoothManager.discoveredPeripherals, id: \.name) { peripheral in
                
                let proximityColor: Color = (peripheral.rssi?.intValue ?? -100) > -50 ? .green : .red
                
                HStack {
                    
                    Image(systemName: peripheral.name == "AirPods" ? "airpodspro" :
                           peripheral.name == "JBL Speaker" ? "speaker.wave.2.fill" :
                           "laptopcomputer")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(proximityColor)
                    
                    
                    Text(peripheral.name ?? "Unnamed Device")
                        .font(.subheadline)
                        .padding(.leading, 10)
                }
            }
            
            Divider()
            
            
            Text("Last Known Location of Device:")
                .font(.headline)
                .padding()
            
            MapView(lastKnownLocation: locationManager.currentLocation)
                .frame(height: 300)
        }
        .onAppear {
            bluetoothManager.centralManagerDidUpdateState(bluetoothManager.centralManager)
        }
        .padding()
    }
}

struct MapView: View {
    var lastKnownLocation: CLLocation?
    
    var body: some View {
        if let location = lastKnownLocation {
            Map(coordinateRegion: .constant(MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )))
        } else {
            Text("No location available")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
