import Foundation

// 1000 - резервировано под ID parentCollection слова созданного пользователем

class IdGenerator{
    
    static var currentId = 2000
    
    static func getNewId() -> NSNumber {
        
        var reservedId:[Int] = []
        var wrongId = false
        
        for k in 900...1999{
            reservedId.append(k)
        }
        
        currentId = currentId+1
        for id in reservedId{
            if(id == currentId){
                wrongId = true
                break
            }
        }
        if(wrongId){ currentId = 2000 }
        
        let collectionList = auxiliaryTools.getCollectionListByCustomType(customType: true)
        for collection in collectionList{
            if(collection.id as! Int == currentId){
                wrongId = true
                break
            }
        }
        if(wrongId){ currentId = Int(self.getNewId()) }
        
        UserDefaults.standard.setValue(currentId, forKey: "lastId")
        return currentId as NSNumber
        
        
        
    }
    
    static func uploadIdGenerator(){
        currentId = UserDefaults.standard.integer(forKey: "lastId")
    }
    
    
    
}
