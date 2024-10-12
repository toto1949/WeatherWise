//
//  ForecastView.swift
//  Weather
//
//  Created by Dara To on 2022-06-17.
//

import CoreFoundation
import SwiftUI
import Combine 


struct ForecastView: View {
    var bottomSheetTranslationProrated: CGFloat = 1
    @State private var selection = 0
    @ObservedObject var viewModel: WeatherViewModel
    
    var body: some View {
        ScrollView {
            
            VStack(spacing: 0) {
                // MARK: Segmented Control
                SegmentedControl(selection: $selection)
                
                // MARK: Forecast Cards
                ForecastCardsView(selection: $selection, viewModel: viewModel)
                
                // MARK: Forecast Widgets
                if let firstWeatherEntry = viewModel.currentWeather?.list.first,
                   let cityResponse = viewModel.currentWeather?.city {
                    WeatherWidgetView(weatherEntry: firstWeatherEntry, cityResponse: cityResponse)
                }
                
                
            }
            .backgroundBlur(radius: 25, opaque: true)
            .background(Color.bottomSheetBackground)
            .clipShape(RoundedRectangle(cornerRadius: 44))
            .innerShadow(shape: RoundedRectangle(cornerRadius: 44), color: Color.bottomSheetBorderMiddle, lineWidth: 1, offsetX: 0, offsetY: 1, blur: 0, blendMode: .overlay, opacity: 1 - bottomSheetTranslationProrated)
            .overlay {
                // MARK: Bottom Sheet Separator
                Divider()
                    .blendMode(.overlay)
                    .background(Color.bottomSheetBorderTop)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .clipShape(RoundedRectangle(cornerRadius: 44))
            }
            .overlay {
                // MARK: Drag Indicator
                RoundedRectangle(cornerRadius: 10)
                    .fill(.black.opacity(0.3))
                    .frame(width: 48, height: 5)
                    .frame(height: 20)
                    .frame(maxHeight: .infinity, alignment: .top)
            }
        }
    }}

