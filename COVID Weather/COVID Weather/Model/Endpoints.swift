//
//  Endpoints.swift
//  U.S. COVID Weather
//
//  Created by Paula Aguilar on 1/21/22.
//

import Foundation

struct Endpoints{
    var weatherAPI: NSDictionary {
        return getAPIDictionary(with: "Weather_API")
    }
    
    var covidActNowAPI:NSDictionary {
        return getAPIDictionary(with: "CovidActNow_API")
      }
    
    var fipsAPI:NSDictionary {
        return getAPIDictionary(with: "Fips_API")
    }
    
    // Pulls the information from the configuration file 
    func getAPIDictionary(with key:String) -> NSDictionary{
        guard let filePath = Bundle.main.path(forResource: "APIs-Info", ofType: "plist") else {
          fatalError("Couldn't find file 'APIs-Info.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: key) as? NSDictionary else {
          fatalError("Couldn't find key '\(key)' in 'APIs-Info.plist'.")
        }
        return value
    }
    
}
