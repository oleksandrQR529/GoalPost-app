//
//  UIResponderExt.swift
//  goalPost-app
//
//  Created by Саша on 04.10.2020.
//  Copyright © 2020 Саша. All rights reserved.
//

import UIKit

extension UIResponder {
    
    func fetchStringDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        
        let stringDate = "\(dateFormatter.string(from: date)) - \(timeFormatter.string(from: date))"
        
        return stringDate
    }
    
}
