//
//  LoginViewController.swift
//  NoteTaker
//
//  Created by Ashok Murugavel on 08/09/21.
//

import Foundation
import UIKit

class LoginViewController : UIViewController {
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg")!)
        loginView.layer.cornerRadius = 15
        loginView.layer.masksToBounds = true
    }
    @IBAction func LoginAction(_ sender: Any) {
        
        if(userName.text != "user" && password.text != "1234"){
            Alert.alertWithoutHandler(title: "Wrong Credentials", mess: "Username or Password is wrong", x: self)
        }
        else {
            let nextvc = storyboard?.instantiateViewController(identifier: "tabbar") as!
            TabBarController
            nextvc.modalPresentationStyle = .fullScreen
            present(nextvc, animated: true, completion: nil)
        }
        
    }
}
