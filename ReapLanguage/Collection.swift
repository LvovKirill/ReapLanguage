//
//  Collection.swift
//  ReapLanguage
//
//  Created by Kirill on 26.01.2023.
//

import Foundation
import CoreData

@objc(Collection)
class Collection: NSManagedObject{
    @NSManaged var id: NSNumber!
    @NSManaged var nameCollection: String!
    @NSManaged var emoji: String!
    @NSManaged var customType: NSNumber!
}
