# COVID-Weather

COVID Weather is a demo application that provides real time information about the weather and COVID-19 statistics of your current location or any area into the U.S. Very useful to evaluate risks when you are out and about. COVID Weather is available in dark mode and light mode.

## Technologies
- Swift 5.0, UIKit, CoreLocation, MVC Design Pattern, AutoLayout, API Networking

## Specs
- Swift 5.0
- iOS 15.2 compatible
- Created using Xcode 13.2.1

## APIs

This application retrieves information from three differents APIs:
1. [OpenWeatherMap.org API] (https://openweathermap.org/api) : To get the weather information
2. [CovidActNow.org API] (https://covidactnow.org/data-api) : To get the COVID-19 stats according to a location into the U.S
3. [Geo.fcc API] (https://geo.fcc.gov/api/) : To retrieve the FIPS code of a location's county. This code is required in order to request the COVID-19 stats of that area

## Features
1. Users can get the current weather and COVID-19 stats of their location when loading the app.
2. Users can search any place into the U.S and get the weather forecast and COVID-19 stats of the area.
3. Users can get the weather and COVID-19 stats of their current location by tapping a location button.
4. The app is available in dark mode and light mode.

## Getting Started
1. Clone/Download the repository.
2. Open the project in Xcode.
3. Open the file `APIs-Info.plist` and set your corresponding APIs key.
4. Build and run the app.

## TO-DO list 
- Include a navigation controller to add more pages into the app.
- Add more hours into the weather forecast and make it scrollable.
- Show more detail about the COVID-19 stats, like including graphs.
