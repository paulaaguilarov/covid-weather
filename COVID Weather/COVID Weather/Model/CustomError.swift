//
//  CustomError.swift
//  U.S. COVID Weather
//
//  Created by Paula Aguilar on 2/1/22.
//

import Foundation

struct CustomErrorMessage{
    let messageTitle =  "COVID Weather Message"
    let errorInRequest =  "There was an error in the request. Please try again later."
    let locationNotFound = "Location not found. Be sure you give COVID Weather permission to use your location."
    let requestNotAllowed = "The weather forecast and COVID-19 statistics are only available for United States."
    let defaultMessage = "An error ocurred. Please try again later."
}

enum CustomError: Error {
    // Throw when there's an error during the request
    case errorInRequest
    // Throw when a location is not found
    case locationNotFound
    // Throw when the request is not allowed
    case requestNotAllowed
    // Throw in all other cases
    case unexpected(code: Int)
}
