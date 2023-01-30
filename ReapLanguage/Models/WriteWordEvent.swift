import Foundation
    
    
class WriteWordEvent{
        
        private var wordData:[Word]=[]
        var word:Word!
        var teachEvent:TeachEvent!
        
        init(wordData: Array<Word>, teachEvent: TeachEvent){
            self.wordData = wordData
            self.teachEvent = teachEvent
        }
    
    init(wordData: Array<Word>){
        self.wordData = wordData
    }
        
        func getWord(){
            wordData.shuffle()
            let word=wordData[0]
            wordData.remove(at: 0)
            self.word=word
        }
    
    func check(text: String) -> Bool{
        if (word.targetWord == text){
            auxiliaryTools.makeSpeech(text: word.targetWord, targetLanguage: true)
            return true
        }else{
            if(teachEvent != nil){
            teachEvent.wordData[auxiliaryTools.getIndexByKey(value: word.targetWord, wordData: teachEvent.wordData)]
                .identifierInTeachEvent = false
            }
            
            var newNumberCorrectRepetitions = Int(truncating: word.numberCorrectRepetitions) - Int(Settings.numberRepetitions/3)
            if (newNumberCorrectRepetitions<0){
                newNumberCorrectRepetitions = 0
            }
            word.willChangeValue(forKey: "numberCorrectRepetitions")
            word.setPrimitiveValue(newNumberCorrectRepetitions as NSNumber, forKey: "numberCorrectRepetitions")
            word.didChangeValue(forKey: "numberCorrectRepetitions")
            auxiliaryTools.saveCoreData()
            
            return false
        }
    }
    
    func help(){
        
        auxiliaryTools.makeSpeech(text: word.targetWord, targetLanguage: true)
        
        if(teachEvent != nil){
        teachEvent.wordData[auxiliaryTools.getIndexByKey(value: word.targetWord, wordData: teachEvent.wordData)]
            .identifierInTeachEvent = false
        }
        
        var newNumberCorrectRepetitions = Int(truncating: word.numberCorrectRepetitions) - Int(Settings.numberRepetitions/3)
        if (newNumberCorrectRepetitions<0){
            newNumberCorrectRepetitions = 0
        }
        word.willChangeValue(forKey: "numberCorrectRepetitions")
        word.setPrimitiveValue(newNumberCorrectRepetitions as NSNumber, forKey: "numberCorrectRepetitions")
        word.didChangeValue(forKey: "numberCorrectRepetitions")
        auxiliaryTools.saveCoreData()
        
    }
        
        func checkAvailabilityWord() -> Bool{
            if(wordData.count==0){
                return false
            }else{
                return true
            }
        }
    
        
        
    }
