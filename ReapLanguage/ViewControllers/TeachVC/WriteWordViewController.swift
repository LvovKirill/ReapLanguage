//
//  WriteWordViewController.swift
//  FastEnglish
//
//  Created by Kirill on 23.06.2022.
//

import UIKit

class WriteWordViewController: UIViewController {
    
    @IBOutlet weak var knownWord: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var textFieldUpValue: Bool = false
    var textFieldDownValue: Bool = false
    
    var TWE:WriteWordViewController!
    var teachEventViewController:TeachEventViewController!
    var words:[Word]=[]
    var WWE:WriteWordEvent!

    override func viewDidLoad() {
        super.viewDidLoad()
        if(teachEventViewController != nil){
            WWE = WriteWordEvent(wordData: words, teachEvent: teachEventViewController.teachEvent)
        }else{
            WWE = WriteWordEvent(wordData: words)
        }
        updateWord()
        
        textField.addTarget(self, action: #selector(textFieldDidBeginEditing), for: .touchDown)

    }
    
    
    func updateWord(){
        WWE.getWord()
        knownWord.text = WWE.word.baseWord
        textField.text = ""
        textField.textColor = UIColor.black
        self.textField.backgroundColor = UIColor(white: 1, alpha: 0)
    }

    @IBAction func helpAction(_ sender: UIButton) {
        textField.text = WWE.word.targetWord
        self.textField.backgroundColor = UIColor.red
        self.textField.textColor = UIColor.white
        WWE.help()
        delayWithSeconds(1){
            self.updateWord()
            self.textField.textColor = UIColor.black
        }
        
        if(self.view.frame.origin.y == -220){
            textFieldDown()
        }
        textField.resignFirstResponder()
        
    }
    
    
    
    @IBAction func checkAction(_ sender: UIButton) {
        if(WWE.check(text: textField.text!)){
            self.textField.backgroundColor = UIColor.systemGreen
            self.textField.textColor = UIColor.white
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if(self.WWE.checkAvailabilityWord()){
                self.updateWord()
            }else{
                self.teachEventViewController.newEvent()
            }
            }
            
        }else if(!(WWE.check(text: textField.text!))){
            
            let changeColor = CATransition()
            changeColor.type = .fade
            changeColor.duration = 0.3
            
            CATransaction.setCompletionBlock{
                    self.textField.backgroundColor = UIColor(white: 1, alpha: 0)
                    self.textField.layer.add(changeColor, forKey: nil)
                }
            self.textField.backgroundColor = UIColor.systemRed
            self.textField.textColor = UIColor.white
            self.textField.layer.add(changeColor, forKey: nil)
            CATransaction.commit()
            
        }
        
        if(self.view.frame.origin.y == -220){
            textFieldDown()
        }
        textField.resignFirstResponder()
        delayWithSeconds(0.3){
            self.textField.textColor = UIColor.black
        }
        
    }
    
    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
    @objc func textFieldDidBeginEditing(_ textField: UITextField) {
        if(self.view.frame.origin.y == 0){
            textFieldUp()
        }
    }
    
    func textFieldUp(){
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame = CGRect(x:self.view.frame.origin.x, y:self.view.frame.origin.y - 220, width:self.view.frame.size.width, height:self.view.frame.size.height);

        })
    }
    
    func textFieldDown(){
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame = CGRect(x:self.view.frame.origin.x, y:self.view.frame.origin.y + 220, width:self.view.frame.size.width, height:self.view.frame.size.height);

        })
    }
    
}
