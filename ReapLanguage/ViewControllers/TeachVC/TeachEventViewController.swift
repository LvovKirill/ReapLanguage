//
//  TeachEventViewController.swift
//  FastEnglish
//
//  Created by Kirill on 22.06.2022.
//

import UIKit

class TeachEventViewController: UIViewController {
    
    @IBOutlet weak var container: UIView!
    var collectionID:NSNumber!
    var teachEvent:TeachEvent!
    var thisEventViewController:TeachEventViewController!
    var numberEvent=0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var allWordData = auxiliaryTools.getWordByCollectionId(collectionID: collectionID,  type: "forTeachEvent").shuffled()
        var wordData:[Word] = []
        if(allWordData.count > 5){
        for i in 0...5{
            wordData.append(allWordData[i])
        }
        }else{wordData = allWordData}
        teachEvent = TeachEvent(wordData: wordData, appDelegate: UIApplication.shared.delegate as! AppDelegate, errorType: false)
        
   
    newEvent()

    
        
    }
    
    
    func newEvent(){
        numberEvent+=1
        
        if (numberEvent == 5){
            teachEvent.completeTeachEvent()
            if (teachEvent.wordData.count != 0){
                numberEvent = 2
            }
        }
        
        
        switch numberEvent{
        case 1:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "GoToTeachWordViewController") as? TeachWordViewController
            vc?.words = teachEvent.wordData
            vc?.teachEventViewController = thisEventViewController
            self.addChild(vc!)
            vc!.view.frame = CGRect(x: 0, y: 0, width: self.container.frame.size.width, height: self.container.frame.size.height)
            self.container.addSubview(vc!.view)
            vc!.didMove(toParent: self)
        case 2:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "GoToPairConnectionViewController") as? PairConnectionViewController
            vc?.words = teachEvent.wordData
            vc?.teachEventViewController = thisEventViewController
            self.addChild(vc!)
            vc!.view.frame = CGRect(x: 0, y: 0, width: self.container.frame.size.width, height: self.container.frame.size.height)
            self.container.addSubview(vc!.view)
            vc!.didMove(toParent: self)
        case 3:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "GoToChooseRightWordViewController") as? ChooseRightWordViewController
            vc?.words = teachEvent.wordData
            vc?.teachEventViewController = thisEventViewController
            self.addChild(vc!)
            vc!.view.frame = CGRect(x: 0, y: 0, width: self.container.frame.size.width, height: self.container.frame.size.height)
            self.container.addSubview(vc!.view)
            vc!.didMove(toParent: self)
        case 4:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "GoToWriteWordViewController") as? WriteWordViewController
            vc?.words = teachEvent.wordData
            vc?.teachEventViewController = thisEventViewController
            self.addChild(vc!)
            vc!.view.frame = CGRect(x: 0, y: 0, width: self.container.frame.size.width, height: self.container.frame.size.height)
            self.container.addSubview(vc!.view)
            vc!.didMove(toParent: self)
        default:
            navigationController!.popViewController(animated: true)
        }
    }
    


}
