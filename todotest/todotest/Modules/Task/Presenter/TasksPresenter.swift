//
//  TypeView.swift
//  todotest
//
//  Created by Иван Незговоров on 18.11.2024.
//

import UIKit

enum TypeView {
    case new
    case edit
}

protocol TasksPresenterProtocol {
    var tasksCount: Int { get }
    var selectedTask: Task? { get set }
    func loadTasks(tasks: [Task])
    func searchTasks(with query: String)
    func toggleTaskCompletion(at task: Task)
    func didSelectTask(at index: Int)
    func task(at index: Int) -> Task
    func deleteSelectedTask()
    func newLoad()
    func newView(type: TypeView, view: UIViewController)
}

final class TasksPresenter: TasksPresenterProtocol {
    weak var view: TasksViewProtocol?
    
    var selectedTask: Task?
    private let interactor: TasksInteractorProtocol
    private let router: TasksRouterProtocol
    private var filteredTasks: [Task] = []
    var tasksCount: Int {
        return filteredTasks.count
    }
    
    init(interactor: TasksInteractorProtocol, view: TasksViewProtocol, router: TasksRouterProtocol) {
        self.interactor = interactor
        self.view = view
        self.router = router
        interactor.fetchTasks()
    }
    func newLoad() {
        interactor.fetchTasks()
    }
    func loadTasks(tasks: [Task]) {
        self.filteredTasks = tasks.reversed()
        view?.reloadTableView()
    }
    func searchTasks(with query: String) {
        filteredTasks = interactor.searchTasks(with: query).reversed()
        view?.reloadTableView()
    }
    func toggleTaskCompletion(at task: Task) {
        guard let index = filteredTasks.firstIndex(where: { $0.id == task.id }) else {
            return
        }
        interactor.toggleTaskSelection(task: task) { [weak self] updatedTask in
            guard let self else { return }
            filteredTasks[index] = updatedTask
            view?.reloadTableView()
        }
    }
    func didSelectTask(at index: Int) {
        guard let view = view as? UIViewController else { return }
        router.navigateToTaskDetails(from: view, task: filteredTasks[index])
    }
    func task(at index: Int) -> Task {
        return filteredTasks[index]
    }
    func newView(type: TypeView, view: UIViewController) {
        switch type {
        case .new:
            router.navigateToTaskDetails(from: view, task: nil)
        case .edit:
            router.navigateToTaskDetails(from: view, task: selectedTask)
        }
    }
    func deleteSelectedTask() {
        guard let selectedTask else { return }
        interactor.deleteTask(task: selectedTask)
    }
    
}
