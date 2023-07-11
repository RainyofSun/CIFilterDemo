//
//  CiFliterNameTableViewController.swift
//  GPUImage3Demo
//
//  Created by 苍蓝猛兽 on 2023/6/21.
//

import UIKit

class CiFliterNameTableViewController: UITableViewController {
    
    var fliterModels: [[String: Any]] = CIFliterModel.systemFilterModels()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fliterModels.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _filters = fliterModels[section]["filters"] as? [CIFliterModel] {
            return _filters.count
        }
        return .zero
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        if let _filters = fliterModels[indexPath.section]["filters"] as? [CIFliterModel] {
            cell.textLabel?.text = "       " + (_filters[indexPath.row].fliterName ?? "")
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let _filters = fliterModels[section]["filterCategory"] as? String {
            return "🔨 " + _filters
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let displayVC = CIFliterDisplayViewController()
        if let _filters = fliterModels[indexPath.section]["filters"] as? [CIFliterModel] {
            displayVC.filterModel = _filters[indexPath.row]
        }
        self.navigationController?.pushViewController(displayVC, animated: true)
    }
}
