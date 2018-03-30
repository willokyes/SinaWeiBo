//
//  WBStatusToolBar.swift
//  WeiBo
//
//  Created by 八月夏木 on 2018/2/16.
//  Copyright © 2018年 八月夏木. All rights reserved.
//

import UIKit

class WBStatusToolBar: UIView {
    //
    @IBOutlet weak var retweetedButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!

    //
    var viewModel: WBStatusViewModel? {
        didSet {
            retweetedButton.setTitle(viewModel?.retweetedStr ?? "", for: .normal)
            commentButton.setTitle(viewModel?.commentStr ?? "", for: .normal)
            likeButton.setTitle(viewModel?.likeStr ?? "", for: .normal)
        }
    }
}
