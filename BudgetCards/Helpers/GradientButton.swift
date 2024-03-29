//
//  GradientButton.swift
//  BudgetCards
//
//  Created by Sekhar Simhadri on 09/10/19.
//  Copyright © 2019 Sekhar Simhadri. All rights reserved.
//

import UIKit

class GradientButton: UIButton {
    override func awakeFromNib() {
        
        layoutIfNeeded()
        
        let gradientBorder = CAGradientLayer()
        gradientBorder.frame =      bounds
        //Set gradient to be horizontal
        gradientBorder.startPoint = CGPoint(x: 0, y: 0.5)
        gradientBorder.endPoint =   CGPoint(x: 1, y: 0.5)
        gradientBorder.colors =    [UIColor.red.cgColor, UIColor.green.cgColor,UIColor.blue.cgColor]
        
        let shape = CAShapeLayer()
        shape.lineWidth =     2
        shape.path =          UIBezierPath(rect: bounds).cgPath
        shape.strokeColor =   UIColor.black.cgColor
        shape.fillColor =     UIColor.clear.cgColor
        gradientBorder.mask = shape
        
        layer.addSublayer(gradientBorder)
        
        let gradient =        CAGradientLayer()
        gradient.frame =      bounds
        //Set gradient to be horizontal
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint =   CGPoint(x: 1, y: 0.5)
        gradient.colors =     [UIColor.red.cgColor, UIColor.green.cgColor,UIColor.blue.cgColor]
        
        layer.insertSublayer(gradient, at: 0)
        
        let overlayView = UIView(frame: bounds)
        overlayView.isUserInteractionEnabled = false
        overlayView.layer.insertSublayer(gradient, at: 0)
        overlayView.mask = titleLabel
        
        addSubview(overlayView)
    }
}
