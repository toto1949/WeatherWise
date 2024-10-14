//
//  WeatherResponseBody.swift
//  WeatherWise
//
//  Created by Taooufiq El moutaoouakil on 10/9/24.
//

import Foundation

struct WeatherResponseBody: Decodable, Equatable {
    var cod: String
    var message: Int
    var cnt: Int
    var list: [WeatherEntry]
    var city: CityResponse
}

struct CityResponse: Decodable, Equatable {
    var name: String
    var country: String
    var coord: CoordinateResponse
    var population: Int
    var timezone: Int
    var sunrise: Int
    var sunset: Int
}

struct CoordinateResponse: Decodable, Equatable {
    var lat: Double
    var lon: Double
}

struct WeatherEntry: Decodable, Identifiable, Equatable {
    var id: Double { dt }
    var dt: Double
    var main: MainResponse
    var weather: [WeatherResponse]
    var clouds: CloudsResponse
    var wind: WindResponse
    var dt_txt: String
    var pop: Double 
}

struct MainResponse: Decodable, Equatable {
    var temp: Double
    var feels_like: Double
    var temp_min: Double
    var temp_max: Double
    var pressure: Double
    var sea_level: Double?
    var grnd_level: Double?
    var humidity: Double
    var temp_kf: Double?
}

struct WeatherResponse: Decodable, Equatable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}

struct CloudsResponse: Decodable, Equatable {
    var all: Int
}

struct WindResponse: Decodable, Equatable {
    var speed: Double
    var deg: Double
    var gust: Double?
}

enum ForecastPeriod {
    case hourly
    case daily
}
