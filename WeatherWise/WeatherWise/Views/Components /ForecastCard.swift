//
//  ForecastCard.swift
//  WeatherWise
//
//  Created by Taoufiq El Moutaouakil on 10/8/24.
//



import SwiftUI

struct ForecastCard: View {
    var forecastPeriod: ForecastPeriod
    @ObservedObject var viewModel: WeatherViewModel
    var weatherEntry: WeatherEntry
    @StateObject var cacheViewModel = CacheViewModel()

    var isActive: Bool {
        let dateToCompare = convertStringToDate(weatherEntry.dt_txt)
        if forecastPeriod == .hourly {
            return Calendar.current.isDate(.now, equalTo: dateToCompare, toGranularity: .hour)
        } else {
            return Calendar.current.isDate(.now, equalTo: dateToCompare, toGranularity: .day)
        }
    }

    var forecastDateText: String {
        convertStringToDate(weatherEntry.dt_txt).formatted(forecastPeriod == .hourly ? .dateTime.hour() : .dateTime.weekday())
    }

    var temperatureText: String {
         String(format: "%.0f°", kelvinToCelsius(weatherEntry.main.temp))
    }

    var popValue: Double {
        return Double(weatherEntry.pop)
    }

    var body: some View {
        ZStack {
            // MARK: Card
            RoundedRectangle(cornerRadius: 30)
                         .fill(Color.forecastCardBackground.opacity(isActive ? 1 : 0.2))
                         .frame(width: 60, height: 146)
                         .shadow(color: .black.opacity(0.25), radius: 10, x: 5, y: 4)
                         .overlay {
                             // MARK: Card Border
                             RoundedRectangle(cornerRadius: 30)
                                 .strokeBorder(.white.opacity(isActive ? 0.5 : 0.2))
                                 .blendMode(.overlay)
                         }
                         .innerShadow(shape: RoundedRectangle(cornerRadius: 30), color: .white.opacity(0.25), lineWidth: 1, offsetX: 1, offsetY: 1, blur: 0, blendMode: .overlay)
                     

            // MARK: Content
            VStack(spacing: 16) {
                // MARK: Forecast Date
                Text(forecastDateText)
                    .font(.subheadline.weight(.semibold))

                VStack(spacing: -4) {
                    // MARK: Forecast Small Icon
                    if let iconCode = weatherEntry.weather.first?.icon {
                        let cacheKey = NSString(string: iconCode)
                        if let cachedImage = cacheViewModel.manager.getImage(forKey: cacheKey) {
                            Image(uiImage: cachedImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                        } else if let iconURL = getWeatherIconURL(iconCode: iconCode) {
                            AsyncImage(url: iconURL) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 40, height: 40)
                                    .onAppear {
                                        if let uiImage = image.asUIImage() {
                                            cacheViewModel.cacheImage(uiImage, forKey: cacheKey)
                                        }
                                    }
                            } placeholder: {
                                ProgressView()
                            }
                        }
                    }

                    // MARK: Forecast Probability
                    Text(popValue, format: .percent)
                        .font(.footnote.weight(.semibold))
                        .foregroundColor(Color.probabilityText)
                        .opacity(popValue > 0 ? 1 : 0)
                }
                .frame(height: 42)

                // MARK: Forecast Temperature
                Text(temperatureText)
                    .font(.title3)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 16)
            .frame(width: 60, height: 146)
        }
    }
}
