//
//  AppDelegate.swift
//  TodoApp
//
//  Created by Koki Tanaka on 2020/04/28.
//  Copyright © 2020 Koki Tanaka. All rights reserved.
//
// https://qiita.com/akifumi1118/items/aa5734b1f14d57072456
// https://github.com/groue/GRDB.swift
// https://github.com/groue/GRDB.swift/blob/master/README.md#codable-records
// 

import Cocoa
import SwiftUI
import GRDB

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()
        let application: NSApplication = NSApplication.shared
        // Enhanced multithreading based on SQLite's WAL mode
        do {
            // Setup the Current World
            let dbPool = try! setupDatabase(application)
            Current = DbContext(database: { dbPool })
            
            // Application is nicer looking if it starts populated
            try! Current.toDoTaskManagers().populateIfEmpty()
        } catch {
            fatalError("Failed to connect DB")
        }

        // Create the window and set the content view. 
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    private func setupDatabase(_ application: NSApplication) throws -> DatabasePool {
        // Create a DatabasePool for efficient multi-threading
        let databaseURL = try FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("db.sqlite")
        let dbPool = try DatabasePool(path: databaseURL.path)
        
        // Be a nice iOS citizen, and don't consume too much memory
        // See https://github.com/groue/GRDB.swift/blob/master/README.md#memory-management
        // 以下はiOSのみ使える
//        dbPool.setupMemoryManagement(in: application)
        
        // Setup the database
        try AppDatabase().setup(dbPool)
        
        return dbPool
    }

}

