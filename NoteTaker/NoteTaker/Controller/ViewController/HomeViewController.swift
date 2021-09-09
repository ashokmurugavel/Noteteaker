//
//  HomeViewController.swift
//  NoteTaker
//
//  Created by Ashok Murugavel on 08/09/21.
//

import Foundation
import UIKit
import CoreData

class HomeViewController : UITableViewController {
    var moc:NSManagedObjectContext?
    var appd = UIApplication.shared.delegate as! AppDelegate
    static var pinned = [String]()
    static var pinarrayobj = [Note]()
    static var otherarrayobj = [Note]()
    static var others = [String]()
    var tit:Array? = ["Pinned","Others"]
    override func viewDidLoad() {
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        moc = appd.persistentContainer.viewContext
        var fetchRequest = NSFetchRequest<Note>(entityName: "Note")
        do{
            objarray = (try moc?.fetch(fetchRequest))!
            print("fetched in view")
        }
        catch{
            print("Not Fetched")
        }
        CreateNoteViewController.split()
        if(objarray.count == 0){
            Alert.alertWithoutHandler(title: "Notification", mess: "No Notes has been added", x: self)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    @IBAction func createNote(_ sender: Any) {
        let createNotevc = storyboard?.instantiateViewController(identifier: "createNote") as! CreateNoteViewController
        createNotevc.modalPresentationStyle = .fullScreen
        present(createNotevc, animated: true, completion: nil)
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tit!.count
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0){
            return "Pinned"
        }
        else{
            return "Others"
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return HomeViewController.pinned.count
        }
        else
        {
            return HomeViewController.others.count
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as? HomeTableViewCell
        if(indexPath.section == 0){
            cell?.textLabel?.text = HomeViewController.pinned[indexPath.row]
            return cell!
        }
        else{
            cell?.textLabel?.text = HomeViewController.others[indexPath.row]
            return cell!
        }
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewvc = storyboard?.instantiateViewController(identifier: "ViewVc") as! NoteViewViewController
        viewvc.passedData = self
        if (indexPath.section == 0){
            viewvc.text = HomeViewController.pinned[indexPath.row]
            viewvc.section = 0
            viewvc.obj = HomeViewController.pinarrayobj[indexPath.row]
            viewvc.index = indexPath.row
            
        }
        else{
            viewvc.text = HomeViewController.others[indexPath.row]
            viewvc.section = 1
            viewvc.index = indexPath.row
            viewvc.obj = HomeViewController.otherarrayobj[indexPath.row]
        }
        viewvc.modalPresentationStyle = .fullScreen
        present(viewvc, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let button1 = UIAlertAction(title: "Yes", style: .default ,handler: { [self] (action: UIAlertAction!) in
                if(indexPath.section == 0 ){
                    HomeViewController.pinned.remove(at: indexPath.row)
                    appd.persistentContainer.viewContext.delete(HomeViewController.pinarrayobj[indexPath.row])
                    do{
                        try moc?.save()
                        print("Deleted")
                    }
                    catch{
                        print("Not Deleted")
                    }
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
                else{
                    HomeViewController.others.remove(at: indexPath.row)
                    appd.persistentContainer.viewContext.delete(HomeViewController.otherarrayobj [indexPath.row])
                    do{
                        try moc?.save()
                        print("Deleted")
                    }
                    catch{
                        print("Not Deleted")
                    }
                    tableView.deleteRows(at: [indexPath], with: .fade)
            }
                }
            )
            let button2 = UIAlertAction(title: "Cancel", style: .default)
            Alert.alertWithTwoButtons(title: "Delete", mess: "Are you sure you want to delete", button1: button1, button2: button2, x: self)
        }
    }
    
}
extension HomeViewController:senddata{
    func tabledata(text: String) {
    }
}

