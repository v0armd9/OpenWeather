//
//  AddLocationViewController.swift
//  OpenWeather
//
//  Created by Marcus Armstrong on 8/19/20.
//  Copyright © 2020 Marcus Armstrong. All rights reserved.
//

import UIKit

protocol WeatherSearchFeedbackDelegate: class {
    func presentAlertWithMessage(_ message: String)
    func addWeatherDictToArray(_ weatherDict: TopLevelWeatherDict)
}

class AddLocationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var searchTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var cityZipTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var addLocationButton: UIButton!
    
    var isStateHidden = false
    weak var feedbackDelegate: WeatherSearchFeedbackDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    @IBAction func searchTypeSegmentValueChanged(_ sender: UISegmentedControl) {
        toggleStateTextfieldIsHidden()
    }
    
    @IBAction func addLocationButtonTapped(_ sender: UIButton) {
        cityZipTextField.resignFirstResponder()
        stateTextField.resignFirstResponder()
        fetchWeatherForLocation()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func updateViews() {
        addLocationButton.setTitle("Add Location", for: .normal)
        addLocationButton.layer.borderColor = UIColor.blue.cgColor
        addLocationButton.layer.borderWidth = 2
        addLocationButton.layer.cornerRadius = addLocationButton.frame.height/2
        stateTextField.isHidden = isStateHidden
        stateTextField.placeholder = "State..."
        cityZipTextField.placeholder = "City..."
        stateTextField.delegate = self
        cityZipTextField.delegate = self
    }
    
    func toggleStateTextfieldIsHidden() {
        isStateHidden.toggle()
        switch isStateHidden {
        case true:
            cityZipTextField.placeholder = "US Zip Code..."
        default:
            cityZipTextField.placeholder = "City..."
        }
        UIView.animate(withDuration: 0.2) {
            self.stateTextField.isHidden = self.isStateHidden
        }
    }
    
    func fetchWeatherForLocation() {
        if searchTypeSegmentedControl.selectedSegmentIndex == 0 {
            guard let city = cityZipTextField.text, !city.isEmpty else { feedbackDelegate?.presentAlertWithMessage("Invalid City Name"); return }
            guard let state = stateTextField.text, !state.isEmpty else { feedbackDelegate?.presentAlertWithMessage("Invalid State Name"); return }
            let searchObject = SearchableObjectController.sharedInstance.createSearchableObjectWith(city: city, andState: state, orZip: nil)
            WeatherController.fetchWithSingleSearchObject(searchObject: searchObject) { (result) in
                switch result {
                case .success(let weatherDict):
                    DispatchQueue.main.async {
                        self.cityZipTextField.text = ""
                        self.stateTextField.text = ""
                    }
                    self.feedbackDelegate?.addWeatherDictToArray(weatherDict)
                case .failure(let error):
                    self.feedbackDelegate?.presentAlertWithMessage("Please check the city and state name again. There was an error: \(error.errorDescription)")
                }
            }
            
        } else {
            guard let zipCodeString = cityZipTextField.text, !zipCodeString.isEmpty else { feedbackDelegate?.presentAlertWithMessage("Invalid Zip Code"); return }
            guard let zipCode = Int(zipCodeString), zipCodeString.count == 5 else { feedbackDelegate?.presentAlertWithMessage("Invalid Zip code, please use 5 digit US Zip code"); return }
            let searchObject = SearchableObjectController.sharedInstance.createSearchableObjectWith(city: nil, andState: nil, orZip: zipCode)
            WeatherController.fetchWithSingleSearchObject(searchObject: searchObject) { (result) in
                switch result {
                case .success(let weatherDict):
                    DispatchQueue.main.async {
                        self.cityZipTextField.text = ""
                        self.stateTextField.text = ""
                    }
                    self.feedbackDelegate?.addWeatherDictToArray(weatherDict)
                case .failure(let error):
                    self.feedbackDelegate?.presentAlertWithMessage("Please check the zip code. There was an error: \(error.errorDescription)")
                }
            }
        }
    }
}

extension AddLocationViewController: HideKeyboardDelegate {
    func hideKeyboard() {
        cityZipTextField.resignFirstResponder()
        stateTextField.resignFirstResponder()
    }
}
