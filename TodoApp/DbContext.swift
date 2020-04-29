//
//  DbContext.swift
//  TodoApp
//
//  Created by Koki Tanaka on 2020/04/28.
//  Copyright © 2020 Koki Tanaka. All rights reserved.
//

import GRDB

struct DbContext {
    /// Access to the players database
    func toDoTaskManagers() -> ToDoTaskManager { return ToDoTaskManager(database: database()) }
    
    /// The database, private so that only high-level operations exposed by
    /// `players` are available to the rest of the application.
    private var database: () -> DatabaseWriter
    
    /// Creates a World with a database
    init(database: @escaping () -> DatabaseWriter) {
        self.database = database
    }
}
var Current = DbContext(database: { fatalError("Database is uninitialized") })
