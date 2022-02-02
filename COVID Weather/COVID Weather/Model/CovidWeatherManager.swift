//
//  CovidWeatherManager.swift
//  U.S. COVID Weather
//
//  Created by Paula Aguilar on 1/13/22.
//

import Foundation
import CoreLocation

protocol CovidWeatherManagerDelegate{
    func didUpdateWeather(_ dataManager:CovidWeatherManager, weather:WeatherModel, location:LocationModel)
    func didUpdateCovidStatus(_ dataManager:CovidWeatherManager, covidData:CovidModel)
    func didFailWithError(error:Error)
}

class CovidWeatherManager{
    let endPoints = Endpoints()
    let maxNumberOfHours = 4   //Number of hours ahead to by shown in the UI forecast section
    
    var location:LocationModel?
    var delegate:CovidWeatherManagerDelegate?
    var weather:WeatherModel?
    
    var isRequestingData = false
    
    // Initializes the request the weather by city name
    func getWeather(by cityName:String){
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(cityName) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let pm = placemarks.first,
                let location = pm.location
            else {
                self.delegate?.didFailWithError(error: CustomError.locationNotFound)
                return
            }
            //If user is asking for a location outside of the U.S
            if(pm.isoCountryCode != "US"){
                self.delegate?.didFailWithError(error: CustomError.requestNotAllowed)
                return
            }
            
            if  let name = pm.name, let area = pm.administrativeArea, let country = pm.country{
                var locality = name
                if let subLocality = pm.subLocality{
                    locality = subLocality
                }
                self.getWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, area:area, locality: locality, country: country)
            }
            
        }
    }
    
    // Initializes the request to get the weather by latitude and longitude
    func getWeather(latitude: CLLocationDegrees, longitude:CLLocationDegrees, area:String, locality:String, country:String){
        if isRequestingData == false{ //To avoid multiple requests when location manager triggers didUpdateLocation more than once
            location = LocationModel(area: area, locality: locality, country: country, latitude: latitude, longitude: longitude)
            let weatherURL = endPoints.weatherAPI.object(forKey: "URL")
            let weatherAPIKey = endPoints.weatherAPI.object(forKey: "KEY")
            let urlString = "\(weatherURL ?? "")&appid=\(weatherAPIKey ?? "")&lat=\(latitude)&lon=\(longitude)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            performWeatherRequest(with:urlString)
            self.isRequestingData = true
        }
    }
    
    // Initializes the request to get the fips code of the county according to the location
    func getFipsCode(){
        let fipsURL =  endPoints.fipsAPI.object(forKey: "URL")
        let urlString = "\(fipsURL ?? "")&lat=\(location?.latitude ?? 0.0)&lon=\(location?.longitude ?? 0.0)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        performFipsRequest(with:urlString)
        
    }
    
    // Initializes the request to get the covid stats according to the location
    func getCovidStats(_ fipsCode:String?){
        let covidActNowURL = endPoints.covidActNowAPI.object(forKey: "URL")
        let covidActNowAPIKey = endPoints.covidActNowAPI.object(forKey: "KEY")
        var urlString = ""
        if let state = location?.area {
            urlString =  "\(covidActNowURL ?? "")/state/\(state).json?apiKey=\(covidActNowAPIKey ?? "")"
        }else{
            self.delegate?.didFailWithError(error: CustomError.errorInRequest)
            return
        }
        if fipsCode != nil{
            urlString = "\(covidActNowURL ?? "")/county/\(fipsCode ?? "").json?apiKey=\(covidActNowAPIKey ?? "")"
        }
        performCovidStatsRequest(with:urlString)
    }
    
    // Makes the network request to get the information about the weather
    func performWeatherRequest(with urlString:String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    self.isRequestingData = false
                    self.delegate?.didFailWithError(error:error!)
                    return
                }
                
                if let safeData = data{
                    if let weather = self.parseWeatherJSON(safeData){
                        self.isRequestingData = false
                        self.delegate?.didUpdateWeather(self, weather:weather, location: self.location!)
                    }
                }
            }
            task.resume()
        }
    }
    
    // Checks if an specific time is after the sunset
    func checkIfNight(_ time:Date,_ sunset:Date) -> Bool{
        if time <= sunset{
            return false
        }
        return true
    }
    
    // Parses the JSON response of the weather data
    func parseWeatherJSON(_ weatherData:Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let current = decodedData.current
            let hourly = decodedData.hourly
            
            var hourlyForecast = [HourlyForecastModel]()
            
            let sunset = Date(timeIntervalSince1970: current.sunset)
            let now = Date()
            
            let cW = HourlyForecastModel(UTCtime: current.dt,isTheNight: checkIfNight(now, sunset),temperatureFahrenheit: current.temp, conditionId: current.weather[0].id, mainDescription: current.weather[0].main)
            
            hourlyForecast.insert(cW, at: 0)
            
            for i in 0...maxNumberOfHours {
                if let item = hourly[i] as Hourly?{
                    let time = Date(timeIntervalSince1970: item.dt)
                    let hW = HourlyForecastModel(UTCtime: item.dt, isTheNight: checkIfNight(time, sunset), temperatureFahrenheit: item.temp, conditionId: item.weather[0].id, mainDescription: item.weather[0].main)
                    hourlyForecast.insert(hW, at: i+1)
                }
            }
            
            
            self.weather = WeatherModel(hourlyForecast: hourlyForecast)
            return self.weather
            
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    // Makes the network request to get the information about the fips code of the county
    func performFipsRequest(with urlString:String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    print("FIPS Request Error:::\(error!)")
                    self.getCovidStats(nil)
                    return
                }
                
                if let safeData = data{
                    if let fips = self.parseFipsJSON(safeData){
                        self.getCovidStats(fips.fipsCode)
                    }else{
                        self.getCovidStats(nil)
                    }
                }
            }
            task.resume()
        }
    }
    
    // Parses the JSON response of the fips code data
    func parseFipsJSON(_ fipsData:Data) -> FIPSModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(FIPSData.self, from: fipsData)
            if decodedData.results.count > 0{
                let county_fips = decodedData.results[0].county_fips
                let fips = FIPSModel(fipsCode: county_fips)
                return fips
            }else{
                return nil
            }
        }catch{
            return nil
        }
    }
    
    // Makes the network request to get the COVID-19 stats
    func performCovidStatsRequest(with urlString:String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    print("Covid Request Error:::\(error!)")
                    self.delegate?.didFailWithError(error: CustomError.errorInRequest)
                    return
                }
                
                if let safeData = data{
                    if let covidStats = self.parseCovidStatsJSON(safeData){
                        self.delegate?.didUpdateCovidStatus(self, covidData: covidStats)
                        
                    }else{
                        self.delegate?.didFailWithError(error: CustomError.errorInRequest)
                    }
                }
            }
            task.resume()
        }
    }
    
    // Parses the JSON response of the COVID-19 stats data
    func parseCovidStatsJSON(_ covidData:Data) -> CovidModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(CovidData.self, from: covidData)
            let testPositivityRatio = decodedData.metrics.defaultTestPositivityRatio
            let caseDensity = decodedData.metrics.defaultCaseDensity
            let infectionRate = decodedData.metrics.defaultInfectionRate
            let overallRisk = decodedData.riskLevels.overall
            let cdcTransmissionLevel = decodedData.cdcTransmissionLevel
            let covidStats = CovidModel(testPositivityRatio: testPositivityRatio, caseDensity: caseDensity, infectionRate: infectionRate, riskLevel: overallRisk, cdcTransmissionLevel: cdcTransmissionLevel)
            return covidStats
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}


