import Foundation
import CoreData
import AudioToolbox



class PairConnectionEvent{
    
    enum StatusPair{
        case right
        case error
        case empty
        }
    
    
    
    var statusPairConnectionEvent:Bool=true
    var targetWords:[String] = []
    var baseWords:[String] = []
    var words:[Word]=[]
    private var wordData:[Word]=[]
    var teachEvent:TeachEvent!

        var currentBaseWord = -1
        var currentTargetWord = -1
        var isFound:StatusPair = .empty
    
    init(wordData: Array<Word>, teachEvent: TeachEvent){
        self.wordData = wordData
        self.teachEvent = teachEvent
    }
    
    init(wordData: Array<Word>){
        self.wordData = wordData
    }
    
    
    
    func checkTargetWord(index:Int) {
            currentTargetWord = index
            checkPair()
        }

    func checkBaseWord(index:Int) {
            currentBaseWord = index
            checkPair()
        }
    
    func checkPair(){
        
        
        if currentTargetWord == -1 || currentBaseWord == -1{
            isFound = .empty
        }else if targetWords[currentTargetWord] == auxiliaryTools.meaningByKey(value: baseWords[currentBaseWord], wordData: words) {
            isFound = .right
            auxiliaryTools.makeSpeech(text: targetWords[currentTargetWord], targetLanguage: true)
            words.remove(at: auxiliaryTools.getIndexByKey(value: baseWords[currentBaseWord], wordData: words))
            if wordData.count == 0 {
                statusPairConnectionEvent = false
            }

        }else if targetWords[currentTargetWord] != auxiliaryTools.meaningByKey(value: baseWords[currentBaseWord], wordData: words){
            if(teachEvent != nil){
                teachEvent.wordData[auxiliaryTools.getIndexByKey(value: targetWords[currentTargetWord], wordData: teachEvent.wordData)]
                .identifierInTeachEvent = false
            }
            
            let word = auxiliaryTools.objectByKey(value: targetWords[currentTargetWord], wordData: words)
            
            var newNumberCorrectRepetitions = Int(truncating: word.numberCorrectRepetitions) - Int(Settings.numberRepetitions/3)
            if (newNumberCorrectRepetitions<0){
                newNumberCorrectRepetitions = 0
            }
            
            word.willChangeValue(forKey: "numberCorrectRepetitions")
            word.setPrimitiveValue(newNumberCorrectRepetitions as NSNumber, forKey: "numberCorrectRepetitions")
            word.didChangeValue(forKey: "numberCorrectRepetitions")
            auxiliaryTools.saveCoreData()
            isFound = .error
        }
        
        
    }
    
    
    func checkAvailabilityWord() -> Bool{
        
        if(words.count==0){
            return false
        }else{
            return true
        }
        
    }
    
    
    
    func getSetWords(){
        
        
        baseWords.removeAll()
        targetWords.removeAll()
        words.removeAll()
        isFound = .empty
        currentBaseWord = -1
        currentTargetWord = -1
        
        if(wordData.count>=5){
            for _ in 1...5{
                words.append(wordData[0])
            wordData.remove(at: 0)
        }
        }else{
                for _ in 1...wordData.count{
                if let myWordData = wordData.first{
                words.append(myWordData)
                }
                wordData.remove(at: 0)
            }
        }
        
        for index in 1...words.count{
            baseWords.append(words[index-1].baseWord)
            targetWords.append(words[index-1].targetWord)
        }
        
        baseWords.shuffle()
        targetWords.shuffle()
    }
    
    
}
