//
//  Shapes.swift
//  WeatherWise
//
//  Created by Taooufiq El moutaoouakil on 10/7/24.
//

import SwiftUI
struct Arc : Shape {
    func path(in rect: CGRect) -> Path {
         var path = Path()
         
         path.move(to: CGPoint(x: rect.minX - 1 , y: rect.minY))
         
         path.addQuadCurve(to: CGPoint(x: rect.maxX + 1, y: rect.minY), control: CGPoint(x: rect.midX, y: rect.midY))
         
        path.addLine(to: CGPoint(x: rect.maxX + 1 , y: rect.maxY + 1))
        path.addLine(to: CGPoint(x: rect.minX + 1 , y: rect.maxY + 1))
        path.closeSubpath()
         return path
     }
}
struct Trapezoid: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height

        path.move(to: CGPoint(x: 0.2 * width, y: 0))
        
        path.addQuadCurve(to: CGPoint(x: 0.8 * width, y: 0),
                          control: CGPoint(x: 0.5 * width, y: -0.1 * height))
        
        path.addLine(to: CGPoint(x: width, y: 0.25 * height))
        
        // Right side
        path.addLine(to: CGPoint(x: width, y: 0.75 * height))
        
        path.addQuadCurve(to: CGPoint(x: 0, y: 0.75 * height),
                          control: CGPoint(x: 0.5 * width, y: height * 0.85))
        
        path.addLine(to: CGPoint(x: 0, y: 0.25 * height))
        
        path.closeSubpath()

        return path
    }
}
struct WindSpeedIcon: View {
    var body: some View {
        Image(systemName: "wind")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(.blue)
            .frame(width: 50, height: 50)
    }
}

struct RainDropIcon: View {
    var body: some View {
        Image(systemName: "drop.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(.blue)
            .frame(width: 50, height: 50)
    }
}

struct HumidityIcon: View {
    var body: some View {
        Image(systemName: "humidity.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(.teal)
            .frame(width: 50, height: 50)
    }
}

struct SunriseIcon: View {
    var body: some View {
        Image(systemName: "sunrise.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(.orange)
            .frame(width: 50, height: 50)
    }
}

struct PressureIcon: View {
    var body: some View {
        Image(systemName: "gauge")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(.yellow)
            .frame(width: 50, height: 50)
    }
}

struct SunIcon: View {
    var body: some View {
        Image(systemName: "sun.max.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(.yellow)
            .frame(width: 50, height: 50)
    }
}
