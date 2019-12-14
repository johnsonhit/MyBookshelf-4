//
//  IndicatorUtils.swift
//  MyBookshelf
//
//  Created by Jae Kyung Lee on 14/12/2019.
//  Copyright © 2019 Jae Kyung Lee. All rights reserved.
//

import UIKit

class IndicatorUtils {
    
    static let shared = IndicatorUtils()
    
    func createIndicator(style: UIActivityIndicatorView.Style, color: UIColor = .darkGray, frame: CGRect) -> UIActivityIndicatorView {
        let indicatorView = UIActivityIndicatorView(style: style)
        indicatorView.color = .darkGray
        indicatorView.hidesWhenStopped = true
        indicatorView.frame = frame
        indicatorView.alpha = 0.5
        return indicatorView
    }
}
