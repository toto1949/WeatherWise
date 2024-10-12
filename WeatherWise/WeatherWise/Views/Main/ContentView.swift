//
//  ContentView.swift
//  WeatherWise
//
//  Created by Taooufiq El moutaoouakil on 10/7/24.
//



import SwiftUI

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    
    var body: some View {
        HomeView(viewModel: WeatherViewModel(locationManager: locationManager))
            .environmentObject(locationManager)
    }
}
