//
//  CovidModel.swift
//  U.S. COVID Weather
//
//  Created by Paula Aguilar on 1/13/22.
//

import Foundation
import UIKit

struct CovidModel{
    let testPositivityRatio:Double
    let caseDensity:Double
    let infectionRate:Double
    let riskLevel:Int
    let cdcTransmissionLevel:Int
    
    var positivityRateString:String{
        if testPositivityRatio > 0{
            let positivityRate = testPositivityRatio * 100
            return "\(String(format: "%.1f", positivityRate))%"
        }
        // Returns "-" when no information is available to display
        return "-"
    }
    
    var infectionRateString:String{
        if infectionRate > 0{
            return "\(String(format: "%.2f", infectionRate))"
        }
        // Returns "-" when no information is available to display
        return "-"
    }
    
    var caseDensityString:String{
        if caseDensity > 0{
            return "\(String(format: "%.1f", caseDensity)) PER 100K"
        }
        // Returns "-" when no information is available to display
        return "-"
    }
    
    // Assigns a different color and text according to the risk level
    var riskLevelString: NSAttributedString{
        var riskTxt = "Risk: "
        var color = UIColor.systemGray2
        
        switch riskLevel{
        case 0:
            riskTxt += "LOW"
            color = UIColor.systemGreen
        case 1:
            riskTxt += "MEDIUM"
            color = UIColor.systemYellow
        case 2:
            riskTxt += "HIGH"
            color = UIColor.systemOrange
        case 3:
            riskTxt += "VERY HIGH"
            color = UIColor.systemRed
        case 4:
            riskTxt += "EXTREMELY HIGH"
            color = UIColor.systemRed
        case 5:
            riskTxt += "SEVERE"
            color = UIColor.systemRed
        default:
            riskTxt += "UNKNOWN"
        }
        let attributes = [ NSAttributedString.Key.foregroundColor: color ]
        return NSAttributedString(string: riskTxt, attributes: attributes)
    }
    
    //  Assigns a different color and text according to the risk level
    var cdcTransmissionLevelString:NSAttributedString{
        var cdcTxt = ""
        var color = UIColor.systemGray2
        
        switch cdcTransmissionLevel{
        case 0:
            cdcTxt = "Low Transmission"
            color = UIColor.systemGreen
        case 1:
            cdcTxt =  "Moderate Transmission"
            color = UIColor.systemYellow
        case 2:
            cdcTxt = "Substantial Transmission"
            color = UIColor.systemOrange
        case 3:
            cdcTxt =  "High Transmission"
            color = UIColor.systemRed
        case 4:
            cdcTxt = "Unknown Transmission"
        default:
            cdcTxt = "Unknown Transmission"
        }
        let attributes = [ NSAttributedString.Key.foregroundColor: color ]
        return NSAttributedString(string: cdcTxt, attributes: attributes)
    }
}
