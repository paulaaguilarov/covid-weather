//
//  ViewController.swift
//  U.S. COVID Weather
//
//  Created by Paula Aguilar on 1/13/22.
//

import UIKit
import CoreLocation

class ViewController: UIViewController{
    
    @IBOutlet weak var containerStack: UIStackView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTexrField: UITextField!
    @IBOutlet weak var weatherConditionImg: UIImageView!
    
    @IBOutlet weak var forecastTimeLabel1: UILabel!
    @IBOutlet weak var forecastConditionImg1: UIImageView!
    @IBOutlet weak var forecastTempLabel1: UILabel!
    
    @IBOutlet weak var forecastTimeLabel2: UILabel!
    @IBOutlet weak var forecastConditionImg2: UIImageView!
    @IBOutlet weak var forecastTempLabel2: UILabel!
    
    @IBOutlet weak var forecastTimeLabel3: UILabel!
    @IBOutlet weak var forecastConditionImg3: UIImageView!
    @IBOutlet weak var forecastTempLabel3: UILabel!
    
    @IBOutlet weak var forecastTimeLabel4: UILabel!
    @IBOutlet weak var forecastConditionImg4: UIImageView!
    @IBOutlet weak var forecastTempLabel4: UILabel!
    
    @IBOutlet weak var forecastTimeLabel5: UILabel!
    @IBOutlet weak var forecastConditionImg5: UIImageView!
    @IBOutlet weak var forecastTempLabel5: UILabel!
    
    @IBOutlet weak var newCasesLabel: UILabel!
    @IBOutlet weak var infectionRateLabel: UILabel!
    @IBOutlet weak var positivityRateLabel: UILabel!
    
    @IBOutlet weak var riskLevelLabel: UILabel!
    @IBOutlet weak var transmissionLevelLabel: UILabel!
    
    @IBOutlet weak var tempModeSelector: UISegmentedControl!
    
    var covidWeatherManager = CovidWeatherManager()
    
    let locationManager = CLLocationManager()
    let loadingView = SpinnerViewController()
    
    var timeLabels:[UILabel] = []
    var tempLabels:[UILabel] = []
    var conditionImgs:[UIImageView] = []
    
    var imperialMode = true  //Imperial or metric  mode
    
    let customErrorMessage = CustomErrorMessage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerStack.alpha = 0
        
        timeLabels = [self.forecastTimeLabel1, self.forecastTimeLabel2, self.forecastTimeLabel3, self.forecastTimeLabel4, self.forecastTimeLabel5]
        tempLabels = [self.forecastTempLabel1, self.forecastTempLabel2, self.forecastTempLabel3, self.forecastTempLabel4, self.forecastTempLabel5]
        conditionImgs = [self.forecastConditionImg1, self.forecastConditionImg2, self.forecastConditionImg3, self.forecastConditionImg4, self.forecastConditionImg5]
        
        tempModeSelector.addTarget(self, action: #selector(self.segmentedValueChanged(_:)), for: .valueChanged)
        
        // Creates loading view while doing network requests
        self.createSpinnerView()
        
        searchTextField.delegate = self
        covidWeatherManager.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        
       
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Hides keyboard when tapping anywhere else in the screen
        searchTexrField.text = ""
        searchTextField.resignFirstResponder()
        super.touchesBegan(touches, with: event)
    }
    
    // Changes temperatures to Celsius or Fahrenheit format
    @objc func segmentedValueChanged(_ sender:UISegmentedControl!){
        self.imperialMode = (sender.selectedSegmentIndex == 0) ? true : false
        if covidWeatherManager.weather != nil{
            self.updateTempUI(imperialMode, covidWeatherManager.weather!)
        }
    }
    
    // Shows a loading view while the first network request is in process
    func createSpinnerView() {
        addChild(loadingView)
        loadingView.view.frame = view.frame
        view.addSubview(loadingView.view)
        loadingView.didMove(toParent: self)
    }
    
    // Removes the loading view
    func removeSpinnerView(){
        if loadingView.parent == self{
            containerStack.alpha = 1
            loadingView.willMove(toParent: nil)
            loadingView.view.removeFromSuperview()
            loadingView.removeFromParent()
        }
    }
    
    // Displays an alert message to the user
    func displayMessageToUser(_ message:String){
        let alert = UIAlertController(title: customErrorMessage.messageTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}


//MARK: - WeatherManagerDelegate

extension ViewController:CovidWeatherManagerDelegate{
    // Triggered when the COVID-19 data is ready to be displayed
    func didUpdateCovidStatus(_ dataManager: CovidWeatherManager, covidData: CovidModel) {
        DispatchQueue.main.async {
            self.riskLevelLabel.attributedText = covidData.riskLevelString
            self.transmissionLevelLabel.attributedText = covidData.cdcTransmissionLevelString
            self.newCasesLabel.text = covidData.caseDensityString
            self.infectionRateLabel.text = covidData.infectionRateString
            self.positivityRateLabel.text = covidData.positivityRateString
        }
    }
    
    // Triggered when the weather data is ready to be displayed
    func didUpdateWeather(_ dataManager:CovidWeatherManager, weather:WeatherModel, location: LocationModel){
        DispatchQueue.main.async {
            self.removeSpinnerView()
            self.weatherConditionImg.image = UIImage(systemName: weather.hourlyForecast[0].conditionName)
            self.updateTempUI(self.imperialMode, weather)
            self.cityLabel.text = (location.area != "") ? "\(location.locality), \(location.area)" : "\(location.locality)"
        }
        covidWeatherManager.getFipsCode()
        
    }
    
    // Updates the UI section where the temperatures are displayed
    func updateTempUI(_ imperialMode:Bool, _ weather:WeatherModel){
        self.temperatureLabel.text = (imperialMode == true) ? weather.hourlyForecast[0].temperatureFahrenheitString : weather.hourlyForecast[0].temperatureCelsiusString
        for i in 0...4 {
            self.timeLabels[i].text = weather.hourlyForecast[i+1].timeString
            self.tempLabels[i].text = (imperialMode == true) ? weather.hourlyForecast[i+1].temperatureFahrenheitString : weather.hourlyForecast[i+1].temperatureCelsiusString
            self.conditionImgs[i].image = UIImage(systemName: weather.hourlyForecast[i+1].conditionName)
        }
    }
    
    // Triggered when there is an error
    func didFailWithError(error: Error) {
        self.removeSpinnerView()
        var errorMessage = ""
        
        switch error{
            case CustomError.requestNotAllowed:
                errorMessage = customErrorMessage.requestNotAllowed
            case CustomError.locationNotFound:
                errorMessage = customErrorMessage.locationNotFound
            default:
                errorMessage = customErrorMessage.defaultMessage
        }
        
        self.displayMessageToUser(errorMessage)
        
        print("Error:: \(error)")
    }
}

//MARK: - CLLocationManagerDelegate

extension ViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            locationManager.requestLocation()
        case .authorizedAlways:
            locationManager.requestLocation()
        case .denied:
            self.displayMessageToUser(customErrorMessage.locationNotFound)
        default:
            print("Trying to get authorization to get location...")
        }
    }
      
    // Handles the location information
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            
            print("LocationManager didUpdateLocations: \(lat), \(lon)")
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error)->Void in
                
                if (error != nil) {
                    print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                    self.displayMessageToUser(self.customErrorMessage.defaultMessage)
                    return
                }
                
                if let placemark = placemarks?.last{
                    if let area = placemark.administrativeArea, let locality = placemark.locality, let country = placemark.country{
                        self.covidWeatherManager.getWeather(latitude: lat, longitude:lon, area:area, locality: locality, country: country)
                    }
                    
                }else{
                    print("Problem with the data received from geocoder")
                    self.displayMessageToUser(self.customErrorMessage.defaultMessage)
                }
                
                
            })
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LocationManager didFailWithError \(error.localizedDescription)")
        locationManager.stopUpdatingLocation()
        self.displayMessageToUser(customErrorMessage.locationNotFound)
        if let error = error as? CLError, error.code == .denied {
            // Location updates are not authorized.
            // To prevent forever looping of `didFailWithError` callback
            locationManager.stopMonitoringSignificantLocationChanges()
            return
        }
    }
    
    @IBAction func onCurrentLocationPressed(_ sender: UIButton) {
        searchTexrField.text = ""
        searchTextField.resignFirstResponder()
        locationManager.requestLocation()
        
    }
}

//MARK: - UITextFieldDelegate

extension ViewController: UITextFieldDelegate {
    
    @IBAction func onSearchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text == "" {
            textField.placeholder = "Search by city, state or address"
            
        }else{
            searchTextField.endEditing(true)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text, city != "" {
            covidWeatherManager.getWeather(by: city)
        }
        
        searchTextField.text = ""
        
    }
}

//MARK: - SpinnerViewController

class SpinnerViewController: UIViewController {
    var spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)
        
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}


