//
//  QRScannerCodeDelegate.swift
//  QRScannerProject
//
//  Created by Asif Newaz on 5/6/19.
//  Copyright © 2019 Asif Newaz. All rights reserved.
//

import UIKit


///This enum defines the scan modes
public enum QRScanMode {
    case camera
    case gallery
}

///
///  This protocol defines methods which get called when some events occures.
///
public protocol QRScannerCodeDelegate: class {
    func qrScanner(_ controller: UIViewController, scanDidComplete result: String)
    func qrScannerDidFail(_ controller: UIViewController,  error: String)
    func qrScannerDidCancel(_ controller: UIViewController)
}
