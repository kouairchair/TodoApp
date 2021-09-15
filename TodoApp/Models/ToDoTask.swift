//
//  ToDoTask.swift
//  TodoApp
//
//  Created by Koki Tanaka on 2020/04/28.
//  Copyright © 2020 Koki Tanaka. All rights reserved.
//

import GRDB
import Foundation

// A player
struct ToDoTask: Codable, Equatable {
    var id: Int64?
    var name: String
    var sectionNo: Int
    var priority: Int
//    var duteDate: DateTime
}

// Adopt FetchableRecord so that we can fetch players from the database.
// Implementation is automatically derived from Codable.
extension ToDoTask: FetchableRecord { }

// Adopt MutablePersistable so that we can create/update/delete players in the
// database. Implementation is partially derived from Codable.
extension ToDoTask: MutablePersistableRecord {
    // Update auto-incremented id upon successful insertion
    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}

// Define columns that we can use for our database requests.
// They are derived from the CodingKeys enum for extra safety.
extension ToDoTask {
    fileprivate enum Columns {
        static let id = Column(CodingKeys.id)
        static let name = Column(CodingKeys.name)
        static let sectionNo = Column(CodingKeys.sectionNo)
        static let priority = Column(CodingKeys.priority)
    }
}

// Define requests of players in a constrained extension to the
// DerivableRequest protocol.
extension DerivableRequest where RowDecoder == ToDoTask {
    func orderBySectionNo() -> Self {
        return order(ToDoTask.Columns.sectionNo, ToDoTask.Columns.priority.desc)
    }
    
    func orderByPriority() -> Self {
        return order(ToDoTask.Columns.priority.desc, ToDoTask.Columns.sectionNo)
    }
}

//// Player randomization
//extension ToDoTask {
//    private static let names = [
//        "Arthur", "Anita", "Barbara", "Bernard", "Clément", "Chiara", "David",
//        "Dean", "Éric", "Elena", "Fatima", "Frederik", "Gilbert", "Georgette",
//        "Henriette", "Hassan", "Ignacio", "Irene", "Julie", "Jack", "Karl",
//        "Kristel", "Louis", "Liz", "Masashi", "Mary", "Noam", "Nolwenn",
//        "Ophelie", "Oleg", "Pascal", "Patricia", "Quentin", "Quinn", "Raoul",
//        "Rachel", "Stephan", "Susie", "Tristan", "Tatiana", "Ursule", "Urbain",
//        "Victor", "Violette", "Wilfried", "Wilhelmina", "Yvon", "Yann",
//        "Zazie", "Zoé"]
//
//    static func randomName() -> String {
//        return names.randomElement()!
//    }
//
//    static func randomScore() -> Int {
//        return 10 * Int.random(in: 0...100)
//    }
//}
