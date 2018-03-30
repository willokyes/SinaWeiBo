//
//  WBStatusListViewModel.swift
//  WeiBo
//
//  Created by 八月夏木 on 2018/1/10.
//  Copyright © 2018年 八月夏木. All rights reserved.
//

import Foundation
import YYModel
import SDWebImage

/// 微博数据列表视图模型
/*
 父类的选择
 - 如果类需要使用 'KVC' 或者字典转模型框架设置对象值，类就需要继承自 NSObject
 - 如果类只是包装一些代码逻辑（写了一些函数），可以不用任何父类，好处：更加轻量级
 - 提示：如果用 OC 写，一律都继承自 NSObject 即可
 */

/// 负责微博的数据处理：获取当前登录用户及其所关注用户的最新微博

private let maxPullUpTryTimes = 3

class WBStatusListViewModel {
    //
    lazy var statusList = [WBStatusViewModel]()
    
    private var pullUpErrorTimes = 0
    
    func loadStatuses(isPullUp: Bool, completion: @escaping (Bool, Bool)->()) {
        //
        if isPullUp && pullUpErrorTimes > maxPullUpTryTimes {
            completion(false, false)
            return
        }
        
        //
        let since_id = isPullUp ? 0 : (self.statusList.first?.status.id ?? 0)
        let max_id = !isPullUp ? 0:  (self.statusList.last?.status.id ?? 0)
        
        //
        WBStatusListDAL.loadStatuses(since_id: since_id, max_id: max_id) { (list, isSuccess) in
            //
            if !isSuccess {
                completion(false, false)
                return
            }
            
            //
            guard let list = list else {
                //
                if isPullUp {
                    self.pullUpErrorTimes += 1
                }
                completion(isSuccess, false)
                return
            }
            
            //
            var array = [WBStatusViewModel]()
            
            for dict in list {
                //
                guard let model = WBStatus.yy_model(with: dict) else {
                    continue
                }
                
                //
                array.append(WBStatusViewModel(model: model))
            }
            
            //
            Print(self, "新增 \(array.count) 条微博！")
            //Print(self, "新增 \(array.count) 条微博！ \n\(array)")
            
            //
            if array.count > 0 {
                if isPullUp {
                    self.statusList += array
                } else {
                    self.statusList = array + self.statusList
                }
                
                //
                self.cacheSingleImage(list: array, finished: completion)
            } else {
                //
                if isPullUp {
                    self.pullUpErrorTimes += 1
                }
                completion(isSuccess, false)
            }
        }
    }
    
    ///
    private func cacheSingleImage(list: [WBStatusViewModel], finished: @escaping (Bool, Bool)->()) {
        //
        var length = 0
        
        //
        let group = DispatchGroup()
        
        //
        for vm in list {
            //
            if vm.picURLs?.count != 1 {
                continue
            }
            
            //
            guard let pic = vm.picURLs?[0].thumbnail_pic,
                let url = URL(string: pic) else {
                    continue
            }
            
            //
            group.enter()
            SDWebImageManager.shared().loadImage(with: url, options: [], progress: nil, completed: {
                (image, data, error, cacheType, finished, imageURL) in
                //
                if let image = image, let imageData = UIImageJPEGRepresentation(image, 1.0) {
                    length += imageData.count
                    
                    //
                    vm.updatePictureViewSizeOfSingleImage(image: image)
                }
                
                //
                Print(self, "已缓存图片：\(String(describing: url))")
                
                //
                group.leave()
            })
        }
        
        //
        group.notify(queue: DispatchQueue.main) {
            //
            Print(self, "图片缓存完成：\(length / 1024) K")
            
            //
            finished(true, true)
        }
        
    }
}











