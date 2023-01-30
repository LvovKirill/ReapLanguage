//
//  ChooseRightWordEvent.swift
//  FastEnglish
//
//  Created by Kirill on 23.06.2022.
//

import Foundation

class ChooseRightWordEvent{
    
    private var wordData:[Word]=[]
    var chooseWordData:[Word]=[]
    var selectableWords:[Word]=[]
    var currentWord:Word!
    private var teachEvent:TeachEvent!
    
    
    init(wordData: Array<Word>, teachEvent: TeachEvent){
        self.wordData = wordData
        self.chooseWordData = wordData
        self.teachEvent = teachEvent
    }
    
    init(wordData: Array<Word>){
        self.wordData = wordData
        self.chooseWordData = wordData
    }
    
    
    func getWord(){
        var wrongSet=true
        wordData.shuffle()
        chooseWordData.shuffle()
        
        currentWord=wordData[0]
        wordData.remove(at: 0)
        
        while wrongSet{
            selectableWords.removeAll()
            chooseWordData.shuffle()
            var wordDataCount=0
            if(chooseWordData.count>=5){
                wordDataCount = 3
            }else{
                wordDataCount = chooseWordData.count-2
            }
        
            if (wordDataCount > 0){
        for index in 0...wordDataCount{
            selectableWords.append(chooseWordData[index])
        }
            
        for index in 0...wordDataCount{
            if (selectableWords[index]==currentWord){
            wrongSet=true
            break
            }
                wrongSet=false
            }
            }else{ wrongSet=false }
        
        }
        
        selectableWords.append(currentWord)
        selectableWords.shuffle()
        
        
    
    }
    
    func check(word:Word) -> Bool{
        print("Количество: ")
        print(wordData.count)
        if(word == currentWord){
            auxiliaryTools.makeSpeech(text: word.targetWord, targetLanguage: true)
            return true
        }else {
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
            
            return false }
        
    }
    
    func checkAvailabilityWord() -> Bool{
        if(wordData.count == 0){
            return false
        }else{
            return true
        }
    }
    

    
    
    
    
    
}
