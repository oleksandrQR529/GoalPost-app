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
    private var goalDescription: String!
    private var goalType: GoalType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createGoalBtn.bindToKeyboard()
    }
        
    @IBAction func createGoalBtnPressed(_ sender: Any) {
        //Pass data into Core Date Goal Model
        self.save { (complete) in
            print("Completed")
        }
    }
    
}

extension FinishGoalVC {
    
    func initData(description: String, type: GoalType) {
        self.goalDescription = description
        self.goalType = type
    }
    
    func save(completion: (_ finished: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let goal = Goal(context: managedContext)
        
        goal.goalDescription = goalDescription
        goal.goalType = goalType.rawValue
        goal.goalCompletionValue = Int32(pointsTextField.text!) ?? 0
        goal.goalProgress = Int32(0)
        
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
