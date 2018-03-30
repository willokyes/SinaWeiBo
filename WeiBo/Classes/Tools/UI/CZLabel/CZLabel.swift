//
//  CZLabel.swift
//  WeiBo
//
//  Created by 八月夏木 on 2018/3/14.
//  Copyright © 2018年 八月夏木. All rights reserved.
//

import UIKit

@objc protocol CZLabelDelegate: NSObjectProtocol {
    @objc optional func labelDidSelectedLinkText(label: CZLabel, text: String)
}

class CZLabel: UILabel {
    //
    public weak var delegate: CZLabelDelegate?
    
    //
    private lazy var textStorage = NSTextStorage()
    private lazy var layoutManager = NSLayoutManager()
    private lazy var textContainer = NSTextContainer()
    
    //
    private lazy var linkRanges = [NSRange]()
    private var selectedRange: NSRange?
    
    private let patterns = ["[a-zA-Z]*://[a-zA-Z0-9/\\.]*", "#.*?#", "@[\\u4e00-\\u9fa5a-zA-Z0-9_-]*"]

    //
    public var linkTextColor = UIColor.blue
    public var selectedBackgroundColor = UIColor.lightGray
    
    //
    override var text: String? {
        didSet {
            //
            updateTextStorage()
        }
    }
    
    //
    override var attributedText: NSAttributedString? {
        didSet {
            //
            updateTextStorage()
        }
    }
    
    //
    override var font: UIFont! {
        didSet {
            //
            updateTextStorage()
        }
    }
    
    //
    override var textColor: UIColor! {
        didSet {
            //
            updateTextStorage()
        }
    }
    
    //
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //
        textContainer.size = bounds.size
    }
    
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //
        prepareForLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //
        prepareForLabel()
    }
    
    //
    override func drawText(in rect: CGRect) {
        //
        let range = NSMakeRange(0, textStorage.length)
        
        //
        layoutManager.drawBackground(forGlyphRange: range, at: CGPoint(x: 0, y: 0))
        layoutManager.drawGlyphs(forGlyphRange: range, at: CGPoint(x: 0, y: 0))
    }
}

///
private extension CZLabel {
    //
    private func prepareForLabel() {
        //
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
        
        // FIXME: lineFragmentPadding
        textContainer.lineFragmentPadding = 0
        
        //
        isUserInteractionEnabled = true
    }
    
    //
    private func updateTextStorage() {
        //
        guard let attrString = attributedText else {
            return
        }
        
        let attrStringM = NSMutableAttributedString(attributedString: attrString)
        
        //
        setLineBreakMode(attrStringM)
        
        //
        regxLinkRanges(attrStringM)
        
        //
        addLinkAttributes(attrStringM)
        
        //
        textStorage.setAttributedString(attrStringM)
        
        //
        setNeedsDisplay()
    }
    
    private func setLineBreakMode(_ attrStringM: NSMutableAttributedString) {
        //
        if attrStringM.length == 0 {
            return
        }
        
        //
        var range = NSRange(location: 0, length: 0)
        var attributes = attrStringM.attributes(at: 0, effectiveRange: &range)
        
        if let paragraphStyle = attributes[NSAttributedStringKey.paragraphStyle] as? NSMutableParagraphStyle {
            paragraphStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
        } else {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
            
            attributes[NSAttributedStringKey.paragraphStyle] = paragraphStyle
            attrStringM.setAttributes(attributes, range: range)
        }
    }
    
    //
    private func addLinkAttributes(_ attrStringM: NSMutableAttributedString) {
        //
        var attributes = attrStringM.attributes(at: 0, effectiveRange: nil)
        attributes[.font] = font
        attributes[.foregroundColor] = textColor
        
        let range = NSMakeRange(0, attrStringM.length)
        
        attrStringM.enumerateAttributes(in: range, options: []) { (dict, r, _) in
            //
            if dict[.attachment] != nil {
                return
            }
            
            attrStringM.setAttributes(attributes, range: r)
        }
        
        //
        attributes[.foregroundColor] = linkTextColor
        
        //
        for r in linkRanges {
            attrStringM.setAttributes(attributes, range: r)
        }
    }
}

///
private extension CZLabel {
    //
    private func regxLinkRanges(_ attrString: NSAttributedString) {
        //
        linkRanges.removeAll()
        
        //
        let range = NSMakeRange(0, attrString.length)
        
        for pattern in patterns {
            //
            guard let regx = try? NSRegularExpression(pattern: pattern, options: []) else {
                continue
            }
            
            //
            let results = regx.matches(in: attrString.string, options: [], range: range)
            
            for r in results {
                //
                linkRanges.append(r.range(at: 0))
            }
        }
    }
}

///
extension CZLabel {
    //
    private func linkRangeAtLocation(_ location: CGPoint) -> NSRange? {
        //
        let idx = layoutManager.glyphIndex(for: location, in: textContainer)

        for r in linkRanges {
            if NSLocationInRange(idx, r) {
                return r
            }
        }
        
        return nil
    }
    
    //
    private func modifySelectedAttribute(_ isSet: Bool) {
        //
        guard let range = selectedRange else { return }

        //
        var attributes = [NSAttributedStringKey: AnyObject]()
        
        if isSet {
            attributes[NSAttributedStringKey.backgroundColor] = selectedBackgroundColor
        } else {
            attributes[NSAttributedStringKey.backgroundColor] = UIColor.clear
            selectedRange = nil
        }
        
        textStorage.addAttributes(attributes, range: range)

        //
        setNeedsDisplay()
    }
    
    //
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //
        guard let location = touches.first?.location(in: self) else { return }
        
        //
        selectedRange = linkRangeAtLocation(location)
        
        //
        modifySelectedAttribute(true)
    }
    
    //
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //
        guard let range = selectedRange else { return }
        
        //
        let text = (textStorage.string as NSString).substring(with: range)
        delegate?.labelDidSelectedLinkText?(label: self, text: text)
        
        //
        let when = DispatchTime.now() + 0.25
        DispatchQueue.main.asyncAfter(deadline: when) {
            //
            self.modifySelectedAttribute(false)
        }
    }
    
    //
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //
        guard let location = touches.first?.location(in: self) else {
                return
        }
        
        //
        if let range = linkRangeAtLocation(location) {
            if range != selectedRange {
                modifySelectedAttribute(false)
                selectedRange = range
                modifySelectedAttribute(true)
            }
        } else {
            modifySelectedAttribute(false)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        modifySelectedAttribute(false)
    }
    
}


















