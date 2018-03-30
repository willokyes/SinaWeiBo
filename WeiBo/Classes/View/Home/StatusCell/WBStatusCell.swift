//
//  WBStatusCell.swift
//  WeiBo
//
//  Created by 八月夏木 on 2018/2/14.
//  Copyright © 2018年 八月夏木. All rights reserved.
//

import UIKit

@objc protocol WBStatusCellDelegate: NSObjectProtocol {
    //
    @objc optional func statusCellDidSelectedLinkText(statusCell: WBStatusCell, linkText: String)
}

class WBStatusCell: UITableViewCell {
    //
    weak var delegate: WBStatusCellDelegate?
    
    //
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var memberIconView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var vipIconView: UIImageView!
    @IBOutlet weak var statusLabel: CZLabel!
    @IBOutlet weak var statusToolBar: WBStatusToolBar!
    @IBOutlet weak var pictureView: WBStatusPictureView!
    @IBOutlet weak var retweetedLabel: CZLabel?
    
    var viewModel: WBStatusViewModel? {
        didSet {
            statusLabel?.attributedText = viewModel?.statusAttrText
            nameLabel.text = viewModel?.status.user?.screen_name
            memberIconView.image = viewModel?.memberIcon
            vipIconView.image = viewModel?.vipIcon
            iconView.cz_setImage(urlString: viewModel?.status.user?.profile_image_url,
                                 placeholderImage: UIImage(named: "avatar_default_big"), isAvatar: true)
            
            //
            statusToolBar.viewModel = viewModel
            
            //
            pictureView.viewModel = viewModel
            
            //
            retweetedLabel?.attributedText = viewModel?.retweetedAttrText
            
            //
            sourceLabel.text = viewModel?.status.source
            
            //
            timeLabel.text = viewModel?.status.createdDate?.cz_dateDescription
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        //
        self.layer.drawsAsynchronously = true
        
        //
        self.layer.shouldRasterize = true
        
        //
        self.layer.rasterizationScale = UIScreen.cz_scale()
        
        //
        statusLabel.delegate = self
        retweetedLabel?.delegate = self
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        //
        pictureView.resetImageViews()
    }

}

extension WBStatusCell: CZLabelDelegate {
    //
    func labelDidSelectedLinkText(label: CZLabel, text: String) {
        //
        Print(self, text)
        
        //
        if !text.hasPrefix("http://") {
            return
        }
        
        //
        delegate?.statusCellDidSelectedLinkText?(statusCell: self, linkText: text)
    }
}
















