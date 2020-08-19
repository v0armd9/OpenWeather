//
//  WeatherListViewController.swift
//  OpenWeather
//
//  Created by Marcus Armstrong on 8/19/20.
//  Copyright © 2020 Marcus Armstrong. All rights reserved.
//

import UIKit

class WeatherListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var addMenuContainerView: UIView!
    @IBOutlet weak var WeatherListTableView: UITableView!
    
    var menuIsHidden = true
    var weatherObjects: [TopLevelWeatherDict] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        fetchInfoFromLocations()
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
