//
//  DBManager.swift
//  MyApp
//
//  Created by cs_mac on 2020/07/22.
//  Copyright © 2020 cs_mac. All rights reserved.
//

import Foundation
import SQLite3

class DBManager {
    
    let DB_NAME = "final_db.sqlite"
    let TABLE_NAME = "final_table"
    let COL_ID = "id"
    let COL_TITLE = "title"
    let COL_DATE = "date"
    let COL_DETAIL = "detail"
    let COL_ICON = "icon"
    
    var db : OpaquePointer?
    
//    앱을 실행할 때 수행
    func initDatabase() {
        openDatabase()
        createTable()
//        closeDatabase()
        // -> 왜 close를 여기서 하는 거지?
    }
    
//    DB 사용 전에 호출
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
    
//    테이블 생성
    private func createTable() {
        let createTableString = """
        CREATE TABLE IF NOT EXISTS \(TABLE_NAME) ( \(COL_ID) INTEGER PRIMARY KEY AUTOINCREMENT, \(COL_TITLE) TEXT, \(COL_DATE) INTEGER, \(COL_DETAIL) TEXT, \(COL_ICON) TEXT);
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
    
//    DB 완료 후 호출 
    private func closeDatabase() {
        if sqlite3_close(db) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Database Close Error: \(errmsg)")
            return
        }
    }
    
//    items 배열에 DB의 내용 전체를 추가
    func readAllData() {
//        샘플이므로 DB 구현 시 주석 처리
//        items.append(TaskDto(id: 1, title: "hello!!", date: 1595415833, detail: "hi", icon: "clock.png"))
//        items.append(TaskDto(id: 2, title: "안녕하세요!!", date: 1595415833, detail: "안녕", icon: "cart.png"))
        
        // 샘플 insert 로 추가 확인
    
        
        // read
        let sql = "select * from \(TABLE_NAME)"
        
        var queryResult: OpaquePointer?
        
        if sqlite3_prepare(db, sql, -1, &queryResult, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Reading Error: \(errmsg)")
            return
        }
        
        while(sqlite3_step(queryResult) == SQLITE_ROW) {
            let id = sqlite3_column_int(queryResult, 0)
            let title = String(cString: sqlite3_column_text(queryResult, 1))
            let date = sqlite3_column_int(queryResult, 2)
            let detail = String(cString: sqlite3_column_text(queryResult, 3))
            let icon = String(cString: sqlite3_column_text(queryResult, 4))
            
            // db 내용 읽어와서 items 배열에 dto 요소로 모두 추가
            items.append(TaskDto(id: Int(id), title: title, date: Int32(date), detail: detail, icon: icon))
            print("id: \(id) name: \(title) date: \(date) detail: \(detail) icon: \(icon)")
        }
        
        sqlite3_finalize(queryResult)
        
        print(items)
    }

//    항목 추가
    func insertData(title: String, date: Int32, detail: String, icon: String) {
        var insertStmt: OpaquePointer?
        
        if sqlite3_prepare_v2(db, "insert into \(TABLE_NAME) values (null, ?, ?, ?, ?)", -1, &insertStmt, nil) == SQLITE_OK {
            let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
            
            if sqlite3_bind_text(insertStmt, 1, title, -1, SQLITE_TRANSIENT) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("Text Binding Failure: \(errmsg)")
                return
            }
            
            if sqlite3_bind_int(insertStmt, 2, date) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("Text Binding Failure: \(errmsg)")
                return
            }
            
            if sqlite3_bind_text(insertStmt, 3, detail, -1, SQLITE_TRANSIENT) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("Text Binding Failure: \(errmsg)")
                return
            }
            
            if sqlite3_bind_text(insertStmt, 4, icon, -1, SQLITE_TRANSIENT) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("Text Binding Failure: \(errmsg)")
                return
            }
            
            if sqlite3_step(insertStmt) == SQLITE_DONE {
                print("Successfully inserted.")
            } else {
                print("Insert error")
            }
            
            items.append(TaskDto(id: nil, title: title, date: Int32(date), detail: detail, icon: icon))
            print("insert name: \(title) date: \(date) detail: \(detail) icon: \(icon)")
            
            sqlite3_finalize(insertStmt)
        } else {
            print("Insert statement is not prepared.")
        }
        
    }

    
//    항목 수정
    func updateData(id: Int, title: String, date: Int32, detail: String, icon: String) {
        let query = "update \(TABLE_NAME) set \(COL_TITLE) = ?, \(COL_DATE) = ?, \(COL_DETAIL) = ?, \(COL_ICON) = ? where \(COL_ID) = ? "
        
        var updateStmt: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &updateStmt, nil) == SQLITE_OK {
            let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
            
            if sqlite3_bind_text(updateStmt, 1, title, -1, SQLITE_TRANSIENT) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("Text Binding Failure: \(errmsg)")
                return
            }
            
            if sqlite3_bind_int(updateStmt, 2, date) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("Text Binding Failure: \(errmsg)")
                return
            }
            
            if sqlite3_bind_text(updateStmt, 3, detail, -1, SQLITE_TRANSIENT) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("Text Binding Failure: \(errmsg)")
                return
            }
            
            if sqlite3_bind_text(updateStmt, 4, icon, -1, SQLITE_TRANSIENT) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("Text Binding Failure: \(errmsg)")
                return
            }
            
            if sqlite3_bind_int(updateStmt, 5, Int32(id)) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("Text Binding Failure: \(errmsg)")
                return
            }
            
            if sqlite3_step(updateStmt) == SQLITE_DONE {
                print("Successfully updated.")
            } else {
                print("Update error")
            }
            
            items.append(TaskDto(id: nil, title: title, date: Int32(date), detail: detail, icon: icon))
            print("update name: \(title) date: \(date) detail: \(detail) icon: \(icon)")
            
            sqlite3_finalize(updateStmt)
        } else {
            print("Update statement is not prepared.")
        }
        
    }

    
//    항목 삭제
    func deleteData(id: Int) {
        let query = "delete from \(TABLE_NAME) where \(COL_ID) = ?"
        var deleteStmt: OpaquePointer?
        
        if sqlite3_prepare(db, query, -1, &deleteStmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing stmt: \(errmsg)")
            return
        }
        
        bindIntParams(deleteStmt!, no: 1, param: id)
        
        if sqlite3_step(deleteStmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Delete Failure: \(errmsg)")
            return
        }
        
        sqlite3_finalize(deleteStmt)
    }
    
    func bindIntParams(_ stmt: OpaquePointer, no: Int, param: Int) {
        if sqlite3_bind_int(stmt, Int32(no), Int32(param)) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Integer Binding Failure: \(errmsg)")
            return
        }
    }
}
