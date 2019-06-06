//
//  SwiftQRScannerAnimation.swift
//  QRScannerProject
//
//  Created by Asif Newaz on 5/6/19.
//  Copyright © 2019 Asif Newaz. All rights reserved.
//

import Foundation
import UIKit

extension QRCodeScannerController {
    /**
     *  开始扫描动画
     */
    // ⬇︎⬇︎⬇︎ animation starts from here ⬇︎⬇︎⬇︎
    // Here i am passing a CGRect of center animating view, main view, and animating image
    
    func startScanAnimation(rect: CGRect)
    {
        if isAnimationing {
            return
        }
        isAnimationing = true
        let cropRect:CGRect = rect
        scanLineAnimation!.startAnimatingWithRect(animationRect: cropRect, parentView: self.view, image: UIImage(named: "ScanLine") )
    }
    
    /**
     *  开始扫描动画
     */
    func stopScanAnimation()
    {
        isAnimationing = false
        scanLineAnimation?.stopStepAnimating()
    }
    
}
