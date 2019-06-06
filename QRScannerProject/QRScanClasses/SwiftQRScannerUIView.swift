//
//  SwiftQRScannerUIView.swift
//  QRScannerProject
//
//  Created by Asif Newaz on 5/6/19.
//  Copyright © 2019 Asif Newaz. All rights reserved.
//

import Foundation
import UIKit

extension QRCodeScannerController {
    
    ///Creates corner rectagle frame with white color(default color)
    func createCornerFrame() {
        let rect = CGRect.init(origin: CGPoint.init(x: self.view.frame.midX - centerFrameWidth/2, y: self.view.frame.midY - (centerFrameWidth+bottomSpace)/2), size: CGSize.init(width: centerFrameWidth, height: centerFrameHeight))
        self.squareView = SquareView(frame: rect)
        if let squareView = squareView {
            self.view.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
            squareView.autoresizingMask = UIView.AutoresizingMask(rawValue: UInt(0.0))
            self.view.addSubview(squareView)
            
            addMaskLayerToVideoPreviewLayerAndAddText(rect: rect)
        }
    }
    
    func addMaskLayerToVideoPreviewLayerAndAddText(rect: CGRect) {
        let maskLayer = CAShapeLayer()
        maskLayer.frame = view.bounds
        maskLayer.fillColor = UIColor(white: 0.0, alpha: 0.5).cgColor
        let path = UIBezierPath(rect: rect)
        path.append(UIBezierPath(rect: view.bounds))
        maskLayer.path = path.cgPath
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        
        view.layer.insertSublayer(maskLayer, above: videoPreviewLayer)
  
        // flash button
        flashButton = UIButton(frame: CGRect(x: view.frame.width/2 - (44.0 + 8 ) , y: rect.origin.y + rect.size.height + 30, width: 44.0, height: 44.0))
        flashButton.tintColor = UIColor.white
        flashButton.contentMode = .scaleAspectFit
        flashButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside) //toggleTorch
        if let flashOffImg = flashOffImage {
            flashButton.setImage(flashOffImg, for: .normal)
            view.addSubview(flashButton)
        }
        
        //Camera button
        let cameraButton = UIButton(frame: CGRect(x: self.view.bounds.width/2 + 8 , y: rect.origin.y + rect.size.height + 30, width: 44.0, height: 44.0))
        cameraButton.addTarget(self, action: #selector(openGallary), for: .touchUpInside)
        cameraButton.contentMode = .scaleAspectFit
        if let cameraImg = cameraImage {
            cameraButton.setImage(cameraImg, for: .normal)
            view.addSubview(cameraButton)
        }
        
        
        let bottomInfoLabel = UILabel()
        bottomInfoLabel.text = "Shop not accepting CashBaba?"
        bottomInfoLabel.textColor = UIColor.gray
        bottomInfoLabel.font = UIFont(name: "Avenir Next", size: 13)
        view.addSubview(bottomInfoLabel)
        bottomInfoLabel.anchorCenterXToSuperview()
        bottomInfoLabel.anchor(nil, left: nil, bottom: view.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: bottomSpace + 35 , rightConstant: 0, widthConstant: 0 , heightConstant: 15)
        
        let bottomInfoButton = UIButton()
        bottomInfoButton.setTitle("Refer Shop", for: .normal)
        bottomInfoButton.setTitleColor(UIColor.gray, for: .normal)
        bottomInfoButton.titleLabel?.font =  UIFont(name: "Avenir Next", size: 14)
        
        view.addSubview(bottomInfoButton)
        bottomInfoButton.anchorCenterXToSuperview()
        bottomInfoButton.anchor(nil, left: nil, bottom: view.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 15, rightConstant: 0, widthConstant: 0 , heightConstant: 25)

        
        //QR Selection View
        let qrSelectionView = UIView(frame: CGRect(x: self.view.bounds.width/2 - qrSelectionViewWidth/2 , y: rect.origin.y - (qrSelectionViewHeight + qrSelectionViewWidth/2), width: qrSelectionViewWidth , height: qrSelectionViewHeight))
        
        qrSelectionView.backgroundColor = UIColor.clear
        qrSelectionView.layer.borderWidth = 1.5
        qrSelectionView.layer.borderColor = UIColor.white.cgColor
        qrSelectionView.layer.cornerRadius = 6
        view.addSubview(qrSelectionView)
        qrSelectionView.addTapGesture(tapNumber: 1, target: self, action: #selector(qRViewClicked))
        self.addItemToQRSelectionView(qrSelectionView)
        
        scanLineAnimation = LBXScanLineAnimation.instance()
        startScanAnimation(rect: rect)
        
    }
    
    /// Adds buttons to view which can we used as extra fearures
    private func addItemToQRSelectionView(_ view: UIView) {
        let logoHeight: CGFloat = 44.0
        let logoWidth: CGFloat = 44.0
        
        
        logoImageView.image = UIImage(named: "CBLightGray80")
        view.addSubview(logoImageView)
        logoImageView.anchorCenterYToSuperview()
        logoImageView.anchor(nil, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: qrSelectionViewHeight/2 , heightConstant: qrSelectionViewHeight/2)
        
        
        let rightArrowImage = UIImageView()
        rightArrowImage.image = UIImage(named: "RightArrow")
        view.addSubview(rightArrowImage)
        rightArrowImage.anchorCenterYToSuperview()
        rightArrowImage.anchor(nil, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 8, widthConstant: qrSelectionViewHeight/2 , heightConstant: qrSelectionViewHeight/2)
        
        
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        nameLabel.textColor = UIColor.white
        nameLabel.text = self.selectedQRLabel
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .center
        
        view.addSubview(nameLabel)
        nameLabel.anchor(view.topAnchor, left: logoImageView.rightAnchor, bottom: view.bottomAnchor, right: rightArrowImage.leftAnchor, topConstant: 5, leftConstant: 8, bottomConstant: 5, rightConstant: 8, widthConstant: 0 , heightConstant: 0)
        
    }
    
    
//    /// Adds buttons to view which can we used as extra fearures
//    private func addButtons(_ view: UIView) {
//    }
    
    @objc func qRViewClicked(_ sender: UITapGestureRecognizer) {
        self.stopScanAnimation()
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "DifferentQRSelectionViewController") as? DifferentQRSelectionViewController
        loginVC?.afterSuccessfullySelected = { [weak self] item in
            if let itmeSelected = item {
                self?.nameLabel.text = ""
                self?.selectedQRLabel = itmeSelected
            }
        }

        self.present(loginVC!, animated: true, completion: nil)
    }
}
