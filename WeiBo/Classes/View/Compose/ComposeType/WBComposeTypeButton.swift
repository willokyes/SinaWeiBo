//
//  WBComposeTypeButton.swift
//  WeiBo
//
//  Created by 八月夏木 on 2018/3/5.
//  Copyright © 2018年 八月夏木. All rights reserved.
//

import UIKit

class WBComposeTypeButton: UIControl {
    //
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var clsName: String?
    
    //
    class func composeTypeButton(imageName: String, title: String) -> WBComposeTypeButton {
        //
        let nib = UINib(nibName: "WBComposeTypeButton", bundle: nil)
        let btn = nib.instantiate(withOwner: nil, options: nil)[0] as! WBComposeTypeButton
        
        btn.imageView.image = UIImage(named: imageName)
        btn.titleLabel.text = title
        
        return btn
    }
    
}
