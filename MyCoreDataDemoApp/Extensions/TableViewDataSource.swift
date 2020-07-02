//
//  TableViewDataSource.swift
//  MyCoreDataDemoApp
//
//  Created by Vladislav on 02.07.2020.
//  Copyright © 2020 Vladislav Cheremisov. All rights reserved.
//

import UIKit

// MARK: - Table view data source
extension TaskListViewController {
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let task = tasks[indexPath.row]
        
        cell.textLabel?.text = task.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        showEditAlert(at: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            CoreDataManager.shared.delete(index: indexPath.row)
            self.tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [IndexPath(row: indexPath.row, section: 0)],
                                 with: .automatic)
        }
    }
}
