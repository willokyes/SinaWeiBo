//
//  CZEmoticonManager.swift
//  WeiBo
//
//  Created by 八月夏木 on 2018/3/12.
//  Copyright © 2018年 八月夏木. All rights reserved.
//

import Foundation
import YYModel

class CZEmoticonManager {
    //
    static let shared = CZEmoticonManager()
    
    //
    lazy var packages = [CZEmoticonPackage]()
    
    //
    lazy var bundle: Bundle = {
        return Bundle(path: Bundle.main.path(forResource: "HMEmoticon.bundle", ofType: nil) ?? "")!
    }()
    
    //
    private init() {
        loadPackages()
    }
    
    //
}

//
private extension CZEmoticonManager {
    //
    func loadPackages() {
        //
        guard let path = Bundle.main.path(forResource: "HMEmoticon.bundle", ofType: nil),
            let bundle = Bundle(path: path),
            let plistPath = bundle.path(forResource: "emoticons.plist", ofType: nil),
            let array = NSArray(contentsOfFile: plistPath) as? [[String: String]],
            let list = NSArray.yy_modelArray(with: CZEmoticonPackage.self, json: array) as? [CZEmoticonPackage]
        else {
            return
        }
        
        //
        packages += list
    }
}

//
extension CZEmoticonManager {
    //
    func findEmoticon(string: String) -> CZEmoticon? {
        //
        for p in packages {
            // 1
            //let result = p.emoticons.filter({ (em) -> Bool in
            //    return em.chs == string
            //})
            
            // 2
            //let result = p.emoticons.filter() { (em) -> Bool in
            //    return em.chs == string
            //}
            
            // 3
            //let result = p.emoticons.filter() {
            //    return $0.chs == string
            //}
            
            // 4
            let result = p.emoticons.filter() { $0.chs == string }
            
            //
            if result.count == 1 {
                return result[0]
            }
        }
        
        return nil
    }
    
    //
    func recentEmoticon(em: CZEmoticon) {
        //
        em.times += 1
        
        //
        if !packages[0].emoticons.contains(em) {
            packages[0].emoticons.append(em)
        }
        
        //
        /*
        packages[0].emoticons.sort { (em1, em2) -> Bool in
            return em1.times > em2.times
        }
        */
        
        packages[0].emoticons.sort { return $0.times > $1.times }
        
        if packages[0].emoticons.count > 20 {
            let range = 20..<packages[0].emoticons.count
            packages[0].emoticons.removeSubrange(range)
        }
    }
}

//
extension CZEmoticonManager {
    // 哈哈 [我爱你] 哈哈 [笑哈哈]，呵呵 [马上有对象] 呵呵
    func imageTextString(string: String, font: UIFont) -> NSAttributedString {
        //
        let attrString = NSMutableAttributedString(string: string)
        
        //
        let pattern = "\\[.*?\\]"
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []) else {
            return attrString
        }
        
        let matches = regx.matches(in: attrString.string, options: [], range: NSMakeRange(0, attrString.length))
        for m in matches.reversed() {
            //
            let range = m.range(at: 0)
            let subStr = (attrString.string as NSString).substring(with: range)
            if let emoticon = findEmoticon(string: subStr) {
                let imageAttrString = emoticon.imageAttrString(font: font)
                attrString.replaceCharacters(in: range, with: imageAttrString)
            }
        }
        
        //
        attrString.addAttributes([NSAttributedStringKey.font: font],
                                 range: NSMakeRange(0, attrString.length))
        
        //
        return attrString
    }
}











