//
//  Extensions.swift
//  WeatherWise
//
//  Created by Taoufiq El Moutaouakil on 10/7/24.
//

import SwiftUI

// MARK: - Color Extensions
extension Color {
    static let background = LinearGradient(gradient: Gradient(colors: [Color("Background 1"), Color("Background 2")]), startPoint: .topLeading, endPoint: .bottomTrailing)
    
    static let bottomSheetBackground = LinearGradient(gradient: Gradient(colors: [Color("Background 1").opacity(0.26), Color("Background 2").opacity(0.26)]), startPoint: .topLeading, endPoint: .bottomTrailing)
    
    static let navBarBackground = LinearGradient(gradient: Gradient(colors: [Color("Background 1").opacity(0.1), Color("Background 2").opacity(0.1)]), startPoint: .topLeading, endPoint: .bottomTrailing)
    
    static let tabBarBackground = LinearGradient(gradient: Gradient(colors: [Color("Tab Bar Background 1").opacity(0.26), Color("Tab Bar Background 2").opacity(0.26)]), startPoint: .top, endPoint: .bottom)
    
    static let weatherWidgetBackground = LinearGradient(gradient: Gradient(colors: [Color("Weather Widget Background 1"), Color("Weather Widget Background 2")]), startPoint: .leading, endPoint: .trailing)
    
    static let bottomSheetBorderMiddle = LinearGradient(gradient: Gradient(stops: [.init(color: .white, location: 0), .init(color: .clear, location: 0.2)]), startPoint: .top, endPoint: .bottom)
    
    static let bottomSheetBorderTop = LinearGradient(gradient: Gradient(colors: [.white.opacity(0), .white.opacity(0.5), .white.opacity(0)]), startPoint: .leading, endPoint: .trailing)
    
    static let underline = LinearGradient(gradient: Gradient(colors: [.white.opacity(0), .white, .white.opacity(0)]), startPoint: .leading, endPoint: .trailing)
    
}

// MARK: - View Extensions
extension View {
    /// Applies a background blur effect.
    /// - Parameters:
    ///   - radius: The radius of the blur effect.
    ///   - opaque: A Boolean value that indicates whether the view is opaque.
    func backgroundBlur(radius: CGFloat = 3, opaque: Bool = false) -> some View {
        self
            .background(
                Blur(radius: radius, opaque: opaque)
            )
    }
    
    /// Applies an inner shadow effect to the view.
    /// - Parameters:
    ///   - shape: The shape to use for the shadow.
    ///   - color: The color of the shadow.
    ///   - lineWidth: The width of the shadow line.
    ///   - offsetX: The horizontal offset of the shadow.
    ///   - offsetY: The vertical offset of the shadow.
    ///   - blur: The blur radius of the shadow.
    ///   - blendMode: The blend mode to apply.
    ///   - opacity: The opacity of the shadow.
    func innerShadow<S: Shape, SS: ShapeStyle>(
        shape: S,
        color: SS,
        lineWidth: CGFloat = 1,
        offsetX: CGFloat = 0,
        offsetY: CGFloat = 0,
        blur: CGFloat = 4,
        blendMode: BlendMode = .normal,
        opacity: Double = 1
    ) -> some View {
        self
            .overlay {
                shape
                    .stroke(color, lineWidth: lineWidth)
                    .blendMode(blendMode)
                    .offset(x: offsetX, y: offsetY)
                    .blur(radius: blur)
                    .mask(shape)
                    .opacity(opacity)
            }
    }
}
func kelvinToCelsius(_ kelvin: Double) -> Double {
    return kelvin - 273.15
}

extension View {
    func bottomSheetOverlays(bottomSheetTranslationProrated: CGFloat) -> some View {
        self.overlay {
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
}
extension Image {
    func asUIImage() -> UIImage? {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        
        let targetSize = CGSize(width: 100, height: 100) 
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            view?.drawHierarchy(in: view!.bounds, afterScreenUpdates: true)
        }
    }
}

func convertStringToDate(_ dateString: String?) -> Date {
    let defaultDate = Date()
    guard let dateString = dateString else {
        return defaultDate
    }

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

    if let date = dateFormatter.date(from: dateString) {
        return date
    } else {
        return defaultDate
    }
}

import Foundation

extension Array where Element == WeatherEntry {
    func uniqueEntriesForDays() -> [WeatherEntry] {
        var uniqueEntries: [WeatherEntry] = []
        var seenDates: Set<String> = []

        for entry in self {
            let date = convertStringToDate(entry.dt_txt)
            let dateString = date.formatted(.dateTime.year().month().day())
            
            if !seenDates.contains(dateString) {
                seenDates.insert(dateString)
                uniqueEntries.append(entry)
            }
        }
        return uniqueEntries
    }
}
