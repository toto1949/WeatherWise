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
         
         // Start at top-left of the rectangle
         path.move(to: CGPoint(x: rect.minX - 1 , y: rect.minY))
         
         // Create an arc using a control point in the middle
         path.addQuadCurve(to: CGPoint(x: rect.maxX + 1, y: rect.minY), control: CGPoint(x: rect.midX, y: rect.midY))
         
        path.addLine(to: CGPoint(x: rect.maxX + 1 , y: rect.maxY + 1))
        path.addLine(to: CGPoint(x: rect.minX + 1 , y: rect.maxY + 1))
        path.closeSubpath()
         // Return the arc path
         return path
     }
}
