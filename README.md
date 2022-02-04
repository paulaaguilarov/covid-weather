# COVID-Weather

COVID Weather is a demo application that provides real time information about the weather and COVID-19 statistics of your current location or any area into the U.S. Very useful to evaluate risks when you are out and about. COVID Weather is available in dark mode and light mode.

## Screenshots

<img src="https://user-images.githubusercontent.com/14079473/152230416-a6d25a77-e8ad-4d24-b0a0-711aaa2f32cd.png" width=35% height=35%><img src="https://user-images.githubusercontent.com/14079473/152229981-156ab8a5-1e68-4c37-ab7e-dfced6b87548.png" width=60% height=60% align="top">


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
5. Temperatures can be displayed in Celsius or Fahrenheit units. 

## Getting Started
1. Clone/Download the repository.
2. Open the project in Xcode.
3. Open the file `APIs-Info.plist` and set your corresponding APIs key.
4. Build and run the app.

## TO-DO list 
- Add navigation controller to allow navigation to other informative screens.
- Show more detail about the COVID-19 stats, like including graphs.
- Add more hours into the weather forecast and make it scrollable.
