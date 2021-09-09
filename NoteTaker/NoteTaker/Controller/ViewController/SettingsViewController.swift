//
//  SettingsViewController.swift
//  NoteTaker
//
//  Created by Ashok Murugavel on 08/09/21.
//

import Foundation
import UIKit
import CoreData

var sharestate:Bool = false
var addstate:Bool = true

class SettingsViewController: UIViewController {
 
    @IBOutlet weak var addbottom: UISwitch!
    @IBOutlet weak var shareenable: UISwitch!
    var appd = UIApplication.shared.delegate as! AppDelegate
    var moc:NSManagedObjectContext?
    override func viewWillAppear(_ animated: Bool) {
       
       }
    override func viewDidLoad() {
        moc = appd.persistentContainer.viewContext
        shareenable.isOn = false
        addbottom.isOn = true
    }
    @IBAction func Logout(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func Share(_ sender: UISwitch) {
        if(shareenable.isOn){
            sharestate = true
        }
        else{
            sharestate = false
        }
    }
    @IBAction func BottomAction(_ sender: UISwitch) {
        if(addbottom.isOn){
            addstate = true
        }
        else{
            addstate = false
        }
    }
}
