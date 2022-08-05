//
//  PopUpMsgManager.swift
//  FreshNews
//
//  Created by Rafayel Aghayan  on 05.08.22.
//

import UIKit
import Foundation

final class PopUpMsgManager: UIResponder {
    
    static let shared = PopUpMsgManager()
    
    private var isHidingBanner:Bool = false
    private var secondsRemaining = 3
    private var bannerView: UIView!
    private var msgLbl: UILabel!
    private var originY: CGFloat!
    
    public func addMsg(text: String, originY: CGFloat) {
        self.originY = originY
        self.showPopUp(text: text)
    }
    
    public func updateFrame(originY: CGFloat) {
        
        if !self.isHidingBanner && self.bannerView != nil {
            self.originY = originY
            UIView.animate(withDuration: 0.3) {
                self.bannerView.frame = CGRect(x: self.bannerView.frame.origin.x, y: self.originY - (self.bannerView.frame.height + 10), width: self.bannerView.frame.width, height: self.bannerView.frame.height)
            }
        }
    }
    
    @objc private func showPopUp(text: String) {
        
        if !isHidingBanner {
            self.secondsRemaining = 3
            
            if bannerView == nil {
                self.creatBannerView(text: text)
            } else{
                self.setValues(text: text)
            }
        } else {
            self.perform(#selector(self.showPopUp), with: text, afterDelay: 0.3)
        }
    }
    
    private func creatBannerView(text: String) {

        let window = UIApplication.shared.windows.first!
        let font = UIFont.systemFont(ofSize: 16)
        let height = text.height(withConstrainedWidth: window.frame.width - 42, font: font)
        
        bannerView = UIView(frame: CGRect(x: 16, y: window.frame.height, width: window.frame.width - 32, height: height + 20))
        bannerView.backgroundColor = .black
        bannerView.layer.shadowOpacity = 1
        bannerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        bannerView.layer.shadowRadius = 3
        bannerView.layer.shadowColor = UIColor.black.cgColor
        bannerView.layer.cornerRadius = 10

        msgLbl = UILabel(frame: CGRect(x: 5, y: 0, width: bannerView.frame.width - 10, height: bannerView.frame.height))
        msgLbl.textColor = .white
        msgLbl.font = font
        msgLbl.textAlignment = .center
        msgLbl.numberOfLines = 0
        bannerView.addSubview(msgLbl)
        
        window.addSubview(bannerView)

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTappedOnBannerAction))
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.didSwipedAction))
        swipeRecognizer.direction = .down
        bannerView.addGestureRecognizer(tapRecognizer)
        bannerView.addGestureRecognizer(swipeRecognizer)
        
        self.counterForDismiss()
        self.setValues(text: text)
    }
    
    
    
    @objc private func didTappedOnBannerAction(sender: UITapGestureRecognizer) {
        self.hideNotification()
    }
    
    @objc private func didSwipedAction(sender: UISwipeGestureRecognizer) {
        self.hideNotification()
    }
    
    @objc private func counterForDismiss() {
        if self.secondsRemaining > 0 {
            self.secondsRemaining -= 1
            self.perform(#selector(self.counterForDismiss), with: nil, afterDelay: 1)
        } else {
            self.hideNotification()
        }
    }
    
    private func setValues(text: String) {
        
        if !isHidingBanner {
            let window = UIApplication.shared.windows.first!
            let font = UIFont.systemFont(ofSize: 16)
            let height = text.height(withConstrainedWidth: window.frame.width - 42, font: font)
            
            msgLbl.text = text
            UIView.animate(withDuration: 0.3) {
                self.bannerView.frame = CGRect(x: self.bannerView.frame.origin.x, y: self.originY - (height + 30), width: self.bannerView.frame.width, height: height + 20)
            }
        }
    }
    
    public func hideNotification() {
        if bannerView != nil && !isHidingBanner {
            self.isHidingBanner = true
            UIView.animate(withDuration: 0.2) {
                self.bannerView.frame = CGRect(x: self.bannerView.frame.origin.x, y: self.bannerView.superview!.frame.height, width: self.bannerView.frame.width, height: self.bannerView.frame.height)
            } completion: { _ in
                if self.bannerView != nil {
                    self.bannerView.removeFromSuperview()
                    self.invalidateVariables()
                } else {
                    self.isHidingBanner = false
                }
            }
        }
    }
    
    private func invalidateVariables() {
        self.bannerView = nil
        self.msgLbl = nil
        self.secondsRemaining = 3
        self.isHidingBanner = false
    }
}

