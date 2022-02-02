//
//  WeatherModel.swift
//  U.S. COVID Weather
//
//  Created by Paula Aguilar on 1/13/22.
//

import Foundation

struct WeatherModel{
    let hourlyForecast:[HourlyForecastModel]
}

struct HourlyForecastModel{
    let UTCtime:Double
    let isTheNight:Bool
    let temperatureFahrenheit:Double
    let conditionId:Int
    let mainDescription:String
    
    // Returns the received temperature in Fahrenheit in String format
    var temperatureFahrenheitString:String{
        let temp = (round(temperatureFahrenheit) == 0) ? 0 : round(temperatureFahrenheit)
        return "\(String(format: "%.f", temp))°F"
    }
    
    // Returns the temperature in Celsius in String format
    var temperatureCelsiusString:String{
        var celsius = round((temperatureFahrenheit - 32) * 5 / 9)
        if celsius == 0{ celsius = 0 }
        return "\(String(format: "%.f", celsius))°C"
    }
    
    // Converts the UTC time into Date and returns the time formatted in String
    var timeString:String{
        let date = Date(timeIntervalSince1970: UTCtime)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: date)
    }
    
    // Assigns a different sf symbol according to the weather condition
    var conditionName:String{
        switch conditionId{
        case 200...232: //Thunderstorm
            return "cloud.bolt.rain"
        case 300...321: //Drizzle
            return "cloud.drizzle"
        case 500...531: //Rain
            return "cloud.rain"
        case 600...622: //Snow
            return "cloud.snow"
        case 711: //Smoke
            return "smoke"
        case 721: //Haze
            return "sun.haze"
        case 731: //Dust
            return "sun.dust"
        case 741: //Fog
            return "cloud.fog"
        case 761: //Dust
            return "sun.dust"
        case 781: //Tornado
            return "tornado"
        case 800: //Clear
            if isTheNight{
                return "moon.stars"
            }
            return "sun.max"
        case 801...804: //Clouds
            return "cloud"
        default: return "cloud"
        }
    }
    
   

   
    
}
