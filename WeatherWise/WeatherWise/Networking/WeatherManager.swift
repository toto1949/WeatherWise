//
//  WeatherManager.swift
//  WeatherWise
//
//  Created by Taoufiq El Moutaouakil on 10/9/24.
//

import CoreLocation

class WeatherManager {
    
    func getCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> WeatherResponseBody {
        let urlString = "\(APIs.weatherAPI.rawValue)?lat=\(latitude)&lon=\(longitude)&appid=\(APIs.key.rawValue)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let urlRequest = URLRequest(url: url)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }

            return try decodeAndPrintWeatherData(from: data)
        } catch {
            throw error
        }
    }

    func getCurrentWeather(for city: String, state: String? = nil, country: String? = nil) async throws -> WeatherResponseBody {
        var query = city
        
        if let state = state, !state.isEmpty, let country = country, !country.isEmpty {
            query += ",\(state),\(country)"
        } else if let country = country, !country.isEmpty {
            query += ",\(country)"
        }
        
        let urlString = "\(APIs.weatherAPI.rawValue)?q=\(query)&appid=\(APIs.key.rawValue)"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let urlRequest = URLRequest(url: url)

        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }

            return try decodeAndPrintWeatherData(from: data)
        } catch {
            throw error
        }
    }


    private func decodeAndPrintWeatherData(from data: Data) throws -> WeatherResponseBody {
        let decoder = JSONDecoder()
        do {
            let weatherResponse = try decoder.decode(WeatherResponseBody.self, from: data)
            
            return weatherResponse
        } catch {
            throw error
        }
    }
}
