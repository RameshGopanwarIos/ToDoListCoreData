//
//  ToDoList+CoreDataProperties.swift
//  SampleToDoListApp
//
//  Created by Ramesh Gopanwar on 19/12/24.
//
//

import Foundation
import CoreData


extension ToDoList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoList> {
        return NSFetchRequest<ToDoList>(entityName: "ToDoList")
    }

    @NSManaged public var name: String
    @NSManaged public var createdOn: Date

}

extension ToDoList : Identifiable {

}
