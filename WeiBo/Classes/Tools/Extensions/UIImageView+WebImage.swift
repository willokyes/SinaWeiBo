//
//  UIImageView+WebImage.swift
//  WeiBo
//
//  Created by 八月夏木 on 2018/2/15.
//  Copyright © 2018年 八月夏木. All rights reserved.
//

import Foundation

extension UIImageView {
    //
    func cz_setImage(urlString: String?, placeholderImage: UIImage?, isAvatar: Bool = false) {
        //
        guard let urlString = urlString, let url = URL(string: urlString) else {
            image = placeholderImage
            return
        }
        
        //
        sd_setImage(with: url, placeholderImage: placeholderImage, options: [], progress: nil) {
            [weak self] (image, _, _, _) in
            //
            if isAvatar {
                self?.image = image?.cz_avatarImage(size: self?.bounds.size)
            }
        }
    }
    
    
    //
    
    
    
    
}
