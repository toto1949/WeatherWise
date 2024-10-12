//
//  WeatherView.swift
//  Weather
//
//  Created by Dara To on 2022-06-23.
//

import SwiftUI

struct WeatherView: View {
    @ObservedObject var viewModel: WeatherViewModel
    
    var searchResults: [WeatherEntry] {
        if viewModel.searchText.isEmpty {
            return viewModel.currentWeather?.list ?? []
        } else {
            return viewModel.currentWeather?.list.filter { entry in
                viewModel.currentWeather?.city.name.localizedCaseInsensitiveContains(viewModel.searchText) ?? false
            } ?? []
        }
    }
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    if viewModel.isLoading {
                        ProgressView("Loading...")
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.headline)
                            .padding()
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(8)
                    } else {
                        ForEach(searchResults) { weatherEntry in
                            WeatherWidget(weatherEntry: weatherEntry)
                        }
                    }
                }
                .padding(.top, 20)
                .padding(.horizontal)
            }
            .safeAreaInset(edge: .top) {
                EmptyView()
                    .frame(height: 110)
            }
        }
        .overlay {
            NavigationBar(searchText: $viewModel.searchText)
        }
        .navigationBarHidden(true)
    }
}
