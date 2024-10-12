//
//  WeatherWidgetView.swift
//  WeatherWise
//
//  Created by Taooufiq El moutaoouakil on 10/9/24.
//


import SwiftUI

struct WeatherWidgetView: View {
    var weatherEntry: WeatherEntry
    var cityResponse: CityResponse
    
    var body: some View {
        VStack(spacing: 16) {
            ForecastPanel(title: "AIR QUALITY", value: "3-Low Health Risk", backgroundColor: Color.background2, progress: 0.3)
            
            HStack(spacing: 16) {
                ForecastPanel(title: "UV INDEX", value: "\(Int(kelvinToCelsius(weatherEntry.main.temp)))°C", backgroundColor: Color.background1, icon: AnyView(SunIcon()))
                ForecastPanel(title: "SUNRISE & SUNSET", value: "\(formatTime(Double(cityResponse.sunrise)))  \(formatTime(Double(cityResponse.sunset)))", backgroundColor: Color.background1, icon: AnyView(SunriseIcon()))
            }
            
            HStack(spacing: 16) {
                ForecastPanel(title: "WIND", value: "\(weatherEntry.wind.speed) km/h", backgroundColor: Color.background1, icon: AnyView(WindSpeedIcon()))
                ForecastPanel(title: "RAINFALL", value: "\(weatherEntry.pop) mm", backgroundColor: Color.background1, icon: AnyView(RainDropIcon()))
            }
            
            HStack(spacing: 16) {
                ForecastPanel(title: "FEELS LIKE", value: "\(weatherEntry.main.feels_like)°", backgroundColor: Color.background1)
                ForecastPanel(title: "HUMIDITY", value: "\(weatherEntry.main.humidity)%\nDew Point: \(calculateDewPoint(temp: weatherEntry.main.temp, humidity: weatherEntry.main.humidity))°", backgroundColor: Color.background1, icon: AnyView(HumidityIcon()))
            }
            
            HStack(spacing: 16) {
                ForecastPanel(title: "VISIBILITY", value: "\(weatherEntry.main.temp_min) km\nSimilar to Actual", backgroundColor: Color.background1)
                ForecastPanel(title: "PRESSURE", value: "\(weatherEntry.main.pressure) hPa", backgroundColor: Color.background1, icon: AnyView(PressureIcon()))
            }
        }
        .padding()
        .background(Color.background)
        .cornerRadius(30)
        .shadow(color: .black.opacity(0.25), radius: 10, x: 5, y: 4)
    }
}

struct ForecastPanel: View {
    var title: String
    var value: String
    var backgroundColor: Color
    var icon: AnyView? = nil
    var progress: Double? = nil
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(backgroundColor)
                .frame(maxWidth: .infinity)
                .shadow(color: .black.opacity(0.3), radius: 10, x: 5, y: 4)
                .overlay {
                    RoundedRectangle(cornerRadius: 25)
                        .strokeBorder(.white.opacity(0.2))
                        .blendMode(.overlay)
                }

           
            VStack(alignment: .leading, spacing: 12) {
                
                if let icon = icon {
                    icon
                        .frame(width: 50, height: 50)
                        .padding(.bottom, 10)
                }

                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                
               
                Text(value)
                    .font(.title3)
                    .foregroundColor(.white)
                
                
                if let progressValue = progress {
                    ProgressView(value: progressValue)
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                        .frame(height: 8)
                        .padding(.top, 8)
                }
            }
            .padding(16)
        }
        .frame(maxWidth: .infinity, minHeight: 140)
    }
}



