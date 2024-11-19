//
//  HelperFunc.swift
//  todotest
//
//  Created by Иван Незговоров on 18.11.2024.
//

import Foundation
import UIKit

class HelperFunc {
    static func convertToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
    
    static func createToolbar(target: Any, action: Selector) -> UIToolbar {
        let toolbar = UIToolbar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Закрыть", style: .done, target: target, action: action)
        toolbar.items = [flexSpace, doneButton]
        toolbar.sizeToFit()
        return toolbar
    }
}
