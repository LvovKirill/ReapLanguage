import UIKit
import NotificationCenter
import CoreData



var wordList = [Word]()

class WordTableView: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    

    @IBOutlet weak var createWordButton: UIBarButtonItem!
    
    var firstLoad = true
    
    
    var name = ""
    var collectionID:NSNumber!
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let wordCell = tableView.dequeueReusableCell(withIdentifier: "wordCellID", for: indexPath) as! WordCell
        
        let thisWord: Word!
        
        if(wordList.count != 0){
        thisWord = wordList[indexPath.row]
        wordCell.baseWord.text = thisWord.baseWord
        wordCell.targetWord.text = thisWord.targetWord
        wordCell.repetitionIndicator.progress = Float(truncating: thisWord.numberCorrectRepetitions) / Float(Settings.numberRepetitions)
            print(thisWord.numberCorrectRepetitions)
        wordCell.repetitionIndicator.progressTintColor = getProgressColor(progress: Float(truncating: thisWord.numberCorrectRepetitions) / Float(Settings.numberRepetitions))
        if(thisWord.breakIndicator == false){
            let date = DateManager.getCurrentDate()
            let dateThisWord = DateManager.getDateComponents(date: thisWord.repeatDate)
            let hour = (dateThisWord.hour! + dateThisWord.day! * 24) - (date.hour! + date.day! * 24)
            wordCell.timeIndicator.text = String(hour) + " ч"
        }else{
            wordCell.timeIndicator.alpha = 0
            wordCell.timeIndicator.isEnabled = false
            }
        }
        
        return wordCell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordList.count
    }
    

    
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//
//
//        let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
//                let context:NSManagedObjectContext = appDel.persistentContainer.viewContext
//                context.delete(wordList[indexPath.row] )
//                wordList.remove(at: indexPath.row)
//
//                do {
//                    try context.save()
//                }catch{}
//
//        tableView.reloadData()
//
//
//    }
    

    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        
        
            let action1 = UIContextualAction(style: .normal, title: "Удалить", handler: { [weak self] (action, view, block) in
                        let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
                                let context:NSManagedObjectContext = appDel.persistentContainer.viewContext
                                context.delete(wordList[indexPath.row] )
                                wordList.remove(at: indexPath.row)
                
                                do {
                                    try context.save()
                                }catch{}
                
                        tableView.reloadData()
            })
            action1.backgroundColor = .red
            action1.image = UIImage(systemName: "trash")
        
        
            let action2 = UIContextualAction(style: .normal, title: "Добавить в коллекцию", handler: { [weak self] (action, view, block) in
                
                self?.word = wordList[indexPath.row]
//
//                let vc = self?.storyboard?.instantiateViewController(withIdentifier: "selectCollectionForWordStoryboard") as? SelectCollectionForWordViewController
//                vc?.word = wordList[indexPath.row]
//                self?.navigationController?.present(vc!, animated: true)
                
                if(self!.collectionList.count == 0){
                    let alert = auxiliaryTools.getInfoAlert(title: "Внимание", message: "У вас нет ни одной собственной коллекции. Cоздайте свою коллекцию, чтобы добавить слово.")
                    self?.present(alert, animated: true, completion: nil)
                }else{
                    
                    let vc = UIViewController()
                    vc.preferredContentSize = CGSize(width: self!.screenWidth, height: self!.screenHeight)
                    let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: self!.screenWidth, height: self!.screenHeight))
                    pickerView.dataSource = self
                    pickerView.delegate = self
                    
                    pickerView.selectedRow(inComponent: 0)
                    vc.view.addSubview(pickerView)
                    pickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
                    pickerView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
                    
                    let alert = UIAlertController(title: "Выберите коллекцию", message: "", preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { (UIAlertAction) in
                    }))
                    alert.setValue(vc, forKey: "contentViewController")
                    alert.addAction(UIAlertAction(title: "Добавить", style: .default, handler: {
                        (UIAlertAction) in
                        self?.selectedRow = pickerView.selectedRow(inComponent: 0)
                        let selected = Array(self!.collectionList)[self!.selectedRow]
                        let text = selected.nameCollection
                        
                        auxiliaryTools.addWord(collectionID: self!.collectionList[self!.selectedRow].id, targetWord: self!.word.targetWord, baseWord: self!.word.baseWord)
                        
                    }))
                    self?.present(alert, animated: true)
                    
                }
                
            })
            action2.backgroundColor = .systemBlue
//            action2.image = UIImage(systemName: "plus.circle")
        
//            let action3 = UIContextualAction(style: .normal, title: "К слову", handler: { [weak self] (action, view, block) in
//
//            })
//            action3.backgroundColor = .orange
//            action3.image = UIImage(systemName: "arrowshape.turn.up.left")
        
            var thisCollection = auxiliaryTools.getCollectionById(id: collectionID)
        if(thisCollection.customType == true){
            return UISwipeActionsConfiguration(actions: [action1, action2])
        }else{
            return UISwipeActionsConfiguration(actions: [action2])
        }
        
        
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        
        if(auxiliaryTools.getCollectionById(id: collectionID).customType == false){
            createWordButton.tintColor = UIColor(white: 1, alpha: 0)
            createWordButton.isEnabled = false
        }
        
        if(firstLoad){
            firstLoad = false
            wordList = auxiliaryTools.getWordByCollectionId(collectionID: collectionID, type: "all")
        }
        NotificationCenter.default.addObserver(self, selector: #selector(functionName), name: Notification.Name("reloadCollectionData"), object: nil)
        self.navigationItem.title = name
        
        if wordList.count == 0{
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
                    noDataLabel.text = "Добавьте слова в коллекцию"
            noDataLabel.textColor = UIColor.gray
                    noDataLabel.textAlignment = .center
                    tableView.backgroundView = noDataLabel
                    tableView.separatorStyle = .none
                }
    }

    
    
    override func viewWillDisappear(_ animated: Bool) {
        wordList.removeAll()
    }
    
    
    
    @objc func functionName (notification: NSNotification){
        tableView.reloadData()
        let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
                noDataLabel.text = ""
                noDataLabel.textColor = UIColor.black
                noDataLabel.textAlignment = .center
                tableView.backgroundView = noDataLabel
                tableView.separatorStyle = .none
    }
    

    @IBAction func createWordAction(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "createWordStoryboard") as? CreateWordViewController
        vc?.collectionID = collectionID
        vc?.wordTableView = self
        navigationController?.present(vc!, animated: true)
        
    }
    
    func create(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "createWordStoryboard") as? CreateWordViewController
        vc?.collectionID = collectionID
        vc?.wordTableView = self
        navigationController?.present(vc!, animated: true)
    }
    
    
    func getProgressColor( progress: Float ) -> UIColor{
        
        if(progress <= 0.3){
            return .red
        }else if (progress <= 0.7){
            return .systemYellow
        }else{
            return .green
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
//        tableView.
    }
    
    
    
    // Выбор коллекции для добавления слова
    
    var word:Word!
    var collectionList = auxiliaryTools.getCollectionListByCustomType(customType: true)
    var selectedRow = 0
    
    
    let screenWidth = UIScreen.main.bounds.width - 10
    let screenHeight = UIScreen.main.bounds.height / 3
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return collectionList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 30))
        label.text = Array(collectionList)[row].nameCollection
        label.sizeToFit()
        return label
    }

    
    
    
}
