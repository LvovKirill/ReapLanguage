//
//  auxiliaryTools.swift
//  FastEnglish
//
//  Created by Kirill on 22.06.2022.
//

import Foundation
import AVFoundation
import CoreData
import AVKit


class auxiliaryTools{
    
    
    
    static func meaningByKey( value:String, wordData: Array<Word>) -> String{
        var returnWord = ""
        var index = 0
        for word in wordData{
            if word.baseWord==value{
                returnWord = word.targetWord
            }else if word.targetWord==value{
                returnWord = word.baseWord
            }
            index += 1
        }
        return returnWord
    }
    
    static func objectByKey( value:String, wordData: Array<Word>) -> Word{
        var returnWord:Word!
        var index = 0
        for word in wordData{
            if word.baseWord==value{
                returnWord = word
            }else if word.targetWord==value{
                returnWord = word
            }
            index += 1
        }
        return returnWord
    }
    
    static func getIndexByKey( value:String, wordData: Array<Word>) -> Int{
        var returnIndex = 0
        var index = 0
        for word in wordData{
            if word.baseWord==value{
                returnIndex=index
            }else if word.targetWord==value{
                returnIndex=index
            }
            index += 1
        }
        return returnIndex
    }
    
    
    static func getWordByCollectionId(collectionID: NSNumber, type: String) -> [Word]{
        
        var wordData:[Word]=[]
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Word")
        do{
            let results: NSArray = try context.fetch(request) as NSArray
            for result in results {
                let word = result as! Word
                
                switch type{
                case "all":
                    if(word.collectionID == collectionID){ wordData.append(word) }
                case "onlyNotLearned":
                    if(word.collectionID == collectionID){
                        if(Int(truncating: word.numberCorrectRepetitions) < Int(Settings.numberRepetitions)){wordData.append(word) } }
                case "onlyNew":
                    if(word.collectionID == collectionID && word.numberCorrectRepetitions == 0 ){ wordData.append(word) }
                case "forTeachEvent":
                    if(word.collectionID == collectionID){
                        if(Int(truncating: word.numberCorrectRepetitions) < Int(Settings.numberRepetitions)){
                            if(word.breakIndicator != false){wordData.append(word) } } }
                default:
                    break
            }
            
            }
        }catch{
            print("Fetch Failed")
        }
        
        return wordData
    }
    
    
    static func getAllCollections() -> [Collection] {
        
        var collections:[Collection] = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Collection")
        do{
            let results: NSArray = try context.fetch(request) as NSArray
            for result in results {
                let collection = result as! Collection
                collections.append(collection)
            }
        }catch{
            print("Fetch Failed")
        }
        
        return collections
        
    }
    
    static func getAllProgressPoint() -> [ProgressPoint] {
        
        var progressPoints:[ProgressPoint] = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ProgressPoint")
        do{
            let results: NSArray = try context.fetch(request) as NSArray
            for result in results {
                let progressPoint = result as! ProgressPoint
                progressPoints.append(progressPoint)
            }
        }catch{
            print("Fetch Failed")
        }
        
        return progressPoints
        
    }
    
    
    static func getAllDayPoint() -> [DayPoint] {
        
        var dayPoints:[DayPoint] = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DayPoint")
        do{
            let results: NSArray = try context.fetch(request) as NSArray
            for result in results {
                let dayPoint = result as! DayPoint
                dayPoints.append(dayPoint)
            }
        }catch{
            print("Fetch Failed")
        }
        
        return dayPoints
        
    }
    
    static func getDayPoint(date: DateComponents) -> DayPoint{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "DayPoint", in: context)
        
        
        var existFlag = false
        var existDayPoint:DayPoint!
        
        for dayPoint in auxiliaryTools.getAllDayPoint(){
            if(dayPoint.date != nil){
            let dayPointDate = DateManager.getDateComponents(date: dayPoint.date)
            if(date.year == dayPointDate.year && date.month == dayPointDate.month && date.day == dayPointDate.day){
                existFlag = true
                existDayPoint = dayPoint
                break
            }
                
        }
        }
        
        let newDayPoint = DayPoint(entity: entity! , insertInto: context)
        
        if(existFlag){
            return existDayPoint
        }else{
            let day = auxiliaryTools.getAllDayPoint()[0]
            day.numberLearnedWords = 0
            day.numberRepeatedWords = 0
            day.progressCount = 0
            day.date = Date()
            
            return day
        }
        
    }
    
    
    static func deleteWord(object: Word){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Word")
        
        if (try? context.fetch(request)) != nil {
//            for object in result {
            context.delete(object as NSManagedObject)
//            }
        }
        do {
            try context.save()
        } catch {
            //Handle error
        }
        
    }
    
    static func makeSpeech(text: String, targetLanguage: Bool){
        let synthesizer = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-EN")
        synthesizer.speak(utterance)
    }
    
    static func makeSound(nameSound:String){
        
        
        var player: AVAudioPlayer!
        
        guard let url = Bundle.main.url(forResource: nameSound, withExtension: "mp3") else { return }
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
                player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
                guard let player = player else { return }
                player.play()
            } catch _ {
                print("ошибка воспроизведения звука")
            }
    }
    
    static func saveCoreData(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        do{
            try context.save()
        }catch{
            print("context save error")
        }
        
    }
    
    static func addCollection(id: NSNumber, nameCollection: String, emoji: String, customType: Bool){
        var collectionList = [Collection]()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = self.getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Collection", in: context)
        

        let newCollection = Collection(entity: entity! , insertInto: context)
        
        newCollection.id = id
        newCollection.nameCollection = nameCollection
        newCollection.emoji = emoji
        newCollection.customType = customType as NSNumber
        
        do{
            collectionList.append(newCollection)
            try context.save()
        }catch{
            print("context save error")
        }
        
    }
    
    static func addWord(collectionID: NSNumber, targetWord: String, baseWord: String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Word", in: context)
        let newWord = Word(entity: entity! , insertInto: context)
        newWord.id = IdGenerator.getNewId()
        newWord.collectionID = collectionID
        newWord.baseWord = baseWord
        newWord.targetWord = targetWord
        newWord.numberCorrectRepetitions = 0
        
        do{
            try context.save()
        }catch{
            print("context save error")
        }
        
    }
    
    
    static func addWord(word: Word){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Word", in: context)
        
        let newWord = Word(entity: entity! , insertInto: context)
        
        newWord.id = word.id
        newWord.collectionID = word.collectionID
        newWord.baseWord = word.baseWord
        newWord.targetWord = word.targetWord
        newWord.numberCorrectRepetitions = word.numberCorrectRepetitions
        newWord.identifierInTeachEvent = word.identifierInTeachEvent
        
        do{
            try context.save()
        }catch{
            print("context save error")
        }
        
    }
    
    static func addProgressPoint(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "ProgressPoint", in: context)
        
        let newProgressPoint = ProgressPoint(entity: entity! , insertInto: context)
        
        let currentNumber = UserDefaults.standard.integer(forKey: "numberForProgressPoint")
        UserDefaults.standard.set(currentNumber + 1, forKey: "numberForProgressPoint")
        
        newProgressPoint.number = currentNumber as NSNumber
        newProgressPoint.value = auxiliaryTools.getProgressPointValue() as NSNumber
        
        do{
            try context.save()
        }catch{
            print("context save error")
        }
        
    }
    
    static func addDayPoint(numberLearnedWords: NSNumber, numberRepeatedWords: NSNumber, progressCount: NSNumber){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "DayPoint", in: context)
        let date = DateManager.getCurrentDate()
        
        var existFlag = false
        var existDayPoint:DayPoint!
        
        if(auxiliaryTools.getAllDayPoint().count != 0){
//        for dayPoint in auxiliaryTools.getAllDayPoint(){
//            let dayPointDate = DateManager.getDateComponents(date: dayPoint.date)
//            if(date.year == dayPointDate.year && date.month == dayPointDate.month && date.day == dayPointDate.day){
//                existFlag = true
//                existDayPoint = dayPoint
//                break
//            }
//        }
        }
        
        let newDayPoint = DayPoint(entity: entity! , insertInto: context)
        
        if(existFlag){
            existDayPoint.willChangeValue(forKey: "numberLearnedWords")
            existDayPoint.setPrimitiveValue((Int(truncating: existDayPoint.numberLearnedWords) + 1) as NSNumber, forKey: "numberLearnedWords")
            existDayPoint.didChangeValue(forKey: "numberLearnedWords")
                
            existDayPoint.willChangeValue(forKey: "numberRepeatedWords")
            existDayPoint.setPrimitiveValue((Int(truncating: existDayPoint.numberRepeatedWords) + 1) as NSNumber, forKey: "numberRepeatedWords")
            existDayPoint.didChangeValue(forKey: "numberRepeatedWords")
            
            existDayPoint.willChangeValue(forKey: "progressCount")
            existDayPoint.setPrimitiveValue((Int(truncating: existDayPoint.progressCount) + 1) as NSNumber, forKey: "progressCount")
            existDayPoint.didChangeValue(forKey: "progressCount")
        }else{
            newDayPoint.date = Date()
            newDayPoint.numberLearnedWords = numberLearnedWords
            newDayPoint.numberRepeatedWords = numberRepeatedWords
            newDayPoint.progressCount = progressCount
        }
        
        do{
            try context.save()
        }catch{
            print("context save error")
        }
    }
    
    
    static func getCollectionListByCustomType(customType: Bool) -> [Collection]{
        
        var collections:[Collection]=[]

        for collection in auxiliaryTools.getAllCollections(){
            if(customType == true && collection.customType == true){
                collections.append(collection)
            }else if (customType == false && collection.customType == false){
                collections.append(collection)
            }
        }
        return collections
    }
    
    static func cleanDefaultCollections(){
        
        let collections:[Collection] = auxiliaryTools.getCollectionListByCustomType(customType: false)
        
        for collection in collections{
        let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.persistentContainer.viewContext
        
        let words = auxiliaryTools.getWordByCollectionId(collectionID: collection.id, type: "all")
            
        for word in words{
            context.delete(word)
        }
            context.delete(collection)
        
        }
    }
    
    static func getCollectionById(id: NSNumber) -> Collection{
        print(id)
        
        let collectionList = auxiliaryTools.getAllCollections()
        var returnCollection:Collection!
        
        for collection in collectionList{
            if(collection.id == id){
                returnCollection = collection
                break
            }
        }
        return returnCollection
    }
    
    
    static func reloadBreakIndicator(){
        for collection in auxiliaryTools.getAllCollections(){
            for word in auxiliaryTools.getWordByCollectionId(collectionID: collection.id, type: "all"){
                if(word.breakIndicator == false){
                    let date = DateManager.getCurrentDate()
                    let dateThisWord = DateManager.getDateComponents(date: word.repeatDate)
                    let hour = (dateThisWord.hour! + dateThisWord.day! * 24) - (date.hour! + date.day! * 24)
                    if(hour<=0){
                        word.willChangeValue(forKey: "breakIndicator")
                        word.setPrimitiveValue(true, forKey: "breakIndicator")
                        word.didChangeValue(forKey: "breakIndicator")
                    }
                }
            }
        }
    }
    
    
    static func getProgressPointValue() -> Int{
        var value = 0
        for collection in auxiliaryTools.getAllCollections(){
            for word in auxiliaryTools.getWordByCollectionId(collectionID: collection.id, type: "all"){
                value += word.numberCorrectRepetitions as! Int
            }
        }
        return value
    }
    
    
    static func getInfoAlert(title:String, message:String) -> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        return alert
    }
    
    static func getContext() -> NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        return context
    }
    
    
    
    
}
