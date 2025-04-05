//
//  DatabaseStuff.swift
//  iNeedFood
//
//  Created by Henry Dalton on 4/4/25.
//  Note: Much of the DatabaseManager Class code was AI generated, with some mild refactoring by me.
//  SQL database and schema were entirely created by me

import Foundation
import SQLite3

//Local models for handling database info
struct Store {
    let id: Int
    let name: String
}

struct Item {
    let id: Int
    let name:String
    let calories: Int
    let cost: Float
    let storeID: Int
}

final class DatabaseManager {
    //class variables
    static let shared = DatabaseManager()
    private var db: OpaquePointer?
    //init function
    private init() {
        copyDBifNeeded()
        openDB()
    }
    
    //constants
    
    private let dbName = "UNR.db"
    
    private var docsURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    private var dbURL: URL {
        docsURL.appendingPathComponent(dbName)
    }
    
    private var dbPath: String {
        dbURL.path
    }
    
    //setup functions
    
    private func copyDBifNeeded() {
        let fileManager = FileManager.default
        
        guard let bundleURL = Bundle.main.url(forResource: "UNR", withExtension: "db")
        else {
            print("UNR.db not found in assets")
            return
        }
        
        if !fileManager.fileExists(atPath: dbPath) {
            do {
                try fileManager.copyItem(at: bundleURL, to: dbURL)
                print("Database copied to documents directory")
            } catch {
                print("Error copying database: \(error)")
            }
        }
        else {
            print("Database already exists at destination")
        }
    }
    
    private func openDB() {
        if sqlite3_open(dbPath, &db) == SQLITE_OK {
            print ("Successfully opened database at \(dbPath)")
        } else {
            print ("Unable to open database.")
        }
    }
    
    func closeDB() {
        sqlite3_close(db)
        print ("Database closed.")
    }
    
    //Read operations
    
    //Stores
    func getStoreByID(by id: Int) -> Store? {
        let query = "SELECT * FROM Store WHERE id = ?;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(id))
            
            if sqlite3_step(statement) == SQLITE_ROW {
                let storeID = Int(sqlite3_column_int(statement, 0))
                let storeName = String(cString: sqlite3_column_text(statement, 1))
                
                sqlite3_finalize(statement)
                return Store(id: storeID, name: storeName)
            }
        }
        
        sqlite3_finalize(statement)
        return nil
    }
    
    func getAllStores() -> [Store]? {
        var stores: [Store] = []
        let query = "SELECT * FROM Store;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) != SQLITE_DONE {
                let storeID = Int(sqlite3_column_int(statement, 0))
                let storeName = String(cString: sqlite3_column_text(statement, 1))
                
                stores.append(Store(id: storeID, name: storeName))
            }
            
            sqlite3_finalize(statement)
            print("Queried Stores: \(stores)")
            return stores
        }
        
        sqlite3_finalize(statement)
        return nil
    }
    
    //Items
    func getItemsByStore (by storeID: Int) -> [Item]? {
        var items: [Item] = []
        let query = "SELECT * FROM Item WHERE store_id = ?;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(storeID))
            
            while sqlite3_step(statement) == SQLITE_ROW {
                let itemID = Int(sqlite3_column_int(statement, 0))
                let itemName = String(cString: sqlite3_column_text(statement, 1))
                let itemCal = Int(sqlite3_column_int(statement, 2))
                let itemCost = Float(sqlite3_column_double(statement, 3))
                let storeID = Int(sqlite3_column_int(statement, 4))
                
                items.append(Item(id: itemID, name: itemName, calories: itemCal, cost: itemCost, storeID: storeID))
            }
            
            sqlite3_finalize(statement)
            return items
        }
        
        sqlite3_finalize(statement)
        return nil
    }
}
