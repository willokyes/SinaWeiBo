//
//  CZSQLiteManager.swift
//  WeiBo
//
//  Created by 八月夏木 on 2018/3/25.
//  Copyright © 2018年 八月夏木. All rights reserved.
//

import Foundation
import FMDB

private let kDbMaxCacheAge: TimeInterval = -3 * 60

class CZSQLiteManager {
    //
    static let shared = CZSQLiteManager()
    
    //
    let queue: FMDatabaseQueue
    
    //
    private init() {
        //
        let dbName = "statuses.db"
        
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        path = (path as NSString).appendingPathComponent(dbName)
        
        //
        queue = FMDatabaseQueue(path: path)
        
        //
        Print(self, "微博数据库路径：\(path)")
        
        //
        createTable()
        
        //
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(backgroundCleanDbCache),
                                               name: NSNotification.Name.UIApplicationDidEnterBackground,
                                               object: nil)
    }
    
    //
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //
    @objc func backgroundCleanDbCache() {
        //
        let dateStr = Date.cz_dateString(delta: kDbMaxCacheAge)
        
        //
        Print(self, "清理 SQLite 数据库数据缓存（早于 \(dateStr)）")
        
        //
        let sql = "DELETE FROM T_Statuses WHERE createTime < ?"
        
        queue.inDatabase { (db) in
            //
            if db.executeUpdate(sql, withArgumentsIn: [dateStr]) {
                Print(self, "删除了 \(db.changes) 条记录")
            }
        }
        
    }
}

///
private extension CZSQLiteManager {
    //
    func createTable() {
        //
        guard let path = Bundle.main.path(forResource: "status.sql", ofType: nil),
            let sql = try? String(contentsOfFile: path) else {
            return
        }

        Print(self, sql)
        
        queue.inDatabase { (db) in
            if db.executeStatements(sql) {
                Print(self, "创建表成功！")
            } else {
                Print(self, "创建表失败！")
            }
        }
    }
}

extension CZSQLiteManager {
    //
    func execRecordSet(sql: String) -> [[String: Any]] {
        //
        var result = [[String: Any]]()
        
        //
        queue.inDatabase { (db) in
            //
            guard let rs = db.executeQuery(sql, withArgumentsIn: []) else {
                return
            }
            
            while rs.next() {
                //
                let colCount = rs.columnCount
                
                var dict = [String: Any]()
                
                for col in 0..<colCount {
                    guard let name = rs.columnName(for: col),
                        let value = rs.object(forColumnIndex: col) else {
                        continue
                    }
                    
                    dict[name] = value
                }
                
                result.append(dict)
            }
        }
        
        return result
    }
    
    //
    func updateStatuses(userId: String, statuses: [[String: Any]]) {
        //
        let sql = "INSERT OR REPLACE INTO T_Statuses (statusId, userId, status) VALUES (?, ?, ?);"
        
        queue.inTransaction { (db, rollback) in
            //
            for dict in statuses {
                //
                guard let statusId = dict["idstr"] as? String,
                    let statusData = try? JSONSerialization.data(withJSONObject: dict, options: []) else {
                        continue
                }
                
                //
                if db.executeUpdate(sql, withArgumentsIn: [statusId, userId, statusData]) == false {
                    rollback.pointee = true
                    break
                }
            }
        }
    }
}

///
extension CZSQLiteManager {
    //
    func statusList(userId: String, since_id: Int64 = 0, max_id: Int64 = 0) -> [[String: Any]] {
        //
        var sql = "SELECT statusId, userId, status FROM T_Statuses \n"
        sql += "WHERE userId = \(userId) \n"
        
        if since_id > 0 {
            sql += "AND statusId > \(since_id) \n"
        } else if max_id > 0 {
            sql += "AND statusId < \(max_id) \n"
        }
        
        sql += "ORDER BY statusId DESC LIMIT 20"
        
        //
        Print(self, sql)
        
        //
        let array = execRecordSet(sql: sql)
        
        var statuses = [[String: Any]]()
        
        for dict in array {
            //
            guard let statusData = dict["status"] as? Data,
                let jsonObject = try? JSONSerialization.jsonObject(with: statusData, options: []),
                let status = jsonObject as? [String: Any] else {
                continue
            }
            
            statuses.append(status)
        }
        
        return statuses
    }
    
}















