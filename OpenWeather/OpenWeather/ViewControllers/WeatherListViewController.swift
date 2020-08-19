//
//  WeatherListViewController.swift
//  OpenWeather
//
//  Created by Marcus Armstrong on 8/19/20.
//  Copyright © 2020 Marcus Armstrong. All rights reserved.
//

import UIKit

protocol HideKeyboardDelegate: class {
    func hideKeyboard()
}

class WeatherListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var addMenuContainerView: UIView!
    @IBOutlet weak var WeatherListTableView: UITableView!
    
    var menuIsHidden = true
    var weatherObjects: [TopLevelWeatherDict] = []
    var hideKeyboardDelegate: HideKeyboardDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        fetchInfoFromLocations()
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        if menuIsHidden == false {
            hideKeyboardDelegate?.hideKeyboard()
        }
        toggleMenuView()
    }
    
    func updateViews() {
        addMenuContainerView.isHidden = menuIsHidden
        WeatherListTableView.delegate = self
        WeatherListTableView.dataSource = self
    }
    
    func toggleMenuView() {
        menuIsHidden.toggle()
        UIView.animate(withDuration: 0.2) {
            self.addMenuContainerView.isHidden = self.menuIsHidden
        }
    }
    
    func fetchInfoFromLocations() {
        WeatherController.fetchWithSearchableObjects(searchableObjects: SearchableObjectController.sharedInstance.searchableObjects) { (result) in
            switch result {
            case .success(let weatherDictArray):
                self.weatherObjects = weatherDictArray
                DispatchQueue.main.async {
                    self.WeatherListTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weatherObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherTableViewCell else { return UITableViewCell() }
        let weatherDict = weatherObjects[indexPath.row]
        cell.weatherDict = weatherDict
        return cell
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let searchObject = weatherObjects[indexPath.row].searchObject else { return }
            SearchableObjectController.sharedInstance.deleteSearchableObject(searchObject: searchObject)
            weatherObjects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddLocation" {
            guard let destinationVC = segue.destination as? AddLocationViewController else { return }
            destinationVC.feedbackDelegate = self
            self.hideKeyboardDelegate = destinationVC
        } else if segue.identifier == "toDetailView" {
            guard let indexPath = WeatherListTableView.indexPathForSelectedRow else { return }
            guard let cell = WeatherListTableView.cellForRow(at: indexPath) as? WeatherTableViewCell else { return }
            let destination = segue.destination as? WeatherDetailViewController
            let weatherToSend = weatherObjects[indexPath.row]
            let iconToSend = cell.iconImageView.image
            destination?.weatherDict = weatherToSend
            destination?.iconImage = iconToSend
        }
        
    }
}

extension WeatherListViewController: WeatherSearchFeedbackDelegate {
    func presentAlertWithMessage(_ message: String) {
        DispatchQueue.main.async {
            self.presentAlertViewWithMessage(message)
        }
    }
    
    func addWeatherDictToArray(_ weatherDict: TopLevelWeatherDict) {
        self.weatherObjects.insert(weatherDict, at: 0)
        DispatchQueue.main.async {
            self.toggleMenuView()
            self.WeatherListTableView.reloadData()
        }
    }
    
    func presentAlertViewWithMessage(_ message: String) {
        let alertMessage = UIAlertController(title: "Uh Oh", message: message, preferredStyle: .alert)
        let tryAgainAction = UIAlertAction(title: "Try Again", style: .cancel, handler: nil)
        alertMessage.addAction(tryAgainAction)
        
        self.present(alertMessage, animated: true)
    }
}
