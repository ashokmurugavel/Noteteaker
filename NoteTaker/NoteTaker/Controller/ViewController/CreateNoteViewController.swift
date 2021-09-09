//
//  CreateNoteViewController.swift
//  NoteTaker
//
//  Created by Ashok Murugavel on 08/09/21.
//

import Foundation
import  UIKit
import CoreData

var objarray:[Note] = []

class CreateNoteViewController : UIViewController{
    
    @IBOutlet weak var TextField: UITextView!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var BookmarkOutlet: UIBarButtonItem!
    var appd = UIApplication.shared.delegate as! AppDelegate
    var moc:NSManagedObjectContext?
    var bookmarked:Int = 0
    var cancel:Int = 0
    var flag:Int = 0
    var jpegImageData:Any?
    override func viewDidLoad() {
        moc = appd.persistentContainer.viewContext
        var fetchRequest = NSFetchRequest<Note>(entityName: "Note")
        do{
            objarray = (try moc?.fetch(fetchRequest))!
            print("fetched")
        }
        catch{
            print("Not Fetched")
        }
        CreateNoteViewController.split()
    }
    override func viewWillAppear(_ animated: Bool) {
        TextField.becomeFirstResponder()
        if(bookmarked==0){
            BookmarkOutlet.image = UIImage(systemName:"bookmark")
        }
        else
        {
            BookmarkOutlet.image = UIImage(systemName:"bookmark.fill")
        }
    }
    @IBAction func bookMarkAction(_ sender: Any) {
        if(bookmarked==0 && HomeViewController.pinned.count <= 3){
            addBookMark()
        }
        else{
            Alert.alertWithoutHandler(title: "Error", mess: "Unable to pin", x: self)
            removeBookMark()
        }
    }
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)

    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.cancel = 1
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func addImage(_ sender: Any) {
        flag = 1
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true, completion: nil)
    }
    @IBAction func optionsButton(_ sender: Any) {
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        print(flag)
        if(self.cancel == 0 && flag != 1){
            savenote()
        }
        else{
            cancel = 0
        }
    }
    func savenote(){
        _ = storyboard?.instantiateViewController(identifier: "homevc") as! HomeViewController
        
        if TextField.text.count > 0{
            if(bookmarked==1){
                var obj = NSEntityDescription.insertNewObject(forEntityName: "Note", into: moc!) as? Note
                obj?.notetext = TextField.text
                obj?.pinnedState = true
                obj?.storeimage = jpegImageData as! Data
            }
            else{
                var obj = NSEntityDescription.insertNewObject(forEntityName: "Note", into: moc!) as? Note
                obj?.notetext = TextField.text
                obj?.pinnedState = false
                obj?.storeimage = jpegImageData as! Data

            }
            do{
                try moc?.save()
                print("Data Saved")
            }
            catch{
                print("Data Not Saved")
            }
        }
    }
    func addBookMark()
    {
        bookmarked = 1
        BookmarkOutlet.image = UIImage(systemName:"bookmark.fill")
        
    }
    func removeBookMark()
    {
        bookmarked = 0
        BookmarkOutlet.image = UIImage(systemName:"bookmark")
    }
    static func split(){
        var appd = UIApplication.shared.delegate as! AppDelegate
        var moc:NSManagedObjectContext?
        moc = appd.persistentContainer.viewContext
        var fetchRequest = NSFetchRequest<Note>(entityName: "Note")
        do{
            objarray = (try moc?.fetch(fetchRequest))!
            print("fetched")
        }
        catch{
            print("Not Fetched")
        }
        print(objarray.count)
        print(HomeViewController.pinarrayobj.count)
        print(HomeViewController.otherarrayobj.count)
        HomeViewController.pinned = []
        HomeViewController.others = []
        HomeViewController.pinarrayobj = []
        HomeViewController.otherarrayobj = []
        for i in objarray{
            if(i.pinnedState == true){
                HomeViewController.pinned.append(i.notetext ?? "Nil")
                HomeViewController.pinarrayobj.append(i)
            }
            else{
                HomeViewController.others.append(i.notetext ?? "Nil")
                HomeViewController.otherarrayobj.append(i)
            }
        }
    }
}
extension CreateNoteViewController:UIImagePickerControllerDelegate ,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image:UIImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as! UIImage
         jpegImageData = image.jpegData(compressionQuality: 1.0)
        let pngImageData  = image.pngData()
        imageview.image = image as! UIImage
//        let entityName =  NSEntityDescription.entity(forEntityName: "Note", in: moc!)!
//        let immage = NSManagedObject(entity: entityName, insertInto: moc)
//        immage.setValue(jpegImageData, forKeyPath: "storeimage")
//        do {
//            try moc?.save()
//            print("Image Saved")
//        } catch let error as NSError {
//          print("Could not save. \(error), \(error.userInfo)")
//        }
        picker.dismiss(animated: true, completion: nil)
        flag = 0
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    }
  

