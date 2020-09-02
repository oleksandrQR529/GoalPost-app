//
//  CreateGoalVC.swift
//  goalPost-app
//
//  Created by Саша on 24.08.2020.
//  Copyright © 2020 Саша. All rights reserved.
//

import UIKit

class CreateGoalVC: UIViewController {

    @IBOutlet weak var goalTextView: UITextView?
    @IBOutlet weak var shortTermBtn: UIButton!
    @IBOutlet weak var longTermBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var termsBtnHint: UILabel!
    
    private var goalType: GoalType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        termsBtnHint.isHidden = false
        nextBtn.bindToKeyboard()
        goalTextView?.delegate = self
    }
    
    @IBAction func shortTermBtnPressed(_ sender: Any) {
        shortTermBtn.setSelectedColor()
        longTermBtn.setDeselectedColor()
        
        goalType = .shortTerm
        termsBtnHint.isHidden = true
        nextBtn.isEnabled = true
    }
    
    @IBAction func longTermBtnPressed(_ sender: Any) {
        longTermBtn.setSelectedColor()
        shortTermBtn.setDeselectedColor()
        
        goalType = .longTerm
        termsBtnHint.isHidden = true
        nextBtn.isEnabled = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let finishGoalVC = segue.destination as? FinishGoalVC {
            finishGoalVC.initData(description: goalTextView?.text ?? "What is your goal?", type: goalType!)
        }
    }
    
}

extension CreateGoalVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        goalTextView?.text = ""
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func unwindFromCreateGoalsVC(unwindSegue: UIStoryboardSegue){}
    
}
