import Foundation
import CoreData
import UIKit


class TeachEvent{
    
    var appDelegate:AppDelegate
    var errorType:Bool
    var wordData:[Word]=[]
    var errorWordList:[Word]=[]
    
    init(wordData:[Word], appDelegate:AppDelegate, errorType: Bool){
        self.appDelegate=appDelegate
        self.errorType = errorType
        
        if(wordData.count > 5){
        for i in 0...4{
            self.wordData.append(wordData[i])
        }
        }else{ self.wordData = wordData}
        
        for i in 0...wordData.count - 1{
            wordData[i].identifierInTeachEvent = true
        }
    }
    
    func completeTeachEvent(){
        let temporaryWordData = wordData
        for i in 0...temporaryWordData.count-1{
            if(temporaryWordData[i].identifierInTeachEvent == true){
                temporaryWordData[i].willChangeValue(forKey: "numberCorrectRepetitions")
                temporaryWordData[i].setPrimitiveValue((Int(truncating: temporaryWordData[i].numberCorrectRepetitions) + 1) as NSNumber, forKey: "numberCorrectRepetitions")
                temporaryWordData[i].didChangeValue(forKey: "numberCorrectRepetitions")
                auxiliaryTools.saveCoreData()
                auxiliaryTools.addDayPoint(numberLearnedWords: 1, numberRepeatedWords: 1, progressCount: 1)
//                wordData.remove(at: i)
                temporaryWordData[i].identifierInTeachEvent = true
            }else{
                errorWordList.append(temporaryWordData[i])
            }
        }
        
        wordData = errorWordList
        errorWordList.removeAll()
        if(wordData.count>0){
        for i in 0...wordData.count - 1{
            wordData[i].identifierInTeachEvent = true
        }
        }
        updateBreakWords(words: temporaryWordData)
        auxiliaryTools.addProgressPoint()
    }
    
    
    func updateBreakWords(words:[Word]){
        for word in words{
            word.willChangeValue(forKey: "repeatDate")
            word.setPrimitiveValue(DateManager.getModifiedByHourDate(hour: 24), forKey: "repeatDate")
            word.didChangeValue(forKey: "repeatDate")
            word.willChangeValue(forKey: "breakIndicator")
            word.setPrimitiveValue(false, forKey: "breakIndicator")
            word.didChangeValue(forKey: "breakIndicator")
            auxiliaryTools.saveCoreData()
        } 
    }
    }
    



