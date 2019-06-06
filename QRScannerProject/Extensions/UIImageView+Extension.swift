//
//  UIImageView+Extension.swift
//  Halalefi
//
//  Created by AsifNewaz on 5/9/19.
//  Copyright © 2019 AsifNewaz. All rights reserved.
//

import UIKit


import UIKit

extension UIImageView {
    
    func makeRounded() {
        let radius = self.frame.width/2.0
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    public func maskCircle(anyImage: UIImage, borderColor: String = "dddddd", borderWidth: CGFloat = 2) {
        self.contentMode = UIView.ContentMode.scaleAspectFill
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.colorFrom(hexString: borderColor)?.cgColor
        self.layer.borderWidth = borderWidth
        self.image = anyImage
    }
}

extension UIImageView {
    var GGImageShape : UIImageView{
        
        var topLeftCornerRadius:CGFloat     = 0
        var topRightCornerRadius:CGFloat    = 0
        var bottomLeftCornerRadius:CGFloat  = 0
        var bottomRightCornerRadius:CGFloat = 0
        topLeftCornerRadius     = self.frame.size.width * 0.36
        topRightCornerRadius    = 0
        bottomLeftCornerRadius  = self.frame.size.width * 0.27
        bottomRightCornerRadius = self.frame.size.width * 0.27
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: self.frame.size.width, y: topRightCornerRadius))
        path.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height - bottomRightCornerRadius))
        
        let centerBottomRight = CGPoint(x: self.frame.size.width - bottomRightCornerRadius, y: self.frame.size.height - bottomRightCornerRadius)
        
        path.addArc(withCenter: centerBottomRight, radius: bottomRightCornerRadius, startAngle: CGFloat(0), endAngle: CGFloat(M_PI_2), clockwise: true)
        
        path.addLine(to: CGPoint(x: bottomLeftCornerRadius, y: self.frame.size.height))
        
        
        let centerBottomLeft = CGPoint(x:bottomLeftCornerRadius, y: self.frame.size.height - bottomLeftCornerRadius)
        
        path.addArc(withCenter: centerBottomLeft, radius: bottomLeftCornerRadius, startAngle: CGFloat(M_PI_2), endAngle: CGFloat(M_PI), clockwise: true)
        
        path.addLine(to: CGPoint(x: 0, y: topLeftCornerRadius))
        
        let centerTopLeft = CGPoint(x:topLeftCornerRadius, y: topLeftCornerRadius)
        
        path.addArc(withCenter: centerTopLeft, radius: topLeftCornerRadius, startAngle: CGFloat(M_PI), endAngle: CGFloat(3*M_PI_2), clockwise: true)
        
        
        path.addLine(to: CGPoint(x: self.frame.size.width - topRightCornerRadius, y: 0))
        
        
        let centerTopRight = CGPoint(x: self.frame.size.width - topRightCornerRadius, y: topRightCornerRadius)
        
        path.addArc(withCenter: centerTopRight, radius: topRightCornerRadius, startAngle: CGFloat(3*M_PI_2), endAngle: CGFloat(0), clockwise: true)
        
        path.close()
        let customMask = CAShapeLayer()
        customMask.path = path.cgPath
        self.layer.mask = customMask
        return self
    }
    
}
