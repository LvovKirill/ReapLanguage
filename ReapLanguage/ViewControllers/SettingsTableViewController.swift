//
//  SettingsTableViewController.swift
//  FastEnglish
//
//  Created by Kirill on 12.06.2022.
//

import UIKit

class SettingsTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    @IBOutlet weak var lableForNumberRepetitions: UILabel!
    @IBOutlet weak var stepperForNumberRepetitions: UIStepper!
    @IBOutlet weak var stepperForWordsInDay: UIStepper!
    @IBOutlet weak var stepperForIntervalRepetitions: UIStepper!
    @IBOutlet weak var stepperForMaximumQuantityOfWords: UIStepper!
    @IBOutlet weak var lableForWordInDay: UILabel!
    @IBOutlet var settingsRow: [UITableViewCell]!
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    
    var selectedRow = 0
    var pickerType = "theme"
    var themeList:[String] = ["как в системе", "светлая", "тёмная"]
    var languageList:[String] = ["English 🇺🇸", "漢語 🇨🇳", "el español 🇪🇸", "Русский 🇷🇺", "हिन्दी 🇮🇳", "Deutsch 🇩🇪", "日本語 🇯🇵", "le français 🇫🇷"]
    
    let settings = Settings()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stepperForNumberRepetitions.transform = stepperForNumberRepetitions.transform.scaledBy(x: 0.8, y: 0.8)
        stepperForNumberRepetitions.minimumValue = 3.0
        stepperForNumberRepetitions.maximumValue = 15.0
        stepperForNumberRepetitions.value = Settings.numberRepetitions
        
        stepperForWordsInDay.transform = stepperForWordsInDay.transform.scaledBy(x: 0.8, y: 0.8)
        stepperForWordsInDay.minimumValue = 1.0
        stepperForWordsInDay.value = Double(UserDefaults.standard.integer(forKey: "wordInDay"))
        
        stepperForIntervalRepetitions.transform = stepperForIntervalRepetitions.transform.scaledBy(x: 0.8, y: 0.8)
        
        stepperForMaximumQuantityOfWords.transform = stepperForMaximumQuantityOfWords.transform.scaledBy(x: 0.8, y: 0.8)
        
//        tableView.allowsSelection = false
        lableForNumberRepetitions.text = Int(stepperForNumberRepetitions.value).description
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        switch row{
        case 0:
            pickerType = "theme"
            startPopUpPickerForTheme()
        case 1:
            pickerType = "lang"
            startPopUpPickerForLanguage()
        case 2:
            break
        case 3:
            break
        case 4:
            break
        case 5:
            break
        case 6:
            break
        case 7:
            break
        case 8:
            break
        case 9:
            break
        case 10:
            break
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case "selectNumberRepetitionsVC":
            let vc = segue.destination as? SelectNumberRepetitionsViewController
            vc?.selectNumberRepetitionsData = [3,4,5,6,7,8,9,10]
        default:
            break
        }
    }

    @IBAction func stepperForNumberRepetitionsAction(_ sender: UIStepper) {
        lableForNumberRepetitions.text = Int(sender.value).description
        UserDefaults.standard.setValue(sender.value, forKey: "numberRepetitions")
        Settings.numberRepetitions = sender.value
    }
    
    @IBAction func stepperForWordInDayAction(_ sender: UIStepper) {
        lableForWordInDay.text = Int(sender.value).description
        UserDefaults.standard.setValue(sender.value, forKey: "wordInDay")
    }
    
//    @IBAction func themeAction(_ sender: UISwitch){
//        if(sender.isOn){
//            for window in UIApplication.shared.windows{
//                window.overrideUserInterfaceStyle = .dark
//            }
//        }else{
//            for window in UIApplication.shared.windows{
//                window.overrideUserInterfaceStyle = .light
//            }
//        }
//    }
    
    func startPopUpPickerForTheme(){
        let vc = UIViewController()
                vc.preferredContentSize = CGSize(width: UIScreen.main.bounds.width - 10, height: UIScreen.main.bounds.height / 2)
                let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 10, height: UIScreen.main.bounds.height / 2))
                pickerView.dataSource = self
                pickerView.delegate = self
                
                pickerView.selectRow(selectedRow, inComponent: 0, animated: false)
                
                vc.view.addSubview(pickerView)
                pickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
                pickerView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
                
                let alert = UIAlertController(title: "Выберете тему", message: "", preferredStyle: .actionSheet)
                
//                alert.popoverPresentationController?.sourceView = pickerViewButton
//                alert.popoverPresentationController?.sourceRect = pickerViewButton.bounds
                
                alert.setValue(vc, forKey: "contentViewController")
                alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { (UIAlertAction) in
                }))
                
                alert.addAction(UIAlertAction(title: "Готово", style: .default, handler: { (UIAlertAction) in
                    self.selectedRow = pickerView.selectedRow(inComponent: 0)
                    let selected = self.themeList[self.selectedRow]
                    self.themeLabel.text = selected
                    
                    
                    switch self.selectedRow{
                    case 0:
                        for window in UIApplication.shared.windows{
                        window.overrideUserInterfaceStyle = .unspecified
                        }
                        UserDefaults.standard.set("unspecified", forKey: "theme")
                    case 1:
                        for window in UIApplication.shared.windows{
                        window.overrideUserInterfaceStyle = .light
                        }
                        UserDefaults.standard.set("light", forKey: "theme")
                    case 2:
                        for window in UIApplication.shared.windows{
                        window.overrideUserInterfaceStyle = .dark
                        }
                        UserDefaults.standard.set("dark", forKey: "theme")
                    default:
                        break
                        
                    }
            

                }))
                
                present(alert, animated: true, completion: nil)
    }
    
    
    func startPopUpPickerForLanguage(){
        let vc = UIViewController()
                vc.preferredContentSize = CGSize(width: UIScreen.main.bounds.width - 10, height: UIScreen.main.bounds.height / 2)
                let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 10, height: UIScreen.main.bounds.height / 2))
                pickerView.dataSource = self
                pickerView.delegate = self
                
                pickerView.selectRow(selectedRow, inComponent: 0, animated: false)
                
                vc.view.addSubview(pickerView)
                pickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
                pickerView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
                
                let alert = UIAlertController(title: "Выберете тему", message: "", preferredStyle: .actionSheet)
                
                alert.setValue(vc, forKey: "contentViewController")
                alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { (UIAlertAction) in
                }))
                
                alert.addAction(UIAlertAction(title: "Готово", style: .default, handler: { (UIAlertAction) in
                    self.selectedRow = pickerView.selectedRow(inComponent: 0)
                    let selected = self.languageList[self.selectedRow]
                    self.languageLabel.text = selected
                    UserDefaults.standard.set(selected, forKey: "lang")
            

                }))
                
                present(alert, animated: true, completion: nil)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
        {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 10, height: 30))
            if(pickerType == "theme"){
            label.text = themeList[row]
            }else{
            label.text = languageList[row]
            }
            label.sizeToFit()
            return label
        }

    func numberOfComponents(in pickerView: UIPickerView) -> Int
        {
            return 1 //return 2
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
        {
            if(pickerType == "theme"){
                return themeList.count
            }else{
                return languageList.count
            }
        }
        
        func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat
        {
            return 60
        }
    
}




