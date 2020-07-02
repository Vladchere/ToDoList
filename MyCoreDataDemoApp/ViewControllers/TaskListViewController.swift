//
//  TaskListViewController.swift
//  MyCoreDataDemoApp
//
//  Created by Vladislav on 30.06.2020.
//  Copyright © 2020 Vladislav Cheremisov. All rights reserved.
//

import UIKit

class TaskListViewController: UITableViewController {
    
    // MARK: - Public Properties
    let cellId = "cell"
    var tasks: [Task] = []
    
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
        navigationItem.leftBarButtonItem = editButtonItem
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc private func addTask() {
        showAlert(with: "New Task", and: "What do you want to do?")
    }
    
    private func showAlert(with title: String, and message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { (_) in
            guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }
            CoreDataManager.shared.save(task) { (task) in
                self.tasks.append(task)
                let indexPath = IndexPath(row: self.tasks.count - 1, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
            }
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
            guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }
            
            CoreDataManager.shared.update(index: row, newTaskName: task) { (task) in
                self.tasks[row].name = task.name
                self.tableView.reloadRows(
                    at: [IndexPath(row: row, section: 0)],
                    with: .automatic)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.textFields?.first?.keyboardAppearance = .dark
        alert.textFields?.first?.text = tasks[row].name
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField()
        
        present(alert, animated: true)
    }
}
