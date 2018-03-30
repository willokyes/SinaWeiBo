//
//  WBComposeViewController.swift
//  WeiBo
//
//  Created by 八月夏木 on 2018/3/9.
//  Copyright © 2018年 八月夏木. All rights reserved.
//

import UIKit
import SVProgressHUD

class WBComposeViewController: UIViewController {
    //
    @IBOutlet weak var textView: WBComposeTextView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var toolbarBottomCons: NSLayoutConstraint!
    
    //
    lazy var emoticonView: CZEmoticonInputView = CZEmoticonInputView.inputView { [weak self] (emoticon) in
        //
        self?.textView.insertEmoticon(em: emoticon)
    }
    
    //
    lazy var sendButtonX: UIButton = {
        //
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 45, height: 35))
        
        btn.setTitle("发布", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        btn.setTitleColor(.white, for: .normal)
        btn.setTitleColor(.gray, for: .disabled)
        
        btn.setBackgroundImage(#imageLiteral(resourceName: "common_button_orange"), for: .normal)
        btn.setBackgroundImage(#imageLiteral(resourceName: "common_button_orange_highlighted"), for: .highlighted)
        btn.setBackgroundImage(#imageLiteral(resourceName: "common_button_white_disable"), for: .disabled)
        
        return btn
    }()
    
    //
    override func viewDidLoad() {
        super.viewDidLoad()

        //
        setupUI()
        
        //
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChange),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                               object: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //
        textView.becomeFirstResponder()
    }
    
    //
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //
        textView.resignFirstResponder()
    }
    
    //
    @objc func keyboardWillChange(n: Notification) {
        //
        //Print(self, n.userInfo)
        
        //
        guard let rect = (n.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
              let duration = (n.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
            else {
            return
        }
        
        let offset = view.bounds.height - rect.origin.y
        
        toolbarBottomCons.constant = offset
        
        //
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    //
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
    //
    @IBAction func postStatus(_ sender: Any) {
        Print(self, "撰写微博")
        
        var text = textView.emoticonText()
        
        //
        //guard var text = textView.text else { return }
        
        text += " http://163.com"
        
        var image = UIImage(named: "360")
        image = nil
        
        WBNetworkManager.shared.postStatus(text: text, image: image) { (dict, isSuccess) in
            //Print(self, dict)
            
            let message = isSuccess ? "发布成功" : "发布失败"
            
            SVProgressHUD.setDefaultStyle(.dark)
            SVProgressHUD.showInfo(withStatus: message)
            
            if isSuccess {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                    SVProgressHUD.setDefaultStyle(.light)
                    self.close()
                })
            }

        }
    }
    
    //
    @objc private func emoticonKeyboard() {
        //
        if textView.inputView == nil {
            emoticonView.frame.size.height = toolbarBottomCons.constant
            textView.inputView = emoticonView
        }
        
        //
        textView.reloadInputViews()
    
    }
}

///
extension WBComposeViewController {
    //
    func setupUI() {
        //
        view.backgroundColor = .white
        
        setupNavigationBar()
        
        setupToolbar()
    }
    
    func setupNavigationBar() {
        //
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", target: self, action: #selector(close))

        //
        navigationItem.titleView = titleLabel
        
        //
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sendButton)
        
        //
        sendButton.isEnabled = false
    }
    
    func setupToolbar() {
        //
        let itemSettings = [["imageName": "compose_toolbar_picture"],
                            ["imageName": "compose_mentionbutton_background"],
                            ["imageName": "compose_trendbutton_background"],
                            ["imageName": "compose_emoticonbutton_background", "actionName": "emoticonKeyboard"],
                            ["imageName": "compose_add_background"]]
        
        var items = [UIBarButtonItem]()
        for s in itemSettings {
            //
            guard let imageName = s["imageName"] else {
                continue
            }
            
            //
            let image = UIImage(named: imageName)
            let imageHL = UIImage(named: imageName + "_highlighted")
            
            let btn = UIButton()
            btn.setImage(image, for: .normal)
            btn.setImage(imageHL, for: .highlighted)
            btn.sizeToFit()
            
            if let actionName = s["actionName"] {
                btn.addTarget(self, action: Selector(actionName), for: .touchUpInside)
            }
            
            items.append(UIBarButtonItem(customView: btn))
            items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        
        items.removeLast()
        
        toolbar.items = items
    }
}

///
extension WBComposeViewController: UITextViewDelegate {
    //
    func textViewDidChange(_ textView: UITextView) {
        sendButton.isEnabled = textView.hasText
    }
}














