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
    @IBOutlet weak var timeOptionsHint: UILabel!
    @IBOutlet weak var timeOptionsStack: UIStackView!
    @IBOutlet weak var setTimeBtn: UIButton!
    @IBOutlet weak var everyDayBtn: UIButton!
    @IBOutlet weak var everyWeekBtn: UIButton!
    
    private var selectedController: UIViewController!
    private let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    
    private var goalType: GoalType?
    private var goalReminderDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
    }
    
    private func initUI() {
        termsBtnHint.isHidden = false
        
        timeOptionsHint.isHidden = true
        timeOptionsStack.isHidden = true
        
        setTimeBtn.isEnabled = false
        setTimeBtn.setDeselectedColor()
        
        nextBtn.bindToKeyboard()
        nextBtn.isEnabled = false
        nextBtn.setDeselectedColor()
        
        goalTextView?.delegate = self
    }
    
    @IBAction func shortTermBtnPressed(_ sender: Any) {
        shortTermBtn.setSelectedColor()
        longTermBtn.setDeselectedColor()
        
        goalType = .shortTerm
        
        selectedController = storyBoard.instantiateViewController(withIdentifier: "DatePickerVC")
        
        termsBtnHint.isHidden = true
        setTimeBtn.isEnabled = true
        setTimeBtn.setSelectedColor()
    }
    
    @IBAction func longTermBtnPressed(_ sender: Any) {
        longTermBtn.setSelectedColor()
        shortTermBtn.setDeselectedColor()
        
        goalType = .longTerm
        
        termsBtnHint.isHidden = true
        timeOptionsHint.isHidden = false
        timeOptionsStack.isHidden = false
    }
    
    @IBAction func everyDayBtnPressed(_ sender: Any) {
        everyDayBtn.setSelectedColor()
        everyWeekBtn.setDeselectedColor()
        
        setTimeBtn.isEnabled = true
        setTimeBtn.setSelectedColor()
        
        selectedController = storyBoard.instantiateViewController(withIdentifier: "TimePickerVC")
    }
    
    
    @IBAction func everyWeekBtnPressed(_ sender: Any) {
        everyWeekBtn.setSelectedColor()
        everyDayBtn.setDeselectedColor()
        
        setTimeBtn.isEnabled = true
        setTimeBtn.setSelectedColor()
        
        selectedController = storyBoard.instantiateViewController(withIdentifier: "DatePickerVC")
    }
    
    
    @IBAction func setTimeBtnPressed(_ sender: Any) {
        self.present(selectedController, animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let finishGoalVC = segue.destination as? FinishGoalVC {
            finishGoalVC.initData(description: goalTextView?.text ?? "What is your goal?", type: goalType!, date: goalReminderDate!)
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
    
    func setDate(goalReminderDate date: Date) {
        self.goalReminderDate = date
    }
    
    @IBAction func unwindFromCreateGoalsVC(unwindSegue: UIStoryboardSegue){}
    
}
