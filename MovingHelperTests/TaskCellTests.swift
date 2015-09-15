//
//  TaskCellTests.swift
//  MovingHelper
//
//  Created by Zel Marko on 15/09/15.
//  Copyright (c) 2015 Razeware. All rights reserved.
//

import UIKit
import XCTest
import MovingHelper

class TaskCellTests: XCTestCase {
    
    func testCheckingCheckboxMarksTaskDone() {
        let cell = TaskTableViewCell()
        
        let expectation = expectationWithDescription("Task updated")
        
        struct TestDelegate: TaskUpdatedDelegate {
            let testExpectation: XCTestExpectation
            let expectedDone: Bool
            
            init(UpdatedExpectation: XCTestExpectation, expectedDoneStateAfterToggle: Bool) {
                testExpectation = UpdatedExpectation
                expectedDone = expectedDoneStateAfterToggle
            }
            
            func taskUpdated(task: Task) {
                XCTAssertEqual(expectedDone, task.done, "Task done state did not match expected!")
                testExpectation.fulfill()
            }
        }
        
        let testTask = Task(aTitle: "TestTask", aDueDate: .OneMonthAfter)
        XCTAssertFalse(testTask.done, "Newly created task is already done!")
        cell.delegate = TestDelegate(UpdatedExpectation: expectation, expectedDoneStateAfterToggle: true)
        cell.configureForTask(testTask)
        
        XCTAssertFalse(cell.checkbox.isChecked, "Checkbox checked for not-done task!")
        
        cell.checkbox.sendActionsForControlEvents(.TouchUpInside)
        
        XCTAssertTrue(cell.checkbox.isChecked, "Checkbox not checked after tap!")
        waitForExpectationsWithTimeout(1, handler: nil)
    }
}
