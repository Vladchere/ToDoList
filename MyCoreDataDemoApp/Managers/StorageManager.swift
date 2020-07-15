//
//  StorageManager.swift
//  MyCoreDataDemoApp
//
//  Created by Vladislav on 01.07.2020.
//  Copyright © 2020 Vladislav Cheremisov. All rights reserved.
//

import CoreData

class StorageManager {
    
    static let shared = StorageManager()
    private init() {}
    
    // MARK: - Core Data stack
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MyCoreDataDemoApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // MARK: - Public Methods
    func fetchData() -> [Task] {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest() // Запрос выборки по ключу Task
        
        do {
            return try viewContext.fetch(fetchRequest)
        } catch let error {
            print("Failed to fetch data", error.localizedDescription)
            return []
        }
    }
    
    // Сохранение
    func save(_ taskName: String, completion: (Task) -> Void) {
        guard let entity = NSEntityDescription.entity(
            forEntityName: "Task",
            in: viewContext
            ) else { return } // Создать сущность
        
        guard let task = NSManagedObject(
            entity: entity,
            insertInto: viewContext
            ) as? Task else { return } // Экземпляр task
        
        task.name = taskName // новое значение для имени task
        
        completion(task)
        
        saveContext()
    }
    
    // Редактирование
    func edit(_ task: Task, newName: String) {
        task.name = newName
        saveContext()
    }
    
    // Удаление
    func delete(_ task: Task) {
        viewContext.delete(task)
        saveContext()
    }
    
    // MARK: - Core Data Saving support
    func saveContext() {
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
