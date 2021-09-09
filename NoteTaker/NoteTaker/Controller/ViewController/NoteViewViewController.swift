//
//  NoteViewViewController.swift
//  NoteTaker
//
//  Created by Ashok Murugavel on 08/09/21.
//

import Foundation
import UIKit
import CoreData

protocol senddata {
    func tabledata(text:String)
}

class NoteViewViewController:UIViewController {
    var passedData:senddata!
    var text:String?
    var index:Int?
    var section:Int?
    var obj:Note?
    @IBOutlet weak var viewimage: UIImageView!
    var appd = UIApplication.shared.delegate as! AppDelegate
    var moc:NSManagedObjectContext?
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var NavigationBarOutlet: UINavigationBar!
    @IBOutlet weak var viewBookmark: UIBarButtonItem!
    var bookmarked:Int = 0
    override func viewWillAppear(_ animated: Bool) {
        textView.text = text
        textView.isEditable = false
        
        if(section==1){
            bookmarked = 0
            viewBookmark.image = UIImage(systemName:"bookmark")
            if(HomeViewController.otherarrayobj[index!].storeimage != nil){
                viewimage.image = UIImage(data: HomeViewController.otherarrayobj[index!].storeimage!)
            }
        }
        else
        {
            viewBookmark.image = UIImage(systemName:"bookmark.fill")
            bookmarked = 1
            if(HomeViewController.pinarrayobj[index!].storeimage != nil){
                viewimage.image = UIImage(data: HomeViewController.pinarrayobj[index!].storeimage!)
            }

        }
            
    }
    override func viewDidLoad() {
        moc = appd.persistentContainer.viewContext
    }
    @IBAction func viewBookMarkAction(_ sender: Any) {
        if(bookmarked == 0){
            if(HomeViewController.pinned.count < 4){
                addBookMark()
                bookmarked = 1
            }
            else{
                Alert.alertWithoutHandler(title: "Alert", mess: "4 pinned Notes Alreadt Present", x: self)
            }
        }
        else{
            removeBookMark()
            bookmarked = 0
        }
    }
    @IBAction func Options(_ sender: Any) {
        var alert = UIAlertController (title: "Options", message: "", preferredStyle: .actionSheet)
        let  button1 = UIAlertAction(title: "Share", style: .default,  handler: { action in
            //run your function here
            if(sharestate == true){
                self.share()
            }
            else
            {
                Alert.alertWithoutHandler(title: "Alert", mess: "Shareing has been disabled in Setttings", x: self)
            }
        })
        let  button2 = UIAlertAction(title: "Delete", style: .default, handler: { [self]action in
            //run your function here
            if(section == 0 ){
                HomeViewController.pinned.remove(at: index!)
                appd.persistentContainer.viewContext.delete(HomeViewController.pinarrayobj[index!])
                do{
                    try moc?.save()
                    print("Deleted")
                }
                catch{
                    print("Not Deleted")
                }
            }
            else{
                HomeViewController.others.remove(at: index!)
                appd.persistentContainer.viewContext.delete(HomeViewController.otherarrayobj[index!])
                do{
                    try moc?.save()
                    print("Deleted")
                }
                catch{
                    print("Not Deleted")
                }
                CreateNoteViewController.split()
            }
                dismiss(animated: true, completion: nil)
        })
        let  button3 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction (button1)
        alert.addAction (button2)
        alert.addAction (button3)
        self.present (alert, animated: true, completion: nil)

    }
    @IBAction func BackAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func Edit(_ sender: Any) {
        if(editButton.title == "Edit")
        {
        textView.isEditable = true
            editButton.title = "Done"
        }
        else{
            textView.isEditable = false
                editButton.title = "Edit"
        }
        if (section == 0){
            HomeViewController.pinned[index ?? 0] = textView.text
            HomeViewController.pinarrayobj[index ?? 0].setValue(textView.text, forKey: "notetext")
        }
        else{
            HomeViewController.others[index ?? 0] = textView.text
            HomeViewController.otherarrayobj[index! ?? 0].setValue(textView.text, forKey: "notetext")
        }
        do{
            try moc?.save()
            print("Updated")
        }
        catch{
            print("Not Updated")
        }
        CreateNoteViewController.split()
    }
    override func viewWillDisappear(_ animated: Bool) {
 
    }
    func addBookMark()
    {
        bookmarked = 1
        section = 0
        obj!.pinnedState = true
        viewBookmark.image = UIImage(systemName:"bookmark.fill")
        HomeViewController.pinarrayobj.append(obj!)
        HomeViewController.otherarrayobj.remove(at: index!)
        do{
            try moc?.save()
            print("Added")

        }
        catch{
            print("Not Added")
        }
        CreateNoteViewController.split()
    }
    func removeBookMark()
    {
        bookmarked = 0
        section = 1
        obj!.pinnedState = false
        viewBookmark.image = UIImage(systemName:"bookmark")
        HomeViewController.otherarrayobj.append(obj!)
        HomeViewController.pinarrayobj.remove(at: index!)
        do{
            try moc?.save()
            print("Removed")

        }
        catch{
            print("Not Removed")
        }
        CreateNoteViewController.split()
    }
    func share(){
        let items = [textView.text]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
}
