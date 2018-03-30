//
//  WBStatusListDAL.swift
//  WeiBo
//
//  Created by 八月夏木 on 2018/3/26.
//  Copyright © 2018年 八月夏木. All rights reserved.
//

import Foundation

class WBStatusListDAL {
    ///
    class func loadStatuses(since_id: Int64 = 0,
                            max_id: Int64 = 0,
                            completion: @escaping ([[String: Any]]?, Bool) -> ()) {
        //
        guard let userId = WBNetworkManager.shared.userAccount.uid else {
            return
        }
        
        //
        let array = CZSQLiteManager.shared.statusList(userId: userId, since_id: since_id, max_id: max_id)
        
        if array.count > 0 {
            completion(array, true)
            return
        }
        
        //
        WBNetworkManager.shared.statusList(since_id: since_id, max_id: max_id) { (list, isSuccess) in
            //
            if !isSuccess {
                completion(nil, false)
                return
            }
            
            guard let list = list else {
                completion(nil, isSuccess)
                return
            }
            
            //
            completion(list, isSuccess)
            
            //
            CZSQLiteManager.shared.updateStatuses(userId: userId, statuses: list)
        }
    }
    
    ///
}









