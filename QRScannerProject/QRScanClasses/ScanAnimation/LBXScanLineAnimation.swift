//
//  LBXScanLineAnimation.swift
//  swiftScan
//
//  Created by lbxia on 15/12/9.
//  Modified by Asif Newaz on 05/06/19.
//  Copyright © 2015年 xialibing. All rights reserved.
//

import UIKit

class LBXScanLineAnimation: UIImageView {

    var isAnimationing = false
    var isAnimationStartForFirstTime = false
    
    var animationRect: CGRect = CGRect.zero
    var tempAmimationRect: CGRect  = CGRect.zero
    
    func startAnimatingWithRect(animationRect: CGRect, parentView: UIView, image: UIImage?)
    { 
        self.image = image
        self.animationRect = animationRect
        parentView.addSubview(self)
        
        self.isHidden = false;
        
        isAnimationing = true;
        
        if image != nil
        {
            isAnimationStartForFirstTime = true
            stepAnimation()
        }
        
    }
    
    @objc func stepAnimation()
    {
        if (!isAnimationing) {
            return;
        }
        
        if isAnimationStartForFirstTime ==  true {
            var frame:CGRect = animationRect;
            let hImg = self.image!.size.height * animationRect.size.width / self.image!.size.width;
            frame.origin.y -= hImg;
            frame.size.height = hImg;
            self.frame = frame;
            self.alpha = 0.0;
        }
        
        
        UIView.animate(withDuration: 1.5, animations: { () -> Void in
            
            self.alpha = 1.0;
            
            var frame = self.animationRect;
            let hImg = self.image!.size.height * self.animationRect.size.width / self.image!.size.width;
            frame.origin.y += (frame.size.height -  hImg);
            frame.size.height = hImg;
            print(hImg)
            self.frame = frame;
            self.tempAmimationRect = frame
            }, completion:{ (value: Bool) -> Void in
                self.isAnimationStartForFirstTime = false
                self.perform(#selector(LBXScanLineAnimation.stepAnimationReverse), with: nil, afterDelay: 0.0)
        })
        
    }
    
    
    @objc func stepAnimationReverse()
    {
        if (!isAnimationing) {
            return;
        }
        
        var frame:CGRect = self.tempAmimationRect;
        UIView.animate(withDuration: 1.5, animations: { () -> Void in
            
            self.alpha = 1.0;
            
            var frame = self.animationRect;
            let hImg = self.image!.size.height * self.animationRect.size.width / self.image!.size.width;
            print(hImg)
            frame.origin.y -= (hImg - hImg);
            frame.size.height = hImg;
            
            self.frame = frame;
        }, completion:{ (value: Bool) -> Void in
            
            self.perform(#selector(LBXScanLineAnimation.stepAnimation), with: nil, afterDelay: 0.0)
        })
        
    }
    
    func stopStepAnimating()
    {
        self.isHidden = true;
        isAnimationing = false;
    }
    
    static public func instance()->LBXScanLineAnimation
    {
        return LBXScanLineAnimation()
    }
    
    deinit
    {
        stopStepAnimating()
    }

}





