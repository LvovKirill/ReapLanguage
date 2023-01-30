//
//  Day.swift
//  FastEnglish
//
//  Created by Kirill on 04.07.2022.
//

import CoreData

@objc(DayPoint)
class DayPoint: NSManagedObject{
    @NSManaged var numberLearnedWords: NSNumber!
    @NSManaged var numberRepeatedWords: NSNumber!
    @NSManaged var progressCount: NSNumber!
    @NSManaged var date: Date!
}
