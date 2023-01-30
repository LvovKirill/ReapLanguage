import UIKit
import CoreData

class CreateCollectionViewController: UIViewController {

    @IBOutlet weak var collectionNameTF: UITextField!
    @IBOutlet weak var emojiImageView: UIImageView!
    
    var emoji: UIImage!
    var strEmoji: String! = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        var s = "128512"
//        emojiImageView.image = UTF8(s).image()
        
        
    }
    

    
    @IBAction func createAction(_ sender: UIButton) {

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Collection", in: context)
        let newCollection = Collection(entity: entity! , insertInto: context)

        newCollection.id = IdGenerator.getNewId()
        newCollection.nameCollection = collectionNameTF.text
        if strEmoji != ""{
            newCollection.emoji = strEmoji
        }else{
        newCollection.emoji = "📗"
        }
        newCollection.customType = true

        do{
            try context.save()
            collectionList.append(newCollection)
            navigationController?.popViewController(animated: true)
        }catch{
            print("context save error")
        }

        NotificationCenter.default.post(name: Notification.Name("reloadCollectionData"), object: nil)
        self.viewDidAppear(true)
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func pickEmojiAction(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GoToEmojiPikerCollectionViewController") as? EmojiPikerCollectionViewController
        vc?.CCVC = self
        
     
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func cancelVC(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
}
