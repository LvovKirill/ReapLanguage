import Foundation

class TeachWordEvent{
    
    private var wordData:[Word]=[]
    
    init(wordData: Array<Word>){
        self.wordData = wordData
    }
    
    func getWord() -> Word{
        wordData.shuffle()
        let word=wordData[0]
        wordData.remove(at: 0)
        auxiliaryTools.makeSpeech(text: word.targetWord, targetLanguage: true)
        return word

    }
    
    func checkAvailabilityWord() -> Bool{
        if(wordData.count==0){
            return false
        }else{
            return true
        }
    }
    
}
