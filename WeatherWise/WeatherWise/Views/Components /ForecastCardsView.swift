//
//  ForecastCardsView.swift
//  WeatherWise
//
//  Created by Taooufiq El moutaoouakil on 10/9/24.
//

import SwiftUI

struct ForecastCardsView: View {
    @Binding var selection: Int
    @ObservedObject var viewModel: WeatherViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                if selection == 0 {
                    ForEach(viewModel.currentWeather?.list.filter { forecast in
                        let date = convertStringToDate(forecast.dt_txt)
                        let hour = Calendar.current.component(.hour, from: date)
                        return hour != 0
                    } ?? []) { forecast in
                        ForecastCard(forecastPeriod: .hourly, viewModel: viewModel, weatherEntry: forecast)
                    }
                    .transition(.offset(x: -430))
                    .animation(Animation.easeInOut(duration: 0.6).delay(0.1), value: selection)
                }
                
                else {
                    ForEach(viewModel.currentWeather?.list.filter { forecast in
                        let date = convertStringToDate(forecast.dt_txt)
                        let day = Calendar.current.component(.day, from: date)
                        let today = Calendar.current.component(.day, from: Date())
                        return day != today
                    } ?? []) { forecast in
                        ForecastCard(forecastPeriod: .daily, viewModel: viewModel, weatherEntry: forecast)
                    }
                    .transition(.offset(x: 430))
                    .animation(Animation.easeInOut(duration: 0.6).delay(0.1), value: selection) 
                }
            }
            .padding(.vertical, 20)
        }
        .padding(.horizontal, 20)
    }
}
