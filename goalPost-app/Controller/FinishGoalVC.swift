//
//  FinishGoalVC.swift
//  goalPost-app
//
//  Created by Саша on 25.08.2020.
//  Copyright © 2020 Саша. All rights reserved.
//

import UIKit
import CoreData

class FinishGoalVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var createGoalBtn: UIButton!
    @IBOutlet weak var pointsTextField: UITextField!
    @IBOutlet weak var pointsLbl: UILabel!
    private var goalDescription: String!
    private var goalType: GoalType!
    private var goalReminderDate: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        createGoalBtn.bindToKeyboard()
    }
    
    func initUI() {
        if goalType.rawValue == "Short-Term" {
            pointsTextField.isHidden = true
            pointsLbl.isHidden = true
        }else{
            pointsTextField.isHidden = false
            pointsLbl.isHidden = false
        }
    }
        
    @IBAction func createGoalBtnPressed(_ sender: Any) {
        //Pass data into Core Date Goal Model
        self.save { (complete) in
            print("Completed")
        }
    }
    
}

extension FinishGoalVC {
    
    func initData(description: String, type: GoalType, date: Date) {
        self.goalDescription = description
        self.goalType = type
        self.goalReminderDate = date
    }
    
    func save(completion: (_ finished: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let goal = Goal(context: managedContext)
        
        goal.goalDescription = goalDescription
        goal.goalType = goalType.rawValue
        goal.goalCompletionValue = Int32(pointsTextField.text!) ?? 1
        goal.goalProgress = Int32(0)
        goal.goalReminderDate = goalReminderDate
        
        do{
            try managedContext.save()
            completion(true)
        }catch {
            debugPrint("Could not save: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}
