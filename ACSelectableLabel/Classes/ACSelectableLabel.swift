//
//  ACSelectableLabel.swift
//  CopyLabel
//
//  Created by Antoine Cointepas on 13/03/2017.
//  Copyright © 2017 Antoine Cointepas. All rights reserved.
//

import UIKit

public class ACSelectableLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        attachTapHandler()
    }
    
    func attachTapHandler() {
        self.isUserInteractionEnabled = true
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        self.addGestureRecognizer(gestureRecognizer)
    }
    
    override public var canBecomeFirstResponder: Bool {
        return true
    }
    
    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return action == #selector(UIResponderStandardEditActions.copy(_:)) || action == #selector(inventory(_:))
    }
    
    override public func copy(_ sender: Any?) {
        UIPasteboard.general.string = text
    }
    
    func inventory(_ sender: Any?) {
        UIPasteboard.general.string = text
    }
    
    func handleTap(recognizer: UIGestureRecognizer) {
        if recognizer.state == .recognized {
            if let recognizerView = recognizer.view, let recognizerSuperView = recognizerView.superview, recognizerView.becomeFirstResponder()
            {
                self.becomeFirstResponder()
                let menu = UIMenuController.shared
                let inventoryMenuItem = UIMenuItem(title: "Inventory Lookup", action: #selector(inventory(_:)))
                
                menu.menuItems = [inventoryMenuItem]
                menu.setTargetRect(recognizerView.frame, in: recognizerSuperView)
                menu.setMenuVisible(true, animated: true)
                
                let stringMutable = NSMutableAttributedString(string: text!)
                stringMutable.addAttribute(NSBackgroundColorAttributeName, value: UIColor.lightGray, range: .init(location: 0, length: stringMutable.length))
                attributedText = stringMutable;
            }
        }
    }
    
}
