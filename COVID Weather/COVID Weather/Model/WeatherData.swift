//
//  WeatherData.swift
//  U.S. COVID Weather
//
//  Created by Paula Aguilar on 1/13/22.
//

import Foundation

struct WeatherData: Codable{
    let current:Current
    let hourly:[Hourly]
}

struct Current:Codable{
    let dt:Double
    let sunset:Double
    let temp:Double
    let weather:[Weather]
}

struct Hourly:Codable{
    let dt:Double
    let temp:Double
    let weather:[Weather]
}

struct Weather:Codable{
    let id:Int
    let main:String
}
