//
//  CarsViewController.swift
//  BuildMyToyota
//
//  Created by Camden Webster on 2/10/24.
//

import UIKit

class CarsViewController: UITableViewController {
    
    // Default car to be added at app launch
    var car = Car(model: "New Car", trimLevel: "LE", extColor: "Red", intColor: "Black", accessories: [], safetyPackage: false)
    // Array to hold rows of cars
    var cars = [Car]()
    
    // Add a new car when button is pressed
    @IBAction func addCar(_ sender: Any) {
        var newCar = car
        newCar.model += " \(cars.count)"
        cars.append(newCar)
        tableView.reloadData()
        print("Added \(newCar.model)")
        print("Total cars: \(cars.count)")
        for car in cars {
            print(car.model)
        }
    }
    
    // Move into the detail view for the selected car
    @IBSegueAction func showDetailView(_ coder: NSCoder) -> DetailViewController? {
        guard let indexPath = tableView.indexPathForSelectedRow else { fatalError("Nothing selected!") }
        let car = cars[indexPath.row]
        let detailViewController = DetailViewController(coder: coder, car: car)
        detailViewController?.cars = cars
        return detailViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Add a default car
        cars.append(car)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "carCell", for: indexPath)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        cell.textLabel?.text = cars[indexPath.row].model
        return cell
    }

}
