//
//  TasksInteractorTests.swift
//  todotest
//
//  Created by Иван Незговоров on 18.11.2024.
//


import XCTest
@testable import todotest

final class TasksInteractorTests: XCTestCase {
    var interactor: TasksInteractor!
    var mockPresenter: MockTasksPresenter!
    var mockCoreDataStack: MockCoreDataStack!

    override func setUp() {
        super.setUp()
        mockPresenter = MockTasksPresenter()
        mockCoreDataStack = MockCoreDataStack()
        interactor = TasksInteractor()
        interactor.presenter = mockPresenter
    }

    override func tearDown() {
        interactor = nil
        mockPresenter = nil
        mockCoreDataStack = nil
        super.tearDown()
    }

    func testFetchTasks_FirstLaunch() {
        // Arrange
        UserDefaults.standard.set(false, forKey: "hasLaunchedBefore")

        // Act
        interactor.fetchTasks()

        // Assert
        XCTAssertTrue(mockPresenter.didLoadTasks)
    }

    func testSearchTasks() {
        // Arrange
        interactor.fetchTasks()
        interactor.tasks = [
            Task(id: 1, title: "Task 1", description: "Test description", date: Date(), isCompleted: false),
            Task(id: 2, title: "Task 2", description: "Other description", date: Date(), isCompleted: false)
        ]

        // Act
        let results = interactor.searchTasks(with: "Test")

        // Assert
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.description, "Test description")
    }
}

// Mock
final class MockTasksPresenter: TasksPresenterProtocol {
    var didLoadTasks = false
    var tasksCount: Int { return 0 }
    var selectedTask: Task?

    func loadTasks(tasks: [Task]) {
        didLoadTasks = true
    }

    func searchTasks(with query: String) {}
    func toggleTaskCompletion(at task: Task) {}
    func didSelectTask(at index: Int) {}
    func task(at index: Int) -> Task { return Task(id: 0, title: "", description: "", date: Date(), isCompleted: false) }
    func deleteSelectedTask() {}
    func newLoad() {}
    func newView(type: TypeView, view: UIViewController) {}
}

final class MockCoreDataStack {
    private var mockTasks: [Task] = []

    // Метод для мока создания задачи
    func createTaskFirstTime(task: Task) {
        mockTasks.append(task)
    }

    // Метод для получения всех задач
    func fetchAllTasks() -> [MockTaskEntity] {
        return mockTasks.map { task in
            MockTaskEntity(
                id: task.id,
                title: task.title,
                descriptionText: task.description,
                date: task.date,
                isCompleted: task.isCompleted
            )
        }
    }

    // Метод для обновления состояния задачи
    func toggleTaskSelection(by id: String, completion: @escaping (Bool) -> Void) {
        if let index = mockTasks.firstIndex(where: { String($0.id) == id }) {
            mockTasks[index].isCompleted.toggle()
            completion(true)
        } else {
            completion(false)
        }
    }

    // Метод для удаления задачи
    func deleteTask(task: Task, completion: @escaping (Bool) -> Void) {
        if let index = mockTasks.firstIndex(where: { $0.id == task.id }) {
            mockTasks.remove(at: index)
            completion(true)
        } else {
            completion(false)
        }
    }
}

// Моковая сущность задачи для имитации Core Data
struct MockTaskEntity {
    var id: Int
    var title: String
    var descriptionText: String
    var date: Date
    var isCompleted: Bool
}
