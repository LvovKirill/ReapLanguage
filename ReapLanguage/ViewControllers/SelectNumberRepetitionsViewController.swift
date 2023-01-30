import UIKit

class SelectNumberRepetitionsViewController: UIViewController{
    @IBOutlet weak var tableView: UITableView!
    var selectNumberRepetitionsData:[Int] = [3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self

    }
    



}

extension SelectNumberRepetitionsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectNumberRepetitionsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectNumberRepetitionsCell", for: indexPath)
        cell.textLabel?.text = String(selectNumberRepetitionsData[indexPath.row])
        return cell
}
    
}

