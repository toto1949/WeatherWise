import SwiftUI

struct WeatherWidget: View {
    var weatherEntry: WeatherEntry
    @StateObject var cacheViewModel = CacheViewModel() 
    
    var forecastDateText: String {
        let date = convertStringToDate(weatherEntry.dt_txt)
        return date.formatted(.dateTime.weekday(.wide).day().month())
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            // MARK: Trapezoid
            Trapezoid()
                .fill(Color.weatherWidgetBackground)
                .frame(width: 342, height: 174)
                .shadow(radius: 5)
            
            // MARK: Content
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 8) {
                    // MARK: Forecast Temperature
                    Text("\(kelvinToCelsius(weatherEntry.main.temp), specifier: "%.0f")°")
                        .font(.system(size: 64, weight: .bold)) 
                    
                    VStack(alignment: .leading, spacing: 2) {
                        // MARK: Forecast Temperature Range
                        Text("H: \(kelvinToCelsius(weatherEntry.main.temp_max), specifier: "%.0f")°  L: \(kelvinToCelsius(weatherEntry.main.temp_min), specifier: "%.0f")°")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        
                        // MARK: Forecast Location
                        Text("\(weatherEntry.weather.first?.description ?? ""), \(weatherEntry.weather.first?.main ?? "")")
                            .font(.body)
                            .lineLimit(1)
                            .foregroundColor(.white)
                        
                        // MARK: Forecast Date
                        Text(forecastDateText)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 0) {
                    // MARK: Forecast Large Icon
                    if let iconCode = weatherEntry.weather.first?.icon {
                        let cacheKey = NSString(string: iconCode)
                        if let cachedImage = cacheViewModel.manager.getImage(forKey: cacheKey) {
                            Image(uiImage: cachedImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(.trailing, 4)
                        } else if let iconURL = getWeatherIconURL(iconCode: iconCode) {
                            AsyncImage(url: iconURL) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding(.trailing, 4)
                                    .onAppear {
                                        if let uiImage = image.asUIImage() {
                                            cacheViewModel.cacheImage(uiImage, forKey: cacheKey)
                                        }
                                    }
                            } placeholder: {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white)) // Customize progress view
                            }
                        }
                    }
                }
            }
            .foregroundColor(.white)
            .padding(.bottom, 20)
            .padding(.leading, 20)
        }
        .frame(width: 342, height: 184, alignment: .bottom)
        .padding()
        .background(Color.clear)
    }
}
