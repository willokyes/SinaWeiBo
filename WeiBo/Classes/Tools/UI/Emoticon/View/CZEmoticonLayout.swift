//
//  CZEmoticonLayout.swift
//  WeiBo
//
//  Created by 八月夏木 on 2018/3/23.
//  Copyright © 2018年 八月夏木. All rights reserved.
//

import UIKit

class CZEmoticonLayout: UICollectionViewFlowLayout {
    //
    override func prepare() {
        super.prepare()
        
        //
        scrollDirection = .horizontal
        
        //
        guard let collectionView = collectionView else {
            return
        }
        
        itemSize = collectionView.bounds.size
        
        
        
    }
}














