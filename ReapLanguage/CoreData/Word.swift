import CoreData

@objc(Word)
class Word: NSManagedObject{
    
    @NSManaged var id: NSNumber!
    @NSManaged var collectionID: NSNumber!
    @NSManaged var numberCorrectRepetitions: NSNumber!
    @NSManaged var baseWord: String!
    @NSManaged var targetWord: String!
    @NSManaged var identifierInTeachEvent: NSNumber!
    @NSManaged var breakIndicator: NSNumber!
    @NSManaged var parentCollection: NSNumber!
    @NSManaged var repeatDate: Date!
    
}
