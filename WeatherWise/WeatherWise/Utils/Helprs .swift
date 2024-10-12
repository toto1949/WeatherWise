//
//  Helprs .swift
//  WeatherWise
//
//  Created by Taooufiq El moutaoouakil on 10/9/24.
//

import Foundation
import SwiftUI

func getWeatherIconURL(iconCode: String) -> URL? {
       let urlString = "\(APIs.iconsAPI.rawValue)/\(iconCode)@2x.png" 
       return URL(string: urlString)
   }
func formatTime(_ timestamp: Double) -> String {
    let date = Date(timeIntervalSince1970: timestamp)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "h:mm a"
    print(dateFormatter.string(from: date))
    return dateFormatter.string(from: date)
}

func calculateDewPoint(temp: Double, humidity: Double) -> Int {
    let a = 17.27
    let b = 237.7
    let alpha = ((a * temp) / (b + temp)) + log(humidity / 100)
    let dewPoint = (b * alpha) / (a - alpha)
    return Int(dewPoint)
}



