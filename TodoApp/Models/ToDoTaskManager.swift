//
//  ToDoTaskManager.swift
//  TodoApp
//
//  Created by Koki Tanaka on 2020/04/28.
//  Copyright © 2020 Koki Tanaka. All rights reserved.
//

import Foundation
import GRDB
import RxGRDB

class ToDoTaskManager: DbManager<ToDoTask> {
    // MARK: - Implementation
    //
    // ⭐️ Good practice: when we want to update the database, we define methods
    // that accept a Database connection, because they can easily be composed.
    
    /// Creates random players if needed, and returns whether the database
    /// was empty.
    override func _populateIfEmpty(_ db: Database) throws -> Bool {
        if try ToDoTask.fetchCount(db) > 0 {
            return false
        }

        // Insert new random players
        for _ in 0..<8 {
            var task = ToDoTask(id: nil, name: "test task", sectionNo: 0, priority: 0)
            try task.insert(db)
        }
        return true
    }

    override func _deleteAll(_ db: Database) throws {
        try ToDoTask.deleteAll(db)
    }

    override func _deleteOne(_ db: Database, record: ToDoTask) throws {
        try record.delete(db)
    }

    override func _refresh(_ db: Database) throws {
        if try _populateIfEmpty(db) {
            return
        }

        
    }
}
