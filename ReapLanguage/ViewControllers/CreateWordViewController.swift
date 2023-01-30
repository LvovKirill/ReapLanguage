import UIKit
import CoreData

class CreateWordViewController: UIViewController {

    @IBOutlet weak var targetWordTF: UITextField!
    @IBOutlet weak var baseWordTF: UITextField!
    
    var collectionID:NSNumber!
    var wordTableView:WordTableView!
    var parentCollection = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func createAction(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Word", in: context)
        
        let newWord = Word(entity: entity! , insertInto: context)
        
        newWord.id = IdGenerator.getNewId()
        newWord.collectionID = collectionID as NSNumber
        newWord.baseWord = baseWordTF.text
        newWord.targetWord = targetWordTF.text
        newWord.numberCorrectRepetitions = 0
        newWord.parentCollection = parentCollection as NSNumber
        newWord.breakIndicator = true
        
        do{
            try context.save()
            wordList.append(newWord)
            navigationController?.popViewController(animated: true)
        }catch{
            print("context save error")
        }
        NotificationCenter.default.post(name: Notification.Name("reloadCollectionData"), object: nil)
        self.viewDidAppear(true)
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func createMoreAction(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Word", in: context)
        let newWord = Word(entity: entity! , insertInto: context)
        newWord.id = IdGenerator.getNewId()
        newWord.collectionID = collectionID as NSNumber
        newWord.baseWord = baseWordTF.text
        newWord.targetWord = targetWordTF.text
        newWord.numberCorrectRepetitions = 0
        newWord.parentCollection = parentCollection as NSNumber
        do{
            try context.save()
            wordList.append(newWord)
            navigationController?.popViewController(animated: true)
        }catch{
            print("context save error")
        }
        
        dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: Notification.Name("reloadCollectionData"), object: nil)
        self.viewDidAppear(true)
        wordTableView.create()
        
    }
    
    
    @IBAction func generateWordAction(_ sender: UIButton){
        let list = auxiliaryTools.getCollectionListByCustomType(customType: false)
        let collection = list[Int.random(in: 0...list.count-1)]
        let words = auxiliaryTools.getWordByCollectionId(collectionID: collection.id, type: "onlyNew")
        let word = words[Int.random(in: 0...words.count-1)]
        
        targetWordTF.text = word.targetWord
        baseWordTF.text = word.baseWord
        parentCollection = Int(truncating: collection.id)
        
    }
    
    @IBAction func cancelVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    
}
