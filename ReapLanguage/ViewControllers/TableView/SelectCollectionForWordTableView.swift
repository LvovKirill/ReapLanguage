//
//  SelectCollectionForWordTableView.swift
//  ReapLanguage
//
//  Created by Kirill on 27.01.2023.
//

import Foundation
import UIKit


class SelectCollectionForWordTableView: UITableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collectionList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectCollectionForWordCell", for: indexPath) as! SelectCollectionForWordCell
        cell.nameCollection.text = collectionList[indexPath.row].nameCollection
        cell.emoji.text = collectionList[indexPath.row].emoji
        print("ЕСТЬ")
        return cell
}
  
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         print("newWord")
//         auxiliaryTools.addWord(collectionID: collectionList[indexPath.row].id, targetWord: word.targetWord, baseWord: word.baseWord)
         dismiss(animated: true, completion: nil)
     }
    
    
}
