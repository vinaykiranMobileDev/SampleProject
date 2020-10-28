//
//  StringExtension.swift
//  SampleProject
//
//  Created by VinayKiran M on 28/10/20.
//

import Foundation
import UIKit

extension String {
    func sizeOfString (_ font: UIFont, constrainedToWidth width: CGFloat,
                       _ options: NSStringDrawingOptions = NSStringDrawingOptions.usesLineFragmentOrigin) -> CGSize {
        return (self as NSString).boundingRect(with: CGSize(width: width,
                                                            height: CGFloat.greatestFiniteMagnitude),
                                               options: options,
                                               attributes: [NSAttributedString.Key.font: font],
                                               context: nil).size
    }
}
