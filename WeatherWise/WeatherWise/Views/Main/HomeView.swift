//
//  HomeView.swift
//  WeatherWise
//
//  Created by Taooufiq El moutaoouakil on 10/7/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            ZStack{
                Color.background
                    .ignoresSafeArea()
                Image("Background")
                    .resizable()
                    .ignoresSafeArea()
                
                Image("House")
                    .frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,alignment: .top)
                    .padding(.top,257)
                // MARK: Curreny weather
                VStack (spacing: -10){
                    Text("Montreal")
                        .font(.largeTitle)
                    VStack{
                        Text(attributedString)
                        Text("H:24°  L:18°")
                    }
                    
                    Spacer()
                }
                .padding(.top, 51)
                
                // MARK: Tab Bar
                TabBar(action: {})
            }
        }
        .navigationBarBackButtonHidden(false)
    }
    
    private var attributedString : AttributedString {
        var string  = AttributedString("19°" + "\n" + "Mostly Clear")
        if let temp = string.range(of: "19°"){
            string[temp].font = .system(size: 96, weight: .thin)
        }
        if let pipe  = string.range(of: " | "){
            string[pipe].font = .title3.weight(.semibold)
            string[pipe].foregroundColor = .secondary
        }
        if let weather = string.range(of: "Mostly Clear"){
            string[weather].font = .title3.weight(.semibold)
            string[weather].foregroundColor = .secondary
        }
        return string
    }
}

#Preview {
    HomeView()
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
}
