//
//  CoreDataStack.swift
//  todotest
//
//  Created by Иван Незговоров on 18.11.2024.
//




import CoreData
import UIKit

class CoreDataStack {
    static let shared = CoreDataStack()
    
    private init() {}
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "todotest")
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Unresolved error \(error), \(error.localizedDescription)")
            }
        }
        return container
    }()
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    func createTaskFirstTime(task: Task) {
        let context = CoreDataStack.shared.context
        let taskEntity = TasksEntity(context: context)
        taskEntity.id = Int32(task.id)
        taskEntity.title = task.title
        taskEntity.descriptionText = task.description
        taskEntity.date = Date()
        taskEntity.isCompleted = false
        
        saveContext()
    }
    func createTask(title: String, description: String) {
        let context = CoreDataStack.shared.context
        let taskEntity = TasksEntity(context: context)
        let uuid = UUID().uuidString
        let uuidHash = uuid.hashValue
        taskEntity.id = Int32(abs(uuidHash % Int(Int32.max)))
        taskEntity.title = title
        taskEntity.descriptionText = description
        taskEntity.date = Date()
        taskEntity.isCompleted = false
        
        saveContext()
    }
    func deleteTask(task: Task, completion: @escaping (Bool) -> ()) {
        let fetchRequest: NSFetchRequest<TasksEntity> = TasksEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", Int32(task.id))
        
        do {
            let results = try context.fetch(fetchRequest)
            if let taskEntity = results.first {
                context.delete(taskEntity)
                saveContext()
                completion(true)
            } else {
                completion(false)
                print("TaskEntity с id \(task.id) не найден")
            }
        } catch {
            completion(false)
            print("Ошибка при удалении TaskEntity: \(error.localizedDescription)")
        }
    }
    func editTask(by id: String, title: String, descriptionText: String, date: Date, isCompleted: Bool, completion: (Bool) -> ()) {
        let context = CoreDataStack.shared.context
        
        let fetchRequest: NSFetchRequest<TasksEntity> = TasksEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let tasks = try context.fetch(fetchRequest)
            
            if let task = tasks.first {
                task.id = Int32(id)!
                task.title = title
                task.descriptionText = descriptionText
                task.date = date
                task.isCompleted = isCompleted
                
                try context.save()
                completion(true)
            } else {
                print("Task not found!")
                completion(false)
            }
        } catch {
            print("Error fetching task: \(error)")
            completion(false)
        }
    }
    func fetchAllTasks() -> [TasksEntity] {
        let fetchRequest: NSFetchRequest<TasksEntity> = TasksEntity.fetchRequest()
        
        do {
            let tasks = try context.fetch(fetchRequest)
            return tasks
        } catch {
            print("Ошибка при извлечении данных: \(error.localizedDescription)")
            return []
        }
    }
    func toggleTaskSelection(by id: String, completion: (Bool) -> ()) {
        let context = CoreDataStack.shared.context
        
        let fetchRequest: NSFetchRequest<TasksEntity> = TasksEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let tasks = try context.fetch(fetchRequest)
            
            if let task = tasks.first {
                task.isCompleted.toggle()
                
                try context.save()
                completion(true)
            } else {
                print("Task not found!")
                completion(false)
            }
        } catch {
            print("Error fetching task: \(error)")
            completion(false)
        }
    }
}
