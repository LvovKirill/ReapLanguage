//
//  ProgressPoint.swift
//  FastEnglish
//
//  Created by Kirill on 13.07.2022.
//

import Foundation

import CoreData

@objc(ProgressPoint)
class ProgressPoint: NSManagedObject{
    
    @NSManaged var number: NSNumber!
    @NSManaged var value: NSNumber!
    
}
