//
//  FilterTableViewController.swift
//  GPUImage3Demo
//
//  Created by 苍蓝猛兽 on 2023/6/20.
//

import UIKit

class FilterTableViewController: UITableViewController {

    let filterModels = FilterModel.filterModels()
    var values: [[FilterModel]] {
        return Array(filterModels.values)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return filterModels.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = "       " + values[indexPath.section][indexPath.row].name
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "🔨 " + Array(filterModels.keys)[section]
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let displayVC = DisplayViewController()
        displayVC.filterModel = values[indexPath.section][indexPath.row]
        navigationController?.pushViewController(displayVC, animated: true)
    }
}
