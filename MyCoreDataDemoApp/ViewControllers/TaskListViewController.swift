//
//  TaskListViewController.swift
//  MyCoreDataDemoApp
//
//  Created by Vladislav on 30.06.2020.
//  Copyright © 2020 Vladislav Cheremisov. All rights reserved.
//

import UIKit
import CoreData

class TaskListViewController: UITableViewController {
    
    // MARK: - Private Properties
    private let cellId = "cell"
    private var tasks: [Task] = []
    
    // MARK: - Methods life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CoreDataManager.shared.fetchData { (taskData) in
            self.tasks = taskData
        }
        tableView.reloadData()
    }
    
    // MARK: - Private methods
    private func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = UIColor(red: 21/255,
                                                   green: 101/255,
                                                   blue: 192/255,
                                                   alpha: 194/255)
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTask)
        )

        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc private func addTask() {
        showAlert(with: "New Task", and: "What do you want to do?")
    }
    
    private func showAlert(with title: String, and message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { (_) in
            guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }
            self.save(task)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField()
        
        present(alert, animated: true)
    }
    
    func showEditAlert(at row: Int) {
        let alert = UIAlertController(
            title: "Edit task",
            message: "Do you want to change this?",
            preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let task = alert.textFields?.first?.text,
                !task.isEmpty else { return }
            
            CoreDataManager.shared.update(index: row, newTaskName: task) { (task) in
                self.tasks[row].name = task.name
                self.tableView.reloadRows(
                    at: [IndexPath(row: row, section: 0)],
                    with: .automatic)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addTextField()
        alert.textFields?.first?.keyboardAppearance = .dark
        alert.textFields?.first?.text = tasks[row].name
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}

// MARK: - Core Data
extension TaskListViewController {
    
    private func save(_ taskName: String) {
        CoreDataManager.shared.save(taskName) { (task) in
            self.tasks.append(task)
        }
        let indexPath = IndexPath(row: tasks.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    
}

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
