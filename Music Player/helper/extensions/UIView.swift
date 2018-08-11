//
//  UIView.swift
//  Music Player
//
//  Created by Abdullah Alhaider on 11/08/2018.
//  Copyright © 2018 Sem. All rights reserved.
//

import UIKit

extension UIView {
    
    func anchor(height: CGFloat? = nil,
                width: CGFloat? = nil,
                top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                topConstant: CGFloat = 0,
                leftConstant: CGFloat = 0,
                bottomConstant: CGFloat = 0,
                rightConstant: CGFloat = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        //////
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        //////
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: topConstant).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: leftConstant).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -rightConstant).isActive = true
        }
        
    }
    
   
    
}
