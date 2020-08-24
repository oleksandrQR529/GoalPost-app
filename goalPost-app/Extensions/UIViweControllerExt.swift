//
//  UIViweControllerExt.swift
//  goalPost-app
//
//  Created by Саша on 24.08.2020.
//  Copyright © 2020 Саша. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentDetail(_ viewControllerToresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        self.view.window?.layer.add(transition, forKey: kCATransition)
        
        present(viewControllerToresent, animated: false, completion: nil )
    }
    
    func dismissDetail( ) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window?.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: false, completion: nil)
    }
    
}
