//
//  CovidData.swift
//  U.S. COVID Weather
//
//  Created by Paula Aguilar on 1/13/22.
//

import Foundation

struct CovidData: Codable{
    let metrics:Metrics
    let riskLevels:RiskLevels
    let cdcTransmissionLevel:Int
}

struct Metrics: Codable{
    let testPositivityRatio:Double?
    let caseDensity:Double?
    let infectionRate:Double?
    
    var defaultTestPositivityRatio: Double { testPositivityRatio ?? -1 }
    var defaultCaseDensity: Double { caseDensity ?? -1 }
    var defaultInfectionRate: Double { infectionRate ?? -1 }
}
struct RiskLevels: Codable{
    let overall:Int
}



