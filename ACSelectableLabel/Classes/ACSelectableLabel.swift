//
//  ACSelectableLabel.swift
//  CopyLabel
//
//  Created by Antoine Cointepas on 13/03/2017.
//  Copyright © 2017 Antoine Cointepas. All rights reserved.
//

import AudioToolbox
import UIKit

public protocol ACSelectableLabelDelegate: class {
    func tapOnCopy(sender: ACSelectableLabel)
    func tapOnLink(sender: ACSelectableLabel)
}

public class ACSelectableLabel: UILabel {
    
    public weak var delegate: ACSelectableLabelDelegate?
    public var enabledCopy : Bool = true
    public var enabledLink : Bool = false
    public var debugForce : Bool = false
    public var minimumPressDuration = 1.0
    public var minimumPressForce : CGFloat = 0.7
    
    var menuDisplayed = false
    var gestureRecognizer: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
    var authorizeMenuItem : [UIMenuItem] = []
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        attachTapHandler()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attachTapHandler()
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
        clearObserver()
        
        self.isUserInteractionEnabled = true
        gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        gestureRecognizer.minimumPressDuration = 1.0
        self.addGestureRecognizer(gestureRecognizer)
        NotificationCenter.default.addObserver(self, selector: #selector(willHideMenu), name: NSNotification.Name.UIMenuControllerWillHideMenu, object: nil)
    }
    
    deinit {
        clearObserver()
        delegate = nil
    }
    
    func clearObserver() {
        NotificationCenter.default.removeObserver(self)
        self.removeGestureRecognizer(gestureRecognizer)
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
    
    @objc func tapOnLinkItem(_ sender: Any?) {
        UIPasteboard.general.string = text
        delegate?.tapOnLink(sender: self)
    }
    
    @objc func handleTap(recognizer: UIGestureRecognizer) {
        if recognizer.state == .began {
            if let recognizerView = recognizer.view, recognizerView.becomeFirstResponder()
            {
                launchMenuController()
            }
        }
    }
    
    private func launchMenuController() {
        if !menuDisplayed {
            
            if #available(iOS 10.0, *) {
                if let value = UIDevice.current.value(forKey: "_feedbackSupportLevel") as? Int, value == 2 {
                    let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
                    feedbackGenerator.prepare()
                    feedbackGenerator.impactOccurred()
                } else {
                    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
                }
            } else {
                AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
            }
            
            menuDisplayed = true
            self.becomeFirstResponder()
            let menu = UIMenuController.shared
            
            menu.menuItems = authorizeMenuItem
            menu.setTargetRect(frame, in: superview!)
            menu.setMenuVisible(true, animated: true)
            
            let stringMutable = NSMutableAttributedString(string: text!)
            stringMutable.addAttribute(NSAttributedStringKey.backgroundColor, value: UIColor.lightGray.withAlphaComponent(0.5), range: .init(location: 0, length: stringMutable.length))
            attributedText = stringMutable;
        }
    }
    
    @objc func willHideMenu() {
        self.text = text
        menuDisplayed = false
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if #available(iOS 9.0, *) {
                if traitCollection.forceTouchCapability == .available {
                    let force = touch.force/touch.maximumPossibleForce
                    if force >= minimumPressForce {
                        launchMenuController()
                    }
                    
                    if debugForce {
                        let stringMutable = NSMutableAttributedString(string: "\(force)% force")
                        stringMutable.addAttribute(NSAttributedStringKey.backgroundColor, value: UIColor.lightGray.withAlphaComponent(0.5), range: .init(location: 0, length: stringMutable.length))
                        attributedText = stringMutable;
                    }
                }
            }
        }
    }
    
}
