//
//  TeachWordViewController.swift
//  FastEnglish
//
//  Created by Kirill on 23.06.2022.
//

import UIKit

class TeachWordViewController: UIViewController {
    
    @IBOutlet weak var targetWord: UILabel!
    @IBOutlet weak var baseWord: UILabel!
    
    var TWE:TeachWordEvent!
    var teachEventViewController:TeachEventViewController!
    var words:[Word]=[]


    override func viewDidLoad() {
        super.viewDidLoad()
        TWE = TeachWordEvent(wordData: words)
        updateWord()
    }
    
    func updateWord(){
        var word = TWE.getWord()
        
        UIView.animate(withDuration: 0.1,
            animations: {
            self.targetWord.transform = CGAffineTransform()
                self.baseWord.transform = CGAffineTransform()
            },
            completion: { _ in
                UIView.animate(withDuration: 0.3) {
                    self.targetWord.text = word.targetWord
                    self.baseWord.text = word.baseWord
                    self.targetWord.transform = CGAffineTransform.identity
                    self.baseWord.transform = CGAffineTransform.identity
                }
            })
    }
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        if(TWE.checkAvailabilityWord()){
            updateWord()
        }else{
            teachEventViewController.newEvent()
        }
        
        
    }
    
}
