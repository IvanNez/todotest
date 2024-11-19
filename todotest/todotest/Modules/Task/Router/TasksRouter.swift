//
//  TasksRouterProtocol.swift
//  todotest
//
//  Created by Иван Незговоров on 18.11.2024.
//

import UIKit

protocol TasksRouterProtocol {
    func navigateToTaskDetails(from view: UIViewController, task: Task?)
}

final class TasksRouter: TasksRouterProtocol {
    func navigateToTaskDetails(from view: UIViewController, task: Task?) {
        let descriptionTask = TasksModuleBuilder.taskDetailsBuild(task: task)
        view.navigationController?.pushViewController(descriptionTask, animated: true)
    }
}
