//
//  TasksInteractorProtocol.swift
//  todotest
//
//  Created by Иван Незговоров on 18.11.2024.
//


import Foundation

protocol TasksInteractorProtocol {
    func fetchTasks()
    func loadTasksFromCoreData()
    func searchTasks(with query: String) -> [Task]
    func toggleTaskSelection(task: Task, completion: @escaping (Task) -> Void)
    func deleteTask(task: Task)
}

final class TasksInteractor: TasksInteractorProtocol {
    
    private let dataQueue = DispatchQueue(label: "com.todoapp.data", attributes: .concurrent)
    var presenter: TasksPresenterProtocol?
    var tasks: [Task] = []
    
    func fetchTasks() {
        if isFirstLaunch() {
            fetchTasksFromAPI()
        } else {
            loadTasksFromCoreData()
        }
    }
    func loadTasksFromCoreData() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let tasksEntity = CoreDataStack.shared.fetchAllTasks()
            
            self.tasks = tasksEntity.map { taskEntity in
                Task(
                    id: Int(taskEntity.id),
                    title: taskEntity.title ?? "",
                    description: taskEntity.descriptionText ?? "",
                    date: taskEntity.date ?? Date(),
                    isCompleted: taskEntity.isCompleted
                )
            }
            
            self.presenter?.loadTasks(tasks: self.tasks)
        }
    }
    func toggleTaskSelection(task: Task, completion: @escaping (Task) -> Void) {
        var mutableTask = task
        mutableTask.isCompleted.toggle()
        CoreDataStack.shared.toggleTaskSelection(by: String(task.id)) { success in
            if success {
                completion(mutableTask)
            }
        }
    }
    func searchTasks(with query: String) -> [Task] {
        guard !query.isEmpty else { return tasks }
        // поиск по descripton так как в данных которые приходят с сервера есть только description
        // можно поменять на .title
        return tasks.filter { $0.description.lowercased().contains(query.lowercased()) }
    }
    func deleteTask(task: Task) {
        CoreDataStack.shared.deleteTask(task: task) { [weak self] result in
            guard let self else { return }
            loadTasksFromCoreData()
        }
    }
    // Можно вынести работу с сетью в отдельный manager как мы сделали с core data
    // Не вынес из за того что всего 1 метод
    private func fetchTasksFromAPI() {
        guard let url = URL(string: "https://dummyjson.com/todos") else { return }
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                print("Ошибка при запросе данных: \(String(describing: error))")
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(Response.self, from: data)
                let task = decodedData.todos
                self?.saveTasksToCoreData(tasks: task)
                
                self?.dataQueue.async(flags: .barrier) {
                    DispatchQueue.main.async {
                        self?.loadTasksFromCoreData()
                    }
                }
            } catch {
                print("Ошибка при декодировании данных: \(error)")
            }
        }.resume()
        
    }
    private func saveTasksToCoreData(tasks: [Todo]) {
        for i in tasks {
            let task = Task(id: i.userId, title: "", description: i.todo, date: Date(), isCompleted: i.completed)
            CoreDataStack.shared.createTaskFirstTime(task: task)
        }
    }
    private func isFirstLaunch() -> Bool {
        let isFirstLaunch = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        if !isFirstLaunch {
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
        }
        return !isFirstLaunch
    }
}
