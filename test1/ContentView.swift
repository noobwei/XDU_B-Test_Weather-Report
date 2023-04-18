//
//  ContentView.swift
//  test1
//
//  Created by 魏巍 on 2023/4/10.
//

import SwiftUI
import UIKit

struct ContentView: View {
    var body: some View {
        WeatherView(weather: Weather(temperature: 20, highTemperature: 25, lowTemperature: 18, icon: "cloud"))
    }
}

struct WeatherView: View {
    var weather: Weather
    @State private var tempMAX = ""
    @State private var tempMIN = ""
    @State private var AQI = ""
    @State var city = ""
    var body: some View {
        NavigationView {
            VStack {
                Button(action:{
                    let result = getWeather()
                    self.tempMAX = result.0
                    self.tempMIN = result.1
                    self.AQI = result.2
                    self.city = result.3
                    
                    let impact = UIImpactFeedbackGenerator(style: .medium)
                    impact.impactOccurred()
                })
                {
                    Image(systemName: "cloud")
                        .foregroundColor(.white)
                        .padding()
                }
                
//                .background(Color.gray)
                .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing)) // 渐变背景
                .clipShape(Circle())
                .scaleEffect(5.0)
                .frame(width: 150, height: 150)
                .offset(y: -150)
                .shadow(color: Color.gray, radius: 10, x: 0, y: 10) // 阴影效果

                Text("Your Location:\(city)")
                    .font(.system(size: 30))
                    .fontWeight(.medium)
                    .foregroundColor(.gray)
                Text("Temp Max:\(tempMAX)℃")
                    .font(.system(size: 20))
                    .fontWeight(.medium)
                    .foregroundColor(.blue)
                Text("Temp Max:\(tempMIN)℃")
                    .font(.system(size: 20))
                    .fontWeight(.medium)
                    .foregroundColor(.blue)
                Text("AQI:\(AQI)")
                    .font(.system(size: 20))
                    .fontWeight(.medium)
                    .foregroundColor(.blue)

                //                 Spacer()
            }
            .padding()
            .background(Color.white)
//            .cornerRadius(20)
            //        .shadow(radius: 10)
        }}
}

struct Weather {
    var temperature: Int
    var highTemperature: Int
    var lowTemperature: Int
    var icon: String
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


