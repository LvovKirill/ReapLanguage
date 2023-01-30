//
//  ChooseRightWordViewController.swift
//  FastEnglish
//
//  Created by Kirill on 22.06.2022.
//

import UIKit

class ChooseRightWordViewController: UIViewController {
    @IBOutlet var buttonCollection: [UIButton]!
    
    @IBOutlet weak var label: UILabel!
    
    var CRWE:ChooseRightWordEvent!
    var teachEventViewController:TeachEventViewController!
    var words:[Word]=[]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(teachEventViewController != nil){
            CRWE = ChooseRightWordEvent(wordData: words, teachEvent: teachEventViewController.teachEvent)
        }else{
            CRWE = ChooseRightWordEvent(wordData: words)
        }

        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        for index in 0...4{
            buttonCollection[index].layer.cornerRadius = 5
            buttonCollection[index].tintColor = UIColor(white: 1, alpha: 0)
            buttonCollection[index].layer.masksToBounds = true
        }
        
        newWord()

    }
    
    func newWord(){
        CRWE.getWord()

        label.text = CRWE.currentWord.targetWord
        
        for index in 0...CRWE.selectableWords.count-1{
            buttonCollection[index].setTitle(CRWE.selectableWords[index].baseWord, for: .normal)
        }
        
        if(CRWE.selectableWords.count<5){
            let n = CRWE.selectableWords.count
            
            for i in n...4{
                buttonCollection[i].alpha = 0
                buttonCollection[i].isEnabled = false
            }
        }
        
        
    }
    
    @IBAction func pressAction(_ sender: UIButton) {
        guard let buttonIndex = buttonCollection.firstIndex(of: sender) else {return}
        
        if (CRWE.check(word: CRWE.selectableWords[buttonIndex])){

                self.buttonCollection[buttonIndex].backgroundColor = .systemGreen
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if(self.CRWE.checkAvailabilityWord()){
                self.newWord()
            }else{
                if (self.teachEventViewController != nil){
                    self.teachEventViewController.newEvent()
                }else{
                    self.navigationController!.popViewController(animated: true)
                }
            }
                self.buttonCollection[buttonIndex].backgroundColor = .systemBlue
            }
            
            
            
            


        }else if (CRWE.selectableWords[buttonIndex] != CRWE.currentWord){
            

            var animator: UIViewPropertyAnimator!
            
            UIView.animate(withDuration: 0){
                self.buttonCollection[buttonIndex].backgroundColor = .systemRed
            }completion: { _ in
            UIView.animate(withDuration: 2) {
                self.buttonCollection[buttonIndex].backgroundColor = .systemBlue
                }
            }
            
        }
    

        
    }
    
    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
    
}
