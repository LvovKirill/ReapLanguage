import UIKit
import CloudKit

class PairConnectionViewController: UIViewController {
    
    @IBOutlet var targetWords: [UIButton]!
    @IBOutlet var baseWords: [UIButton]!

    
    var PCE:PairConnectionEvent!
    var teachEventViewController:TeachEventViewController!
    var words:[Word]=[]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for index in 0...4{
            targetWords[index].layer.cornerRadius = 5
            targetWords[index].tintColor = UIColor(white: 1, alpha: 0)
            targetWords[index].layer.masksToBounds = true
            baseWords[index].layer.cornerRadius = 5
            baseWords[index].tintColor = UIColor(white: 1, alpha: 0)
            baseWords[index].layer.masksToBounds = true
        }
        
        if(teachEventViewController != nil){
            PCE = PairConnectionEvent(wordData: words, teachEvent: teachEventViewController.teachEvent)
        }else{
            PCE = PairConnectionEvent(wordData: words)
        }
        
        loadWords()
    }
    
    @objc func loadWords(){
        
        for index in 0...4{
            targetWords[index].backgroundColor = .systemBlue
            baseWords[index].backgroundColor = .systemBlue
         
        }
        
        for targetWord in targetWords {
            targetWord.isEnabled = true
            targetWord.alpha = 1
        }
        
        for baseWord in baseWords {
            baseWord.isEnabled = true
            baseWord.alpha = 1
        }
        
            PCE.getSetWords()

        for index in PCE.baseWords.indices{
            baseWords[index].setTitle(PCE.baseWords[index], for: .normal)
        }
        
        for index in PCE.targetWords.indices{
            targetWords[index].setTitle(PCE.targetWords[index], for: .normal)
        }
        
        if(PCE.baseWords.count<5){
            let n = PCE.baseWords.count
            
            for i in n...4{
                targetWords[i].alpha = 0
                targetWords[i].isEnabled = false
                baseWords[i].alpha = 0
                baseWords[i].isEnabled = false
            }
        }
        

    }
    
    
    @IBAction func pressBaseWord(_ sender: UIButton) {
        guard let buttonIndex = baseWords.firstIndex(of: sender) else {return}
        resetUI()
        baseWords[buttonIndex].backgroundColor = .systemGray4
        PCE.checkBaseWord(index: buttonIndex)
        
        animatePair()
        
    }
    
    @IBAction func pressTargetWord(_ sender: UIButton) {
        guard let buttonIndex = targetWords.firstIndex(of: sender) else {return}
        resetUI()
        targetWords[buttonIndex].backgroundColor = .systemGray4
        PCE.checkTargetWord(index: buttonIndex)

        animatePair()

        
    }
    
    private func animatePair(){
        
        if PCE.isFound == .right {
            
            self.targetWords[self.PCE.currentTargetWord].backgroundColor = .green
            self.baseWords[self.PCE.currentBaseWord].backgroundColor = .green
            
            
            UIView.animate(withDuration: 0.5){
                self.targetWords[self.PCE.currentTargetWord].alpha = 0
                self.targetWords[self.PCE.currentTargetWord].isEnabled = false
                self.baseWords[self.PCE.currentBaseWord].alpha = 0
                self.baseWords[self.PCE.currentBaseWord].isEnabled = false
            }
            
            PCE.currentBaseWord = -1
            PCE.currentTargetWord = -1
            
            
          
            
            if PCE.words.count == 0 && PCE.statusPairConnectionEvent{
                loadWords()
            }
            
            if(!(PCE.checkAvailabilityWord())){
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if(self.teachEventViewController != nil){
                        self.teachEventViewController.newEvent()
                }else{
                    self.navigationController!.popViewController(animated: true)
                }
                }
            }
            
            
            
        }else if PCE.isFound == .error{
            
            var indexTarget = self.PCE.currentTargetWord
            var indexBase = self.PCE.currentBaseWord
            
            
            UIView.animate(withDuration: 0){
                self.targetWords[indexTarget].backgroundColor = .red
                self.baseWords[indexBase].backgroundColor = .red
            }completion: { _ in
                UIView.animate(withDuration: 1) {
                self.targetWords[indexTarget].backgroundColor = .systemBlue
                self.baseWords[indexBase].backgroundColor = .systemBlue
                }
            }
            PCE.currentBaseWord = -1
            PCE.currentTargetWord = -1
        }
        
        
    }
    
    
    private func resetUI(){
        
        
        for index in baseWords.indices{
            baseWords[index].backgroundColor = .systemBlue
        }
        
        for index in targetWords.indices{
            targetWords[index].backgroundColor = .systemBlue
        }
        
    }
    
    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    

    
    

}
