//
//  TasksPresenterTests.swift
//  todotest
//
//  Created by Иван Незговоров on 18.11.2024.
//


import XCTest
@testable import todotest

final class TasksPresenterTests: XCTestCase {
    var presenter: TasksPresenter!
    var mockView: MockTasksView!
    var mockRouter: MockTasksRouter!
    var mockInteractor: MockTasksInteractor!

    override func setUp() {
        super.setUp()
        mockView = MockTasksView()
        mockRouter = MockTasksRouter()
        mockInteractor = MockTasksInteractor()
        presenter = TasksPresenter(interactor: mockInteractor, view: mockView, router: mockRouter)
    }

    override func tearDown() {
        presenter = nil
        mockView = nil
        mockRouter = nil
        mockInteractor = nil
        super.tearDown()
    }

    func testLoadTasks() {
        // Arrange
        let tasks = [
            Task(id: 1, title: "Task 1", description: "Description 1", date: Date(), isCompleted: false),
            Task(id: 2, title: "Task 2", description: "Description 2", date: Date(), isCompleted: true)
        ]

        // Act
        presenter.loadTasks(tasks: tasks)

        // Assert
        XCTAssertEqual(presenter.tasksCount, 2)
        XCTAssertTrue(mockView.didReloadTableView)
    }

    func testDidSelectTask() {
        // Arrange
        let task = Task(id: 1, title: "Task 1", description: "Description 1", date: Date(), isCompleted: false)
        presenter.loadTasks(tasks: [task])

        // Act
        presenter.didSelectTask(at: 0)

        // Assert
        XCTAssertTrue(mockRouter.didNavigateToTaskDetails)
    }
}

// Mock
final class MockTasksView: TasksViewProtocol {
    var didReloadTableView = false

    func reloadTableView() {
        didReloadTableView = true
    }
}

final class MockTasksRouter: TasksRouterProtocol {
    var didNavigateToTaskDetails = false

    func navigateToTaskDetails(from view: UIViewController, task: Task?) {
        didNavigateToTaskDetails = true
    }
}

final class MockTasksInteractor: TasksInteractorProtocol {
    var tasks: [Task] = []

    func fetchTasks() {}
    func loadTasksFromCoreData() {}
    func searchTasks(with query: String) -> [Task] { return tasks }
    func toggleTaskSelection(task: Task, completion: @escaping (Task) -> Void) {}
    func deleteTask(task: Task) {}
}
