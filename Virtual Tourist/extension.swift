//
//  extension.swift
//  Virtual Tourist
//
//  Created by Jamel Reid  on 8/21/17.
//  Copyright © 2017 Jamel Reid . All rights reserved.
//

import Foundation
import UIKit


extension UIViewController {
    
    func showAlertView(title: String, message: String, buttonText: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: buttonText, style: .destructive, handler: nil)
        alertController.addAction(action)
        
        present(alertController, animated: true, completion: nil)
    }
}
