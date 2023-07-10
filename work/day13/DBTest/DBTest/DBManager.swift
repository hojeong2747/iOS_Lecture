//
//  DBManager.swift
//  DBTest
//
//  Created by Dongduk1 on 2023/07/10.
//

import Foundation
import SQLite3

class DBManager {
    let DB_NAME = "my_db.sqlite" // 확장자 지정 다르게 해도 됨
    let TABLE_NAME = "my_table"
    let COL_ID = "id"
    let COL_NAME = "name"
    
    var db: OpaquePointer? = nil
    
    func initDatabase() {
        openDatabase()
        createTable()
    }
    
    private func openDatabase() {
        let dbFile = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(DB_NAME)
        
        if sqlite3_open(dbFile.path, &db) == SQLITE_OK {
            print("successfully opened")
            print(dbFile) // 확인
        } else {
            print("unable to open DB")
        }
    }
    
    private func createTable() {
        let createTableString = """
        CREATE TABLE IF NOT EXISTS \(TABLE_NAME) ( \(COL_ID) INTEGER PRIMARY KEY AUTOINCREMENT, \(COL_NAME) TEXT);
        """
        
        var createTableSmt: OpaquePointer?
        
        print ("TABLE SQL: \(createTableString)")
        
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableSmt, nil) == SQLITE_OK {
            if sqlite3_step(createTableSmt) == SQLITE_DONE {
                print("successfully craeted.")
            }
            sqlite3_finalize(createTableSmt)
        } else {
            let error = String(cString: sqlite3_errmsg(db)!)
            print("Table Error: \(error)")
        }
    }
    
    func readAllData() {
        let sql = "select * from \(TABLE_NAME)"
        
        var queryResult: OpaquePointer?
        
        if sqlite3_prepare(db, sql, -1, &queryResult, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Reading Error: \(errmsg)")
            return
        }
        
        while(sqlite3_step(queryResult) == SQLITE_ROW) {
            let id = sqlite3_column_int(queryResult, 0)
            let name = String(cString: sqlite3_column_text(queryResult, 1))
            print("id: \(id) name: \(name)")
        }
        
        sqlite3_finalize(queryResult)
    }
    
    func insertData() {
        var insertStmt: OpaquePointer?
        
        if sqlite3_prepare_v2(db, "insert into \(TABLE_NAME) values (null, ?)", -1, &insertStmt, nil) == SQLITE_OK {
            let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
            
            if sqlite3_bind_text(insertStmt, 1, "test1", -1, SQLITE_TRANSIENT) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("Text Binding Failure: \(errmsg)")
                return
            }
            
            if sqlite3_step(insertStmt) == SQLITE_DONE {
                print("Successfully inserted.")
            } else {
                print("Insert error")
            }
            
            sqlite3_finalize(insertStmt)
        } else {
            print("Insert statement is not prepared.")
        }
    }
    
    func updateDate(_ colNo: Int, name: String) { // 파라미터 의미 맞나
        let query = "update \(TABLE_NAME) set \(COL_NAME) = ? where \(COL_ID) = ?"
        
        var updateStmt: OpaquePointer?
        
        if sqlite3_prepare(db, query, -1, &updateStmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing update: \(errmsg)")
            return
        }
        
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        
        if sqlite3_bind_text(updateStmt, 1, name, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Text Binding Failure: \(errmsg)")
            return
        }
        
        if sqlite3_bind_int(updateStmt, 2, Int32(colNo)) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Integer Binding Failure: \(errmsg)")
            return
        }
        
        if sqlite3_step(updateStmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Update Failure: \(errmsg)")
            return
        }
        
        sqlite3_finalize(updateStmt)
    }
    
    func deleteData() {
        let query = "delete from \(TABLE_NAME) where \(COL_ID) = ?"
        var deleteStmt: OpaquePointer?
        
        if sqlite3_prepare(db, query, -1, &deleteStmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing stmt: \(errmsg)")
            return
        }
        
        bindIntParams(deleteStmt!, no: 1, param: 1)
        
        if sqlite3_step(deleteStmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Delete Failure: \(errmsg)")
            return
        }
        
        sqlite3_finalize(deleteStmt)
    }
    
    func dropTable() {
        if sqlite3_exec(db, "drop table if exists \(TABLE_NAME)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Drop Error: \(errmsg)")
            return
        }
    }
    
    func closeDatabase() {
        if sqlite3_close(db) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Database Close Error: \(errmsg)")
            return
        }
    }
    
    func bindTextParams(_ stmt: OpaquePointer, no: Int, param: String) {
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        
        if sqlite3_bind_text(stmt, Int32(no), param, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Text Binding Failure: \(errmsg)")
            return
        }
    }
    
    func bindIntParams(_ stmt: OpaquePointer, no: Int, param: Int) {
        if sqlite3_bind_int(stmt, Int32(no), Int32(param)) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Integer Binding Failure: \(errmsg)")
            return
        }
    }
    
}
