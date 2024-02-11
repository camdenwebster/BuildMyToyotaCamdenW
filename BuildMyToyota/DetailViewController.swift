//
//  DetailViewController.swift
//  BuildMyToyota
//
//  Created by Camden Webster on 2/10/24.
//

import UIKit

class DetailViewController: UITableViewController {
    // Array to keep track of the selected index path for each section
    var selectedIndexPaths: [Int: IndexPath] = [:]
    
    // Array to keep track of selected items for a specific section
    var selectedItemsInSection = Set<Int>()
    
    // Car data setup
    var car: Car
    var cars = [Car]()
    let sections = ["Model", "Trim", "Exterior", "Interior", "Accessories", "Safety Package"]
    let sectionData = [
        ["4Runner", "Camry", "Corolla", "Crown", "Highlander", "Prius", "RAV4", "Sequoia", "Tacoma", "Tundra", "Venza"],
        ["LE", "XLE", "Limited"],
        ["Red", "White", "Black", "Silver", "Gray", "Blue"],
        ["Black", "Gray"],
        ["Floor mats", "Wheel locks", "Cargo liner", "Door guards", "Dash cam"],
        ["Safety Package"]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
    }

    required init?(coder: NSCoder) { fatalError("This should never be called!") }
    init?(coder: NSCoder, car: Car) {
        self.car = car
        super.init(coder: coder)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionData[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailsCell", for: indexPath)
        
        // Get the data for the current section and row
        let rowData = sectionData[indexPath.section][indexPath.row]
        cell.textLabel?.text = rowData
        
        // Check if the current index path is selected for its section
        if indexPath.section == 4 {
            // For section 4, allow multiple selection
            if selectedItemsInSection.contains(indexPath.row) {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        } else {
            // For other sections, only allow one selection
            if let selectedIndexPath = selectedIndexPaths[indexPath.section], selectedIndexPath == indexPath {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 4 {
            // For Section4, allow multiple selections
            updateSelectionForMultipleSections(indexPath: indexPath)
        } else {
            // For other sections, allow a single selection
            updateSelectionForSingleSection(indexPath: indexPath)
        }
    
        let selection = sectionData[indexPath.section][indexPath.row]
        let section = sections[indexPath.section]
            
        print("You have selected \(selection) from \(section)")
        print("Car status: Model: \(car.model), Trim: \(car.trimLevel), Exterior color: \(car.extColor), Interior Color: \(car.intColor), Accessories: \(car.accessories), Safety packagae: \(car.safetyPackage)")
    }
    
    // MARK: - Selection Handling
    func updateSelectionForSingleSection(indexPath: IndexPath) {
        let selection = sectionData[indexPath.section][indexPath.row]
        // Check if the selected index path is already selected
        if let selectedIndexPath = selectedIndexPaths[indexPath.section], selectedIndexPath == indexPath {
            // Deselect the row by removing its selection
            selectedIndexPaths[indexPath.section] = nil
            tableView.reloadRows(at: [indexPath], with: .automatic)
            // Set safety package to false
            if sectionData[indexPath.section] == sectionData[5] {
                car.safetyPackage = false
                print("Safety packagae is now \(car.safetyPackage)")
            }
        } else {
            // Clear previously selected index path for the same section
            if let previouslySelectedIndexPath = selectedIndexPaths[indexPath.section] {
                selectedIndexPaths[previouslySelectedIndexPath.section] = nil
                tableView.reloadRows(at: [previouslySelectedIndexPath], with: .automatic)
            }

            // Update selected index path for the current section
            selectedIndexPaths[indexPath.section] = indexPath
            tableView.reloadRows(at: [indexPath], with: .automatic)
            
            // Set safety package to true
            if sectionData[indexPath.section] == sectionData[5] {
                car.safetyPackage = true
                print("Safety packagae is now \(car.safetyPackage)")
            }
        }

        // Update car
        // Set the model
        if sectionData[indexPath.section] == sectionData[0] {
            car.model = selection
            print("Car model is now \(car.model)")
        }
        
        // Set the trim
        if sectionData[indexPath.section] == sectionData[1] {
            car.trimLevel = selection
            print("Car trim level is now \(car.trimLevel)")
        }
        
        // Set the exterior color
        if sectionData[indexPath.section] == sectionData[2] {
            car.extColor = selection
            print("Car exterior color is now \(car.extColor)")
        }
        
        // Set the interior color
        if sectionData[indexPath.section] == sectionData[3] {
            car.intColor = selection
            print("Car interior color is now \(car.intColor)")
        }
    }

    func updateSelectionForMultipleSections(indexPath: IndexPath) {
        // Toggle selection for the current item in the section
        if selectedItemsInSection.contains(indexPath.row) {
            selectedItemsInSection.remove(indexPath.row)
            // Remove the accessory from the array if deselected
            if let index = car.accessories.firstIndex(of: sectionData[indexPath.section][indexPath.row]) {
                car.accessories.remove(at: index)
            }
        } else {
            selectedItemsInSection.insert(indexPath.row)
            car.accessories.append(sectionData[indexPath.section][indexPath.row])
            print("Added \(sectionData[indexPath.section][indexPath.row]) options are now \(car.accessories)")
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    // Set titles for sections
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
}
