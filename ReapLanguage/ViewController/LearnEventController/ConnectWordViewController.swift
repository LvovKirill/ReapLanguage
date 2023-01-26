import UIKit
import CoreData

class ConnectWordViewController: UIViewController {
    
    @IBOutlet var baseWordCollection: [UIButton]!
    @IBOutlet var targetWordCollection: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Collection", in: context)
        let newCollection = Collection(entity: entity!, insertInto: context)
//        let newCollection = Collection(i)

        newCollection.id = 1
        newCollection.nameCollection = "l"
        newCollection.emoji = "📗"
        newCollection.customType = true

        do{
            try
            context.save()
        }catch{
            print("context save error")
        }

    }
    
    private func setupScreen(){
        
    }
    
    
    @IBAction func targetWordClick(_ sender: Any) {
    }
    

    @IBAction func baseWordClick(_ sender: Any) {
    }
    
    
}
