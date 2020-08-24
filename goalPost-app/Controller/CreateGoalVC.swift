//
//  CreateGoalVC.swift
//  goalPost-app
//
//  Created by Саша on 24.08.2020.
//  Copyright © 2020 Саша. All rights reserved.
//

import UIKit

class CreateGoalVC: UIViewController {

    @IBOutlet weak var goalTextView: UITextView!
    @IBOutlet weak var shortTermBtn: UIButton!
    @IBOutlet weak var longTermBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func shortTermBtnPressed(_ sender: Any) {
    }
    
    @IBAction func longTermBtnPressed(_ sender: Any) {
    }
    
    @IBAction func nextBtnPressed(_ sender: Any) {
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismissDetail()
    }
    
}
