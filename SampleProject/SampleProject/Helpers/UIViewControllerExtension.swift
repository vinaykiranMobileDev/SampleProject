//
//  UIViewController+Extension.swift
//  SampleProject
//
//  Created by VinayKiran M on 28/10/20.
//

import Foundation
import UIKit

extension UIViewController {

    /**
     *  Height of status bar + navigation bar (if navigation bar exist)
     */

    var topbarHeight: CGFloat {
        let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0
        let navBarHeight = self.navigationController?.navigationBar.frame.height ?? 0.0
        return statusBarHeight + navBarHeight
    }
}
