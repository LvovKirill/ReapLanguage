//
//  SelectCollectionForWordCell.swift
//  FastEnglish
//
//  Created by Kirill on 30.06.2022.
//

import UIKit

class SelectCollectionForWordCell: UITableViewCell {

    @IBOutlet weak var emoji: UILabel!
    @IBOutlet weak var nameCollection: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func setSelected(_ selected: Bool, animated: Bool, word: Word, collection: Collection) {
        super.setSelected(selected, animated: animated)
        auxiliaryTools.addWord(collectionID: collection.id, targetWord: word.targetWord, baseWord: word.baseWord)
//        dismiss(animated: true, completion: nil)


    }


}
