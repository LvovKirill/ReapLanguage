import UIKit

class CollectionCell: UITableViewCell{
    @IBOutlet weak var collectionName: UILabel!
    @IBOutlet weak var collectionPlay: CollectionCellUIButton!
    @IBOutlet weak var numberNotLearnedWords: UILabel!
    @IBOutlet weak var numberAllWords: UILabel!
    @IBOutlet weak var emoji: UILabel!
    
    @IBOutlet weak var viewContents: UIView!
    @IBOutlet weak var viewContainer: CollectionCell!
    

}

class CollectionCellUIButton: UIButton {
    var row:Int!
    var section:Int!
}
