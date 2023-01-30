import UIKit
import NotificationCenter
import CoreData
import SwiftUI

var collectionList = [Collection]()


class CollectionTableView: UITableViewController {

    var firstLoad = true
    @IBOutlet var collectionTableView: UITableView!
    
    
    override func viewDidLoad() {
        
        BuiltInCollections.builtInCollectionsList()
        
        self.tableView.rowHeight = 45.0
        if(firstLoad){
            firstLoad = false
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Collection")
            do{
                let results: NSArray = try context.fetch(request) as NSArray
                for result in results {
                    let collection = result as! Collection
                    collectionList.append(collection)
                }
            }catch{
                print("Fetch Failed")
            }
            
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCollectionData), name: Notification.Name("reloadCollectionData"), object: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let collectionCell = tableView.dequeueReusableCell(withIdentifier: "collectionCellID", for: indexPath) as! CollectionCell
        collectionCell.collectionPlay.addTarget( self , action: #selector (showPlayAlertActionSheet), for: .touchUpInside)
        if(indexPath.section == 0){
            collectionCell.collectionPlay.tag = indexPath.row
        }else{
            collectionCell.collectionPlay.tag = auxiliaryTools.getCollectionListByCustomType(customType: true).count + indexPath.row
        }
        
        let thisCollection:Collection!
        if(indexPath.section == 0){
            thisCollection = auxiliaryTools.getCollectionListByCustomType(customType: true)[indexPath.row]
        }else{
            thisCollection = auxiliaryTools.getCollectionListByCustomType(customType: false)[indexPath.row]
        }
        
        collectionCell.collectionName.text = thisCollection.nameCollection
        collectionCell.emoji.text = thisCollection.emoji
        
        let allWords = auxiliaryTools.getWordByCollectionId(collectionID: thisCollection.id, type: "all")
        let forTeachEventWords = auxiliaryTools.getWordByCollectionId(collectionID: thisCollection.id, type: "forTeachEvent")
        let newWords = auxiliaryTools.getWordByCollectionId(collectionID: thisCollection.id, type: "onlyNew")
        
        collectionCell.numberNotLearnedWords.layer.masksToBounds = true
        collectionCell.numberNotLearnedWords.layer.cornerRadius = 8
        collectionCell.numberNotLearnedWords.text = String(forTeachEventWords.count)
        
        collectionCell.numberAllWords.layer.masksToBounds = true
        collectionCell.numberAllWords.layer.cornerRadius = 8
        collectionCell.numberAllWords.text = String(allWords.count)
        
        collectionCell.numberAllWords.alpha = 1
        collectionCell.numberAllWords.isEnabled = true
        
        collectionCell.numberNotLearnedWords.alpha = 1
        collectionCell.numberNotLearnedWords.isEnabled = true
        
        if(newWords.count == allWords.count || forTeachEventWords.count == 0){
            collectionCell.numberNotLearnedWords.alpha = 0
            collectionCell.numberNotLearnedWords.isEnabled = false
        }
        
        if(allWords.count == 0){
            collectionCell.numberAllWords.alpha = 0
            collectionCell.numberAllWords.isEnabled = false
        }
        
        collectionCell.collectionPlay.setTitle("", for: .normal)

        return collectionCell
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0){
            return auxiliaryTools.getCollectionListByCustomType(customType: true).count
        }else{
            return auxiliaryTools.getCollectionListByCustomType(customType: false).count
        }
    }
    

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0){
                return "МОИ КОЛЛЕКЦИИ"
        }else if (section == 1){
                return "ПО ТЕМАМ"
        }
            return nil
    }
    
    

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "GoToWordViewController") as? WordTableView
        if(indexPath.section == 0){
            vc?.name = auxiliaryTools.getCollectionListByCustomType(customType: true)[indexPath.row].nameCollection
            vc?.collectionID = auxiliaryTools.getCollectionListByCustomType(customType: true)[indexPath.row].id
        }else{
            vc?.name = auxiliaryTools.getCollectionListByCustomType(customType: false)[indexPath.row].nameCollection
            vc?.collectionID = auxiliaryTools.getCollectionListByCustomType(customType: false)[indexPath.row].id
        }
               navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if(indexPath.section == 0){
            let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            let context:NSManagedObjectContext = appDel.persistentContainer.viewContext
            let collection = auxiliaryTools.getCollectionListByCustomType(customType: true)[indexPath.row]
            let words = auxiliaryTools.getWordByCollectionId(collectionID: collection.id, type: "all")
            
            for word in words{
                context.delete(word)
            }
                context.delete(collection)
            do {
                try context.save()
            }catch{}
            
        }
        tableView.reloadData()
    }
    
    

    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    
    @objc func reloadCollectionData(notification: NSNotification){
        collectionList = auxiliaryTools.getCollectionListByCustomType(customType: true) + auxiliaryTools.getCollectionListByCustomType(customType: false)
        tableView.reloadData()
    }
    
    @objc private func showPlayAlertActionSheet(_ button: CollectionCellUIButton) {
        collectionList = auxiliaryTools.getCollectionListByCustomType(customType: true) + auxiliaryTools.getCollectionListByCustomType(customType: false)
        
        let alert = UIAlertController(title: "Что вы хотите сделать?", message: nil, preferredStyle: .actionSheet)
        let teach = UIAlertAction(title: "Учить", style: .default){_ in
            
            if(auxiliaryTools.getWordByCollectionId(collectionID: collectionList[button.tag].id, type: "forTeachEvent").count == 0){
                let alert = auxiliaryTools.getInfoAlert(title: "Внимание", message: "В этой коллекции отсутствуют слова, доступные для изучения")
                self.present(alert, animated: true, completion: nil)
            }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "GoToTeachEventViewController") as? TeachEventViewController
            vc?.collectionID = collectionList[button.tag].id
            vc?.thisEventViewController = vc
            self.navigationController?.pushViewController(vc!, animated: true)
            }
            
        }
        let repetition = UIAlertAction(title: "Повторить", style: .default){_ in
            self.showRepeatAlertSheetAction(self, button: button)
        }
        let repetitionLearned = UIAlertAction(title: "Повторить выученные слова", style: .default){_ in }
        let review = UIAlertAction(title: "Обзор слов", style: .default){_ in }
        let playback = UIAlertAction(title: "Автопроигрывание", style: .default){_ in }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        alert.addAction(teach)
        alert.addAction(repetition)
        alert.addAction(repetitionLearned)
        alert.addAction(review)
        alert.addAction(playback)
        alert.addAction(cancelAction)
        
        if let popover = alert.popoverPresentationController{
            popover.sourceView = self.view
            popover.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = UIPopoverArrowDirection.init(rawValue: 0)
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    


    
    @objc private func showRepeatAlertSheetAction(_ sender: Any, button: CollectionCellUIButton) {
        let buttonTag = button.tag
        
        let alert = UIAlertController(title: "Что вы хотите сделать?", message: nil, preferredStyle: .actionSheet)
        let teach = UIAlertAction(title: "Смешанный", style: .default){_ in}
        let pairConnection = UIAlertAction(title: "Соеденить пары", style: .default){_ in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "GoToPairConnectionViewController") as? PairConnectionViewController
            vc?.words = auxiliaryTools.getWordByCollectionId(collectionID: collectionList[buttonTag].id, type: "all")
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        let chooseRightWord = UIAlertAction(title: "Выбрать", style: .default){_ in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "GoToChooseRightWordViewController") as? ChooseRightWordViewController
            vc?.words = auxiliaryTools.getWordByCollectionId(collectionID: collectionList[buttonTag].id, type: "all")
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        let writeWord = UIAlertAction(title: "Написать", style: .default){_ in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "GoToWriteWordViewController") as? WriteWordViewController
            vc?.words = auxiliaryTools.getWordByCollectionId(collectionID: collectionList[buttonTag].id, type: "all")
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        let teachWord = UIAlertAction(title: "Вспомнить", style: .default){_ in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "GoToTeachWordViewController") as? TeachWordViewController
            vc?.words = auxiliaryTools.getWordByCollectionId(collectionID: collectionList[buttonTag].id, type: "all")
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        alert.addAction(teach)
        alert.addAction(pairConnection)
        alert.addAction(chooseRightWord)
        alert.addAction(writeWord)
        alert.addAction(teachWord)
        alert.addAction(cancelAction)
        
        if let popover = alert.popoverPresentationController{
            popover.sourceView = self.view
            popover.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = UIPopoverArrowDirection.init(rawValue: 0)
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        auxiliaryTools.reloadBreakIndicator()
    }
    
    
}




extension CollectionTableView {
    
        var parentController: UIViewController? {
            var parentResponder: UIResponder? = self
            
            while parentResponder != nil {
                parentResponder = parentResponder!.next
                
                if let viewController = parentResponder as? UIViewController {
                    return viewController
                }
            }
            return nil
        }
    }

extension UITableView {
//    func addCorner(){
//        self.layer.cornerRadius = 15
//        self.clipsToBounds = true
//    }
//
//    func addShadow(){
//        self.layer.shadowColor = UIColor.lightGray.cgColor
//        self.layer.shadowRadius = 5
//        self.layer.shadowOpacity = 0.5
//        self.layer.shadowOffset = .zero
//        self.layer.masksToBounds = false
//    }
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
         let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
         let mask = CAShapeLayer()
         mask.path = path.cgPath
         layer.mask = mask
     }
}



