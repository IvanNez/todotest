//
//  TasksRouterTests.swift
//  todotest
//
//  Created by Иван Незговоров on 18.11.2024.
//


import XCTest
@testable import todotest

final class TasksRouterTests: XCTestCase {
    var router: TasksRouter!
    var mockViewController: MockNavigationController!

    override func setUp() {
        super.setUp()
        router = TasksRouter()
        mockViewController = MockNavigationController()
    }

    override func tearDown() {
        router = nil
        mockViewController = nil
        super.tearDown()
    }

    func testNavigateToTaskDetails_withTask() {
        // Arrange
        let task = Task(id: 1, title: "Test", description: "Test description", date: Date(), isCompleted: false)

        // Act
        router.navigateToTaskDetails(from: mockViewController, task: task)

        // Assert
        XCTAssertTrue(mockViewController.didNavigate)
        XCTAssertEqual(mockViewController.pushedViewController is DescriptionViewController, true)
    }

    func testNavigateToTaskDetails_withoutTask() {
        // Act
        router.navigateToTaskDetails(from: mockViewController, task: nil)

        // Assert
        XCTAssertTrue(mockViewController.didNavigate)
        XCTAssertEqual(mockViewController.pushedViewController is DescriptionViewController, true)
    }
}

// Mock
final class MockNavigationController: UINavigationController {
    var didNavigate = false
    var pushedViewController: UIViewController?

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        didNavigate = true
        pushedViewController = viewController
        super.pushViewController(viewController, animated: animated)
    }
}
