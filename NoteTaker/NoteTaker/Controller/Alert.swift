//
//  Alert.swift
//  NoteTaker
//
//  Created by Ashok Murugavel on 08/09/21.
//

import Foundation
import UIKit

class Alert: UIAlertController {
    
    static func alertWithOneButton( title: String, mess: String, button1: UIAlertAction, x: UIViewController){
        var alert =  UIAlertController(title: title, message: mess, preferredStyle: .alert)
        alert.addAction (button1)
        x.present (alert, animated: true, completion: nil)

    }

    static func alertWithTwoButtons( title: String, mess: String, button1: UIAlertAction, button2: UIAlertAction, x: UIViewController ){
        var alert = UIAlertController (title: title, message: mess, preferredStyle: .alert)

    alert.addAction (button1)
    alert.addAction (button2)
        x.present (alert, animated: true, completion: nil)

    }

    static func alertWithoutHandler( title: String, mess: String, x: UIViewController ){
        var alert = UIAlertController(title: title, message: mess, preferredStyle: .alert)
        var button = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction (button)
        x.present (alert, animated: true, completion: nil)

    }

    
}
