//
//  DifferentQRSelectionViewController.swift
//  QRScannerProject
//
//  Created by MacBook Pro on 5/6/19.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import UIKit

class DifferentQRSelectionViewController: UIViewController {

    var  afterSuccessfullySelected: ((_ item: String?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func dissmissAction(_ sender: UIButton) {
        if let afterSuccessfullySelected = self.afterSuccessfullySelected {
            afterSuccessfullySelected("Nexus Pay")
        }
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
