//
//  CZEmoticonPackage.swift
//  WeiBo
//
//  Created by 八月夏木 on 2018/3/12.
//  Copyright © 2018年 八月夏木. All rights reserved.
//

import UIKit

class CZEmoticonPackage: NSObject {
    //
    @objc var groupName: String?
    @objc var bgImageName: String?
    @objc var directory: String? {
        didSet {
            //
            guard let directory = directory,
                let path = Bundle.main.path(forResource: "HMEmoticon.bundle", ofType: nil),
                let bundle = Bundle(path: path),
                let infoPath = bundle.path(forResource: "info.plist", ofType: nil, inDirectory: directory),
                let array = NSArray(contentsOfFile: infoPath) as? [[String: String]],
                let list = NSArray.yy_modelArray(with: CZEmoticon.self, json: array) as? [CZEmoticon]
            else { return }
            
            //
            for model in list {
                model.directory = directory
            }
            
            //
            emoticons += list
        }
    }
    
    //
    @objc lazy var emoticons = [CZEmoticon]()
    
    //
    @objc var numberOfPages: Int {
        return (emoticons.count - 1) / 20 + 1
    }
    
    //
    func emoticonsOfPage(_ page: Int) -> [CZEmoticon] {
        //
        let count = 20
        
        let loc = page * count
        var len = count
        
        if loc + len > emoticons.count {
            len = emoticons.count - loc
        }
        
        //
        let range = NSMakeRange(loc, len)
        let subArray = (emoticons as NSArray).subarray(with: range)
        
        return subArray as! [CZEmoticon]
    }
    
    //
    override var description: String {
        return yy_modelDescription()
    }
}














