//
//  Common.swift
//  MVVMCombine
//
//  Created by Victor Roldan on 11/02/21.
//

import Foundation
import UIKit

struct CustomAlert {
    static func show(in viewController : UIViewController, withMessage message : String, withTitle title : String = "Message"){
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.view.accessibilityIdentifier = "customAlert"
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        // show the alert
        viewController.present(alert, animated: true, completion: nil)
    }
}
