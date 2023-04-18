import Foundation
import CoreLocation

var responseString: String = ""
var responseString1: String = ""
var tempMAX: String = ""
var tempMIN: String = ""
var AQI: String = ""
var latitude:Double = 0
var longitude:Double = 0
var formattedLatitude: String = ""
var formattedLongitude: String = ""
var city: String = ""

func getWeather()->(String,String,String,String) {
//     创建 CLLocationManager 对象
    let locationManager = CLLocationManager()

    // 请求用户授权
    locationManager.requestWhenInUseAuthorization()
    let geocoder = CLGeocoder()

    let location = CLLocation(latitude: latitude, longitude: longitude)

    geocoder.reverseGeocodeLocation(location) { placemarks, error in
        guard error == nil else {
            print("Geocoder error: \(error!)")
            return
        }
        
        if let placemark = placemarks?.first {
            city = placemark.locality ?? ""
//            print("City: \(city)")
        }
    }

    // 获取当前位置
    if let currentLocation = locationManager.location {
        latitude = currentLocation.coordinate.latitude
        longitude = currentLocation.coordinate.longitude
//        print(latitude)
//        print(longitude)
//        latitude = (format: "%.2f", latitude)
//        longitude = (format: "%.2f", longitude)
        // 在这里发送和风天气的 API 请求，将经度和纬度作为参数之一
        formattedLatitude = String(format: "%.2f", latitude)
        formattedLongitude = String(format: "%.2f", longitude)
//        print(formattedLatitude)
//        print(formattedLongitude)
    }
    if let url = URL(string: "https://devapi.qweather.com/v7/weather/3d?location=\(formattedLongitude),\(formattedLatitude)&key=9a374aa0f2784709836fd095ced65fd6") {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            if let data = data {
                DispatchQueue.main.async{
                    responseString=String(data: data, encoding: .utf8)!
                    if let tempMaxRange = responseString.range(of: #""tempMax":"\d+""#, options: .regularExpression) {
                        let tempMaxSubstring = responseString[tempMaxRange]
                        tempMAX = String(tempMaxSubstring.split(separator: ":")[1])
                        tempMAX = tempMAX.replacingOccurrences(of: "[^a-zA-Z0-9]", with: "", options: .regularExpression, range: nil)
//                        print("Temp Max: \(tempMAX)")
                    }
                    
                    if let tempMinRange = responseString.range(of: #""tempMin":"\d+""#, options: .regularExpression) {
                        let tempMinSubstring = responseString[tempMinRange]
                        tempMIN = String(tempMinSubstring.split(separator: ":")[1])
                        tempMIN = tempMIN.replacingOccurrences(of: "[^a-zA-Z0-9]", with: "", options: .regularExpression, range: nil)
//                        print("Temp Min: \(tempMIN)")
                    }
                }
            }
        }
        task.resume()
        
    }
    if let url = URL(string: "https://devapi.qweather.com/v7/air/now?location=101110101&key=9a374aa0f2784709836fd095ced65fd6") {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            if let data = data {
                DispatchQueue.main.async{
                    responseString1=String(data: data, encoding: .utf8)!
                    if let AQIRange = responseString1.range(of: #""aqi":"\d+""#, options: .regularExpression) {
                        let AQISubstring = responseString1[AQIRange]
                        AQI = String(AQISubstring.split(separator: ":")[1])
                        AQI=AQI.replacingOccurrences(of: "[^a-zA-Z0-9]", with: "", options: .regularExpression, range: nil)
                    }
                }
            }
        }
        task.resume()
        
    }
    return (tempMAX,tempMIN,AQI,city)
    
}
