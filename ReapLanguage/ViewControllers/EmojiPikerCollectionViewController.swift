//
//  emojiPikerCollectionViewController.swift
//  FastEnglish
//
//  Created by Kirill on 28.06.2022.
//

import UIKit

private let reuseIdentifier = "Cell"

class EmojiPikerCollectionViewController: UICollectionViewController {
    
    var CCVC:CreateCollectionViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        fetchEmojis()
        print("\u{E9}\u{20DD}")

    }
    
    var emojiList: [[String]] = []
    let sectionTitle: [String] = ["Emoticons", "Dingbats", "Transport and map symbols", "Enclosed Characters"]



    func fetchEmojis(){

        let emojiRanges = [
            0x1F600...0x1F64F,
            0x2702...0x27B0,
            0x1F680...0x1F6C0,
            0x1F170...0x1F251,
            0x1F43F...0x1F986
        ]
    
        

        for range in emojiRanges {
            var array: [String] = []
            for i in range {
//                print(String(i))
//                print("__________")
                if let unicodeScalar = UnicodeScalar(i){
                    array.append(String(describing: unicodeScalar))
                }
            }

            emojiList.append(array)
        }
    }

    @IBAction func tapButton(_ sender: UIButton) {
        navigationController!.popViewController(animated: true)
    }
    
    func tapButtonn(_ sender: UIButton) {
        navigationController!.popViewController(animated: true)
    }
    
    
    
    
    
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiPikerCell", for: indexPath) as! EmojiPikerViewCell
//            cell.imageView.image = emojiList[indexPath.section][indexPath.item].image()
//        cell.addButton.addTarget(self, action: #selector(tapButtonn(_:)), for: .touchUpInside)
//            return cell
//    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojiList[section].count
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return emojiList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        CCVC.strEmoji = emojiList[indexPath.section][indexPath.item]
        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        print("didSelectItemAt")
        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("Got clicked!")
    }



}


//extension HomeViewController: UICollectionViewDataSource {
//
//
//func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//    …
//}
//
//
//
//// specify cells
//func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//    ….
//}
//
//
//
//// called when widget is moved
//func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        …
//}
//
//
//
//// called when clicked
//func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//    print("Got clicked!")
//}
//
//
//
//}


extension String {

    func image() -> UIImage? {
        let size = CGSize(width: 50, height: 50)
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        UIColor.clear.set()

        let stringBounds = (self as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30)])
        let originX = (size.width - stringBounds.width)/2
        let originY = (size.height - stringBounds.height)/2
        print(stringBounds)
        let rect = CGRect(origin: CGPoint(x: originX, y: originY), size: size)
        UIRectFill(rect)

        (self as NSString).draw(in: rect, withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30)])

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

}
