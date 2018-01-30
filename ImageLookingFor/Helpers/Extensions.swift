//
//  Extensions.swift
//  ImageLookingFor
//
//  Created by Alexander Kolovatov on 06.01.18.
//  Copyright © 2018 Alexander Kolovatov. All rights reserved.
//

import UIKit

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String:UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

extension UIColor {
    struct RedTheme {
        static var scarlet: UIColor { return UIColor(displayP3Red: 230/255, green: 32/255, blue: 32/255, alpha: 1) }
        static var darkish: UIColor { return UIColor(displayP3Red: 194/255, green: 31/255, blue: 31/255, alpha: 1) }
    }
}
