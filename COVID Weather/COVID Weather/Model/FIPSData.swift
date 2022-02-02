//
//  FIPSData.swift
//  U.S. COVID Weather
//
//  Created by Paula Aguilar on 1/14/22.
//

import Foundation

struct FIPSData: Codable{
    let results: [Results]
}
struct Results:Codable{
    let county_fips: String
}
