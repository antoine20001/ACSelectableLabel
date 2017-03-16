//
//  ACSelectableLabel.swift
//  CopyLabel
//
//  Created by Antoine Cointepas on 13/03/2017.
//  Copyright © 2017 Antoine Cointepas. All rights reserved.
//

import UIKit

public protocol ACSelectableLabelDelegate: class {
    func tapOnCopy(sender: ACSelectableLabel)
    func tapOnLink(sender: ACSelectableLabel)
}

public class ACSelectableLabel: UILabel {
    
    public weak var delegate: ACSelectableLabelDelegate?
    var gestureRecognizer: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
    var authorizeMenuItem : [UIMenuItem] = []
    var enabledCopy : Bool = true
    var enabledLink : Bool = false
    var target : UIViewController?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        attachTapHandler()
    }
    
    public func addLinkItemWith(title: String?) {
        guard let title = title else {
            enabledLink = false
            authorizeMenuItem = []
            return
        }
        
        enabledLink = true
        let customMenuItem = UIMenuItem(title: title, action: #selector(tapOnLinkItem(_:)))
        authorizeMenuItem = [customMenuItem]
    }
    
    func attachTapHandler() {
        self.isUserInteractionEnabled = true
        
        gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        self.addGestureRecognizer(gestureRecognizer)
        NotificationCenter.default.addObserver(self, selector: #selector(willHideMenu), name: NSNotification.Name.UIMenuControllerWillHideMenu, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        self.removeGestureRecognizer(gestureRecognizer)
        delegate = nil
    }
    
    override public var canBecomeFirstResponder: Bool {
        return true
    }
    
    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        if enabledLink && action == #selector(tapOnLinkItem(_:)) {
            return true
        }
        
        return enabledCopy && action == #selector(UIResponderStandardEditActions.copy(_:))
    }
    
    override public func copy(_ sender: Any?) {
        UIPasteboard.general.string = text
        delegate?.tapOnCopy(sender: self)
    }
    
    func tapOnLinkItem(_ sender: Any?) {
        UIPasteboard.general.string = text
        delegate?.tapOnLink(sender: self)
    }
    
    func handleTap(recognizer: UIGestureRecognizer) {
        if recognizer.state == .recognized {
            if let recognizerView = recognizer.view, let recognizerSuperView = recognizerView.superview, recognizerView.becomeFirstResponder()
            {
                launchMenuController()
            }
        }
    }
    
    private func launchMenuController() {
        self.becomeFirstResponder()
        let menu = UIMenuController.shared
        
        menu.menuItems = authorizeMenuItem
        menu.setTargetRect(frame, in: superview!)
        menu.setMenuVisible(true, animated: true)
        
        let stringMutable = NSMutableAttributedString(string: text!)
        stringMutable.addAttribute(NSBackgroundColorAttributeName, value: UIColor.lightGray.withAlphaComponent(0.5), range: .init(location: 0, length: stringMutable.length))
        attributedText = stringMutable;
    }
    
    func willHideMenu() {
        self.text = text
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if #available(iOS 9.0, *) {
                if traitCollection.forceTouchCapability == .available {
                    let force = touch.force/touch.maximumPossibleForce
                    if force >= 50 {
                        launchMenuController()
                    }
                    self.text = "\(force)% force"
                }
            }
        }
    }
    
    
}
