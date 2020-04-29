//
//  records.swift
//  TodoApp
//
//  Created by Koki Tanaka on 2020/04/28.
//  Copyright © 2020 Koki Tanaka. All rights reserved.
//

import Foundation
import GRDB
import RxGRDB
import RxSwift

/// Players is responsible for high-level operations on the players database.
class DbManager<T: FetchableRecord> {
    private let database: DatabaseWriter
    
    init(database: DatabaseWriter) {
        self.database = database
    }
    
    /// Creates random players if needed, and returns whether the database
    /// was empty.
    @discardableResult
    func populateIfEmpty() throws -> Bool {
        return try database.write(_populateIfEmpty)
    }
    
    func deleteAll() -> Completable {
        return database.rx.write(updates: _deleteAll)
    }
    
    func deleteOne(_ record: T) -> Completable {
        return database.rx.write(updates: { db in
            try self._deleteOne(db, record: record)
        })
    }
    
    func refresh() -> Completable {
        return database.rx.write(updates: _refresh)
    }
    
    func stressTest() -> Completable {
        return Completable.zip(repeatElement(refresh(), count: 50))
    }
    
    // MARK: - Access Players
    
    /// An observable that tracks changes in any request of players
    func observeAll(_ request: QueryInterfaceRequest<T>) -> Observable<[T]> {
        return request.rx.observeAll(in: database)
    }
    
    func _populateIfEmpty(_ db: Database) throws -> Bool {
        preconditionFailure("This method must be overridden")
    }

    func _deleteAll(_ db: Database) throws {
        preconditionFailure("This method must be overridden")
    }

    func _deleteOne(_ db: Database, record: T) throws {
        preconditionFailure("This method must be overridden")
    }

    func _refresh(_ db: Database) throws {
        preconditionFailure("This method must be overridden") 
    }
}
