//
//  Note+CoreDataProperties.swift
//  NoteTaker
//
//  Created by Ashok Murugavel on 08/09/21.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var notetext: String?
    @NSManaged public var pinnedState: Bool
    @NSManaged public var storeimage: Data?
    
    
}

extension Note : Identifiable {

}
