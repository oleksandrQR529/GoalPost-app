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
    
    private(set) public static var goals: [Goal] = []
    
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

    }
    
    @objc func applicationWillEnterForeground(notification: Notification) {
        print("Application launched")
    }

}

extension GoalsVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GoalsVC.goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GoalCell") as? GoalCell else { return UITableViewCell() }
        let goal = GoalsVC.goals[indexPath.row]
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
            self.removeGoal(atIndexPath: indexPath, forGoals: GoalsVC.goals)
            self.fetchCoreDataObj()
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let addAction = UITableViewRowAction(style: .normal, title: "ADD 1") { (rowAction, indexPath) in
            self.setProgress(atIndexPathRow: indexPath.row, forGoals: GoalsVC.goals)
            
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
        
        let fetchRequest = NSFetchRequest<Goal>(entityName: "Goal")
        
        do {
            GoalsVC.goals = try managedContext.fetch(fetchRequest)
            completion(true)
        }catch {
            debugPrint("Could not fetch\(error.localizedDescription)")
            completion(false)
        }
    }
    
    func fetchCoreDataObj() {
        self.fetch { (complete) in
            if complete {
                if GoalsVC.goals.count >= 1 {
                    tableView.isHidden = false
                }else {
                    tableView.isHidden = true
                }
            }
        }
    }
    
    // MARK: - Unwind
    
    @IBAction func unwindFromGoalsVC(unwindSegue: UIStoryboardSegue){}
    
}
