//
//  HomeView.swift
//  WeatherWise
//
//  Created by Taoufiq El moutaoouakil on 10/8/24.
//

import SwiftUI
import BottomSheet

enum BottomSheetPosition: CGFloat, CaseIterable {
    case top = 0.83
    case middle = 0.385
}

struct HomeView: View {
    @State var bottomSheetPosition: BottomSheetPosition = .middle
    @State var bottomSheetTranslation: CGFloat = BottomSheetPosition.middle.rawValue
    @State var hasDragged: Bool = false
    @ObservedObject var viewModel: WeatherViewModel
    
    var bottomSheetTranslationProrated: CGFloat {
        (bottomSheetTranslation - BottomSheetPosition.middle.rawValue) / (BottomSheetPosition.top.rawValue - BottomSheetPosition.middle.rawValue)
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                let screenHeight = geometry.size.height + geometry.safeAreaInsets.top + geometry.safeAreaInsets.bottom
                let imageOffset = screenHeight + 36
                
                ZStack {
                    // MARK: Background Color
                    Color.background
                        .ignoresSafeArea()
                    
                    // MARK: Background Image
                    Image("Background")
                        .resizable()
                        .ignoresSafeArea()
                        .offset(y: -bottomSheetTranslationProrated * imageOffset)
                    
                    // MARK: House Image
                    Image("House")
                        .frame(maxHeight: .infinity, alignment: .top)
                        .padding(.top, 257)
                        .offset(y: -bottomSheetTranslationProrated * imageOffset)
                    
                    // MARK: Current Weather
                    VStack(spacing: -10 * (1 - bottomSheetTranslationProrated)) {
                        if let currentWeather = viewModel.currentWeather {
                            Text(currentWeather.city.name)
                                .font(.largeTitle)
                            
                            VStack {
                                Text(createAttributedString(temp: kelvinToCelsius(currentWeather.list.first?.main.temp ?? 0),
                                                            weather: currentWeather.list.first?.weather.first?.description.capitalized ?? ""))
                                .multilineTextAlignment(.center)
                                
                                if let maxTemp = currentWeather.list.first?.main.temp_max, let minTemp = currentWeather.list.first?.main.temp_min {
                                    Text("H:\(kelvinToCelsius(maxTemp), specifier: "%.0f")°   L:\(kelvinToCelsius(minTemp), specifier: "%.0f")°")
                                        .font(.title3.weight(.semibold))
                                        .opacity(1 - bottomSheetTranslationProrated)
                                }
                            }
                        } else {
                            Text("Fetching Weather...")
                                .font(.largeTitle)
                        }
                        Spacer()
                    }.padding(.top, 51)
                        .offset(y: -bottomSheetTranslationProrated * 46)
                    
                    // MARK: Bottom Sheet
                    BottomSheetView(position: $bottomSheetPosition) {
                    } content: {
                        ForecastView(bottomSheetTranslationProrated: bottomSheetTranslationProrated,
                                     viewModel: viewModel)
                    }
                    .onBottomSheetDrag { translation in
                        bottomSheetTranslation = translation / screenHeight
                        
                        withAnimation(.easeInOut) {
                            hasDragged = bottomSheetPosition == .top
                        }
                    }
                    
                    // MARK: Tab Bar
                    TabBar(action: {
                        bottomSheetPosition = .top
                    }, viewModel: viewModel)
                    .offset(y: bottomSheetTranslationProrated * 115)
                }
            }
            .navigationBarHidden(true)
            .preferredColorScheme(.dark)
        }
        .onAppear {
            viewModel.fetchLocationWeather()
        }
    }
    
    private func createAttributedString(temp: Double, weather: String) -> AttributedString {
        var string = AttributedString("\(Int(temp))°" + (hasDragged ? " | " : "\n ") + weather)
        
        if let tempRange = string.range(of: "\(Int(temp))°") {
            string[tempRange].font = .system(size: (96 - (bottomSheetTranslationProrated * (96 - 20))), weight: hasDragged ? .semibold : .thin)
            string[tempRange].foregroundColor = hasDragged ? .secondary : .primary
        }
        
        if let pipeRange = string.range(of: " | ") {
            string[pipeRange].font = .title3.weight(.semibold)
            string[pipeRange].foregroundColor = .secondary.opacity(bottomSheetTranslationProrated)
        }
        
        if let weatherRange = string.range(of: weather) {
            string[weatherRange].font = .title3.weight(.semibold)
            string[weatherRange].foregroundColor = .secondary
        }
        
        return string
    }
    
}
