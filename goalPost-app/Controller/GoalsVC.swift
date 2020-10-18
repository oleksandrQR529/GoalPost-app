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
    
    private(set) public var goals: [Goal] = []
    private(set) public var preGoalReminders: [PreGoalReminder] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCoreDataObj()
        tableView.reloadData()
    }
    
    func initUI() {
        tableView.dataSource = self
        tableView.delegate = self
        
        requestNotificationPermission()
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notificationWillEnterForeground), name: NSNotification.Name("goalPost-notification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reminderwillEnterForeground), name: NSNotification.Name("preGoalReminder-notification"), object: nil)

    }
    
    @objc func applicationWillEnterForeground(notification: Notification) {
        viewWillAppear(true)
    }
    
    @objc func notificationWillEnterForeground(notification: Notification) {
        for goal in goals {
            if goal.goalNotificationUuid == notification.userInfo!["notificationUuid"] as! String {
                self.setProgress(goal: goal)
                self.changeActivationStatusOfReminder(reminder: goal)
            }
        }
        viewWillAppear(true)
    }
    
    @objc func reminderwillEnterForeground(notification: Notification) {
        for preGoalReminder in preGoalReminders {
            if preGoalReminder.preGoalNotificationUuid == notification.userInfo!["notificationUuid"] as! String {
                self.changeActivationStatusOfReminder(reminder: preGoalReminder)
            }
        }
    }

}

extension GoalsVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GoalCell") as? GoalCell else { return UITableViewCell() }
        let goal = goals[indexPath.row]
        let preGoalReminder = preGoalReminders[indexPath.row]
        cell.configureCell(goal: goal)
        
        if goal.goalProgress < goal.goalCompletionValue {
            initNotification(goal: goal)
            initPreGoalReminder(preGoalReminder: preGoalReminder)
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
            self.removeGoal(goal: self.goals[indexPath.row])
            self.removePreGoalReminder(preGoalReminder: self.preGoalReminders[indexPath.row])
            self.fetchCoreDataObj()
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let addAction = UITableViewRowAction(style: .normal, title: "ADD 1") { (rowAction, indexPath) in
            self.setProgress(goal: self.goals[indexPath.row])
            
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        addAction.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        
        return [deleteAction, addAction]
    }
}
    
extension GoalsVC {
    
    // MARK: - Core Data Fetching support
    
    func fetch(completion: (_ complete: Bool) ->  ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let fetchRequest1 = NSFetchRequest<Goal>(entityName: "Goal")
        let fetchRequest2 = NSFetchRequest<PreGoalReminder>(entityName: "PreGoalReminder")
        
        do {
            goals = try managedContext.fetch(fetchRequest1)
            preGoalReminders = try managedContext.fetch(fetchRequest2)
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
    
    // MARK: - Unwind
    
    @IBAction func unwindFromGoalsVC(unwindSegue: UIStoryboardSegue){}
    
    // MARK: - Delete/Modificate Goal in Core Date
    
    func removeGoal(goal: Goal) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let notificationCenter = UNUserNotificationCenter.current()
        
        managedContext.delete(goal)
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [goal.goalNotificationUuid!])
        do{
            try managedContext.save()
        }catch{
            debugPrint("Could not remove: \(error.localizedDescription)")
        }
    }
    
    func removePreGoalReminder(preGoalReminder: PreGoalReminder) {
        guard let manageContext = appDelegate?.persistentContainer.viewContext else { return }
        let notificationCenter = UNUserNotificationCenter.current()
        
        manageContext.delete(preGoalReminder)
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [preGoalReminder.preGoalNotificationUuid!])
        do{
            try manageContext.save()
        }catch{
            debugPrint("Could not remove: \(error.localizedDescription)")
        }
    }
    
    func setProgress(goal: Goal) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
    
        if goal.goalProgress < goal.goalCompletionValue {
            goal.goalProgress += 1
        }else {
            return
        }
        
        do{
            try managedContext.save()
        }catch{
            debugPrint("Could not set progress: \(error.localizedDescription)")
        }
    }
    
    func changeActivationStatusOfReminder(reminder: Goal) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        if reminder.reminderIsActivated {
            reminder.reminderIsActivated = false
        }else {
            reminder.reminderIsActivated = true
        }
        
        do{
            try managedContext.save()
        }catch{
            debugPrint("Could not change activation status \(error.localizedDescription)")
        }
    }
    
    func changeActivationStatusOfReminder(reminder: PreGoalReminder) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        if reminder.preGoalReminderIsActivated {
            reminder.preGoalReminderIsActivated = false
        }else {
            reminder.preGoalReminderIsActivated = true
        }
        
        do{
            try managedContext.save()
        }catch{
            debugPrint("Could not change activation status \(error.localizedDescription)")
        }
    }
    
    // MARK: - Notifications
    
    func initNotification(goal: Goal) {
        
        if goal.reminderIsActivated {
        }else {
            let content = UNMutableNotificationContent()
            content.title = goal.goalDescription ?? "What is your goal?"
            content.subtitle = fetchStringDate(date: goal.goalReminderDate!)
            content.sound = UNNotificationSound.default
            content.badge = 1
            content.categoryIdentifier = "goalPost-notification"

            let uuid = goal.goalNotificationUuid!
            
            // show this notification at selected date
            let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: goal.goalReminderDate!)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

            // choose a identifier
            let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
            
            // add our notification request
            UNUserNotificationCenter.current().add(request)
            self.changeActivationStatusOfReminder(reminder: goal)
        }
    }
    
    func initPreGoalReminder(preGoalReminder: PreGoalReminder) {
        if preGoalReminder.preGoalReminderIsActivated || preGoalReminder.preGoalTravelTime == "0"{
        }else {
            let content = UNMutableNotificationContent()
            content.title = preGoalReminder.preGoalReminderDescription!
            content.subtitle = preGoalReminder.preGoalReminderSubtitle!
            content.sound = UNNotificationSound.default
            content.categoryIdentifier = "preGoalReminder-notification"
            
            let uuid = preGoalReminder.preGoalNotificationUuid!
            
            // show this notification at select date
            let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: preGoalReminder.preGoalReminderTime!)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
            
            // choose a identifier
            let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
            
            // add our notification request
            UNUserNotificationCenter.current().add(request)
            self.changeActivationStatusOfReminder(reminder: preGoalReminder)
        }
    }
    
}
