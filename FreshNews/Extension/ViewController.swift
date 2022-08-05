//
//  ViewController.swift
//  FreshNews
//
//  Created by Rafayel Aghayan  on 04.08.22.
//

import UIKit
import Foundation

extension UIViewController {
    
    var topbarHeight: CGFloat {
       return UIApplication.shared.statusBarFrame.height + 44
    }
    
    func getSafeAreaHeight(top: Bool) -> CGFloat {
        if let window = UIApplication.shared.windows.first {
            if top {
                return window.safeAreaInsets.top
            } else {
                return window.safeAreaInsets.bottom
            }
        } else {
            return 0
        }
    }
}
