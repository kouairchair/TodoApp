//
//  AppDatabase.swift
//  TodoApp
//
//  Created by Koki Tanaka on 2020/04/28.
//  Copyright © 2020 Koki Tanaka. All rights reserved.
//

import GRDB

//struct World {
//    /// Access to the players database
//    func players() -> Players { return Players(database: database()) }
//
//    /// The database, private so that only high-level operations exposed by
//    /// `players` are available to the rest of the application.
//    private var database: () -> DatabaseWriter
//
//    /// Creates a World with a database
//    init(database: @escaping () -> DatabaseWriter) {
//        self.database = database
//    }
//}
//var Current = World(database: { fatalError("Database is uninitialized") })
/// A type responsible for initializing an application database.
struct AppDatabase {
    
    /// Prepares a fully initialized database at path
    func setup(_ database: DatabaseWriter) throws {
        // Use DatabaseMigrator to define the database schema
        // See https://github.com/groue/GRDB.swift/#migrations
        try migrator.migrate(database)
        
        // Other possible setup include: custom functions, collations,
        // full-text tokenizers, etc.
    }
    
    /// The DatabaseMigrator that defines the database schema.
    // See https://github.com/groue/GRDB.swift/#migrations
    private var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()
        
        #if DEBUG
        // Speed up development by nuking the database when migrations change
        migrator.eraseDatabaseOnSchemaChange = true
        #endif
        
        migrator.registerMigration("v1.0") { db in
            try db.create(table: "toDoTask") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("name", .text).notNull().collate(.localizedCaseInsensitiveCompare)
                t.column("sectionNo", .integer)
                t.column("priority", .integer)
//                t.column("dueDate", .datetime)
//                t.column("isDone", .boolean).notNull()
            }
            
//            try db.create(table: "section") { t in
//                t.column("sectionId", .double).notNull()
//                t.column("name", .double).notNull()
//                t.column("isCurrent", .boolean).notNull()
//                t.primaryKey(["sectionId"])
//            }
        }
        
        return migrator
    }
}

