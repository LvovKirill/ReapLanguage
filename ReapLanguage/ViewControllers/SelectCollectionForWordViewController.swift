//
//  SelectCollectionForWordViewController.swift
//  FastEnglish
//
//  Created by Kirill on 30.06.2022.
//

import UIKit

class SelectCollectionForWordViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var collectionList = auxiliaryTools.getCollectionListByCustomType(customType: true)
    var word:Word!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self

    }
    
    


}

extension SelectCollectionForWordViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collectionList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectCollectionForWordCell", for: indexPath) as! SelectCollectionForWordCell
        cell.nameCollection.text = collectionList[indexPath.row].nameCollection
        cell.emoji.text = collectionList[indexPath.row].emoji
        print("ЕСТЬ")
        return cell
}
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("newWord")
        auxiliaryTools.addWord(collectionID: collectionList[indexPath.row].id, targetWord: word.targetWord, baseWord: word.baseWord)
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("newWord")
    }
}
