//
//  GoalsVC.swift
//  goalPost-app
//
//  Created by Саша on 23.08.2020.
//  Copyright © 2020 Саша. All rights reserved.
//

import UIKit

class GoalsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func addGoalBtnPressed(_ sender: Any) {
        if tableView.isHidden == true {
            tableView.isHidden = false
        }else {
            tableView.isHidden = true
        }
    }
    
}

extension GoalsVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GoalCell") as? GoalCell else { return UITableViewCell() }
        cell.configureCell(description: "Eat salad twice a weak.", type: .shortTerm, goalProgress: 2)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}

