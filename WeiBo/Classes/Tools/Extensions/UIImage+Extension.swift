//
//  UIImage+Extension.swift
//  WeiBo
//
//  Created by 八月夏木 on 2018/2/15.
//  Copyright © 2018年 八月夏木. All rights reserved.
//

import Foundation

extension UIImage {
    //
    func cz_avatarImage(size: CGSize?, backColor: UIColor? = UIColor.white, linkColor: UIColor? = UIColor.lightGray) -> UIImage? {
        //
        var size = size
        if size == nil {
            size = self.size
        }
        
        let rect = CGRect(origin: CGPoint(), size: size!)
        
        //
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
        
        //
        backColor?.setFill()
        UIRectFill(rect)
        
        //
        let path = UIBezierPath(ovalIn: rect)
        path.addClip()
        
        //
        draw(in: rect)
        
        //
        let ovalPath = UIBezierPath(ovalIn: rect)
        ovalPath.lineWidth = 2
        linkColor?.setStroke()
        ovalPath.stroke()
  
        //
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        //
        UIGraphicsEndImageContext()
        
        return image
    }
}
