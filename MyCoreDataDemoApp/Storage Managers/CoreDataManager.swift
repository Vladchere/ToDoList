//
//  CoreDataManager.swift
//  MyCoreDataDemoApp
//
//  Created by Vladislav on 01.07.2020.
//  Copyright © 2020 Vladislav Cheremisov. All rights reserved.
//

import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() {}
    
    // MARK: - Properties
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MyCoreDataDemoApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Work with Core Data
    func fetchData(completion: @escaping ([Task]) -> Void) {
        let viewContext = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            let tasks = try viewContext.fetch(fetchRequest)
            completion(tasks)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func save(_ taskName: String, completion: @escaping (Task) -> Void) {
        let viewContext = persistentContainer.viewContext
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: viewContext) else { return }
        guard let task = NSManagedObject(entity: entityDescription, insertInto: viewContext) as? Task else { return }
        
        task.name = taskName
        completion(task)
        
        do {
            try viewContext.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func update(index: Int, newTaskName: String, completion: @escaping (Task) -> Void) {
        let viewContext = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            let tasks = try viewContext.fetch(fetchRequest)
            let taskToUpdate = tasks[index]
            taskToUpdate.setValue(newTaskName, forKey: "name")
            
            completion(taskToUpdate)
            do {
                try viewContext.save()
            } catch let error {
                print(error.localizedDescription)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func delete(index: Int) {
        let viewContext = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            let tasks = try viewContext.fetch(fetchRequest)
            let taskToDelete = tasks[index] as NSManagedObject
            viewContext.delete(taskToDelete)
            
            do {
                try viewContext.save()
            } catch let error {
                print(error.localizedDescription)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let viewContext = persistentContainer.viewContext
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
