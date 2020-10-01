//
//  timePickerVC.swift
//  goalPost-app
//
//  Created by Саша on 28.09.2020.
//  Copyright © 2020 Саша. All rights reserved.
//

import UIKit

class TimePickerVC: UIViewController {
    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let createGoalVC = segue.destination as? CreateGoalVC {
            createGoalVC.setDate(goalReminderDate: timePicker.date)
        }
    }
}
