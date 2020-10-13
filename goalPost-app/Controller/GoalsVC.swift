//
//  GoalsVC.swift
//  goalPost-app
//
//  Created by Саша on 23.08.2020.
//  Copyright © 2020 Саша. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

let appDelegate = UIApplication.shared.delegate as? AppDelegate

class GoalsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var goals: [Goal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCoreDataObj()
        tableView.reloadData()
        print("Successfully reload data!")
    }
    
    func initUI() {
        tableView.dataSource = self
        tableView.delegate = self
        
        requestNotificationPermission()
    }

}

extension GoalsVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GoalCell") as? GoalCell else { return UITableViewCell() }
        let goal = goals[indexPath.row]
        cell.configureCell(goal: goal)
        
        if goal.goalProgress < goal.goalCompletionValue {
            initNotification(goal: goal)
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "DELETE") { (rowAction, indexPath) in
            self.removeGoal(atIndexPath: indexPath)
            self.fetchCoreDataObj()
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let addAction = UITableViewRowAction(style: .normal, title: "ADD 1") { (rowAction, indexPath) in
            self.setProgress(atIndexPath: indexPath)
            
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        addAction.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        
        return [deleteAction, addAction]
    }
}
    
extension GoalsVC {
    
    func fetch(completion: (_ complete: Bool) ->  ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let fetchRequest = NSFetchRequest<Goal>(entityName: "Goal")
        
        do {
            goals = try managedContext.fetch(fetchRequest)
            print("Successfully fetch data")
            completion(true)
        }catch {
            debugPrint("Could not fetch\(error.localizedDescription)")
            completion(false)
        }
    }
    
    func fetchCoreDataObj() {
        self.fetch { (complete) in
            if complete {
                if goals.count >= 1 {
                    tableView.isHidden = false
                }else {
                    tableView.isHidden = true
                }
            }
        }
    }
    
    func removeGoal(atIndexPath indexPath: IndexPath) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        managedContext.delete(goals[indexPath.row])
        do{
            try managedContext.save()
            print("Successfully removed goal!")
        }catch{
            debugPrint("Could not remove: \(error.localizedDescription)")
        }
    }
    
    func setProgress(atIndexPath indexPath: IndexPath) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let chosenGoal = goals[indexPath.row]
        
        if chosenGoal.goalProgress < chosenGoal.goalCompletionValue {
            chosenGoal.goalProgress += 1
        }else {
            return
        }
        
        do{
            try managedContext.save()
            print("Successfully set progress!")
        }catch{
            debugPrint("Could not set progress: \(error.localizedDescription)")
        }
    }
    
    @IBAction func unwindFromGoalsVC(unwindSegue: UIStoryboardSegue){}
    
}

extension GoalsVC {
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func initNotification(goal: Goal) {
        
        if goal.reminderIsActivated {
        }else {
            let content = UNMutableNotificationContent()
            content.title = goal.goalDescription ?? "What is your goal?"
            content.subtitle = fetchStringDate(date: goal.goalReminderDate!)
            content.sound = UNNotificationSound.default
            content.badge = 1
            content.categoryIdentifier = "goalPost-notification"

            let uuid = UUID().uuidString
            
            // show this notification at selected date
            let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: goal.goalReminderDate!)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

            // choose a random identifier
            let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
            
            // add our notification request
            UNUserNotificationCenter.current().add(request)
            goal.reminderIsActivated = true
        }
    }
    
}
