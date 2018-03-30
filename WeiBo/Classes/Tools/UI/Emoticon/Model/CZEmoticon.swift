//
//  CZEmoticon.swift
//  WeiBo
//
//  Created by 八月夏木 on 2018/3/12.
//  Copyright © 2018年 八月夏木. All rights reserved.
//

import UIKit

class CZEmoticon: NSObject {
    //
    @objc var type = false
    
    //
    @objc var chs: String?
    @objc var png: String?
    
    //
    @objc var code: String? {
        didSet {
            guard let code = code else { return }
            
            let scanner = Scanner(string: code)
            
            var result: UInt32 = 0
            scanner.scanHexInt32(&result)
            
            emoji = String(Character(UnicodeScalar(result)!))
        }
    }
    
    //
    @objc var emoji: String?
    
    //
    @objc var times: Int = 0
    
    //
    @objc var directory: String?
    
    //
    var image: UIImage? {
        //
        if type {
            return nil
        }
        
        //
        guard let directory = directory,
            let png = png,
            let path = Bundle.main.path(forResource: "HMEmoticon.bundle", ofType: nil),
            let bundle = Bundle(path: path)
        else {
            return nil
        }
        
        return UIImage(named: "\(directory)/\(png)", in: bundle, compatibleWith: nil)
    }
    
    //
    func imageAttrString(font: UIFont) -> NSAttributedString {
        //
        guard let image = image else {
            return NSAttributedString(string: "")
        }
        
        let attachment = CZEmoticonAttachment()
        attachment.image = image
        attachment.chs = chs
        
        let height = font.lineHeight
        attachment.bounds = CGRect(x: 0, y: -4, width: height, height: height)
        
        // 文本框中每一个字符字体大小根据前一个字符字体大小而定，所以要增加字体属性，否则会变成12
        let attrStrM = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachment))
        attrStrM.addAttribute(NSAttributedStringKey.font, value: font, range: NSMakeRange(0, 1))
        
        return attrStrM
    }
    
    //
    override var description: String {
        return yy_modelDescription()
    }
}




