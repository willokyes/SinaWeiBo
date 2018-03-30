//
//  WBComposeTextView.swift
//  WeiBo
//
//  Created by 八月夏木 on 2018/3/21.
//  Copyright © 2018年 八月夏木. All rights reserved.
//

import UIKit

class WBComposeTextView: UITextView {
    //
    private lazy var placeholderLabel = UILabel()
    
    //
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //
        setupUI()
    }
    
    //
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

private extension WBComposeTextView {
    //
    private func setupUI() {
        //
        placeholderLabel.text = "发布新鲜事..."
        placeholderLabel.textColor = .darkGray
        placeholderLabel.font = self.font
        placeholderLabel.sizeToFit()
        
        placeholderLabel.frame.origin = CGPoint(x: 5, y: 8)

        //
        addSubview(placeholderLabel)
        
        //
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
    }
    
    //
    @objc func textDidChange() {        
        placeholderLabel.isHidden = self.hasText
    }
}


///
extension WBComposeTextView {
    //
    func insertEmoticon(em: CZEmoticon?) {
        //
        guard let em = em else {
            deleteBackward()
            return
        }
        
        //
        if let emoji = em.emoji, let textRange = selectedTextRange {
            replace(textRange, withText: emoji)
            return
        }
        
        //
        let imageText = em.imageAttrString(font: font!)
        
        let attrStrM = NSMutableAttributedString(attributedString: attributedText)
        
        let range = selectedRange
        
        attrStrM.replaceCharacters(in: range, with: imageText)
        
        attributedText = attrStrM
        
        selectedRange = NSMakeRange(range.location + 1, 0)
        
        //
        textDidChange()
        
        //
        delegate?.textViewDidChange?(self)
    }
    
    //
    func emoticonText() -> String {
        //
        guard let attrText = attributedText else {
            return ""
        }
        
        //
        var result = String()
        attrText.enumerateAttributes(in: NSMakeRange(0, attrText.length), options: []) { (dict, range, _) in
            //
            Print(self, range)
            
            //
            if let attachment = dict[NSAttributedStringKey.attachment] as? CZEmoticonAttachment {
                //
                result += attachment.chs ?? ""
            } else {
                //
                let subStr = (attrText.string as NSString).substring(with: range)
                result += subStr
            }
        }
        
        return result
    }
}












