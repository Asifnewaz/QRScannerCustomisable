//
//  ViewController.swift
//  QRScannerProject
//
//  Created by MacBook Pro on 4/6/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func scanQRCode(_ sender: Any) {
        
        //QRCode scanner without Camera switch and Torch
        //let scanner = QRCodeScannerController()
        //QRCode with Camera switch and Torch
        let scanner = QRCodeScannerController(cameraImage: UIImage(named: "ImageIcon40"), cancelImage: UIImage(named: "cancel"), flashOnImage: UIImage(named: "Flash40"), flashOffImage: UIImage(named: "Flash40"))
        scanner.delegate = self
        scanner.mode = .camera
        self.present(scanner, animated: true, completion: nil)
    }

}


extension ViewController: QRScannerCodeDelegate {
    func qrScanner(_ controller: UIViewController, scanDidComplete result: String) {
        print("result:\(result)")
    }
    
    func qrScannerDidFail(_ controller: UIViewController, error: String) {
        print("error:\(error)")
    }
    
    func qrScannerDidCancel(_ controller: UIViewController) {
        print("SwiftQRScanner did cancel")
    }
}
