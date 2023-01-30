//import Foundation
//import Charts
//
//class Statistics{
//    
//    
//    func getBarEntry(key:String) -> [BarChartDataEntry]{
//        
//        var entries = [BarChartDataEntry]()
//        var date = DateManager.getCurrentDate()
//        
//        switch key{
//        case "week":
//            for x in 0..<7{
//                let dayPoint = auxiliaryTools.getDayPoint(date: date)
//                entries.append(BarChartDataEntry(x: Double(x), y: Double(Int(truncating: dayPoint.numberRepeatedWords) + 1)))
//                date.day = date.day! + 1
//            }
//        case "month":
//            for x in 0..<31{
//                let dayPoint = auxiliaryTools.getDayPoint(date: date)
//                entries.append(BarChartDataEntry(x: Double(x), y: Double(Int(truncating: dayPoint.numberRepeatedWords) + 1)))
//                date.day = date.day! + 1
//            }
//        case "year":
//            for x in 0..<12{
//                let dayPoint = auxiliaryTools.getDayPoint(date: date)
//                entries.append(BarChartDataEntry(x: Double(x), y: Double(Int(truncating: dayPoint.numberRepeatedWords) + 1)))
//                date.day = date.day! + 1
//            }
//        default:
//            break
//        }
//        
//        return entries
//        
//    }
//    
//    
//    func getLineEntry(key:String) -> [ChartDataEntry]{
//        
//        var entries = [ChartDataEntry]()
//        
//        switch key{
//        case "week":
//            break
//        case "month":
//            for progressPoint in auxiliaryTools.getAllProgressPoint(){
//                entries.append(BarChartDataEntry(x: Double(truncating: progressPoint.number), y: Double(truncating: progressPoint.value)))
//            }
//        case "year":
//            break
//        default:
//            break
//        }
//        
//        return entries
//        
//    }
//    
//    func getPieEntry() -> [PieChartDataEntry]{
//        var listEntry:[WordForPie] = []
//        
//        for collection in auxiliaryTools.getAllCollections(){
//            for word in auxiliaryTools.getWordByCollectionId(collectionID: collection.id, type: "all"){
//                if (word.numberCorrectRepetitions != 0){
//                if ((901 <= Int(collection.id)) && (Int(collection.id) <= 950)){
//                    listEntry.append(WordForPie.init(value: word.numberCorrectRepetitions as! Int, parentCollection: collection.id as! Int, usedIndicator: false))
//                    print("кастом")
//                    print(collection.id)
//                }else{
//                    listEntry.append(WordForPie.init(value: word.numberCorrectRepetitions as! Int, parentCollection: word.parentCollection as! Int, usedIndicator: false))
//                    print("свои")
//                    print(collection.id)
//                }
//                }
//            }
//        }
//        
//        var newListEntry:[WordForPie] = []
//        for word in listEntry{
//            var flag = false
//            var index = 0
//            if (newListEntry.count != 0){
//            for i in 0...newListEntry.count - 1{
//                if(newListEntry[i].parentCollection == word.parentCollection){
//                    index = i
//                    flag = true
//                    break
//                }
//            }
//            }
//            
//            if(flag){
//                newListEntry[index].value = newListEntry[index].value + word.value
//            }else{
//                newListEntry.append(word)
//            }
//            
//        }
//        
//        var entries = [PieChartDataEntry]()
//        
//        for dataEntry in newListEntry{
//            if (dataEntry.parentCollection == 1000){
//                entries.append(PieChartDataEntry(value: Double(dataEntry.value), label: "🗂️"))
//            }else{
////                if (dataEntry.parentCollection != 0){
//                let collection = auxiliaryTools.getCollectionById(id: dataEntry.parentCollection as NSNumber)
//                entries.append(PieChartDataEntry(value: Double(dataEntry.value), label: collection.emoji))
////                }
//            }
//        }
//        
//        return entries
//        
//    }
//    
//    
//    func countLearnedWords() -> Int{
//        var count = 0
//        for collection in auxiliaryTools.getAllCollections(){
//            for word in auxiliaryTools.getWordByCollectionId(collectionID: collection.id, type: "all"){
//                if(word.numberCorrectRepetitions as! Double >= Settings.numberRepetitions){
//                    count += 1
//                }
//            }
//        }
//        return count
//    }
//    
//    func countTodayLearnedWords() -> Int{
//        return 3
//    }
//    
//    func countPartiallyLearnedWords() -> Int{
//        var count = 0
//        for collection in auxiliaryTools.getAllCollections(){
//            for word in auxiliaryTools.getWordByCollectionId(collectionID: collection.id, type: "all"){
//                if(word.numberCorrectRepetitions as! Double > 0){
//                    count += 1
//                }
//            }
//        }
//        return count
//    }
//    
//    struct WordForPie{
//        var value:Int
//        var parentCollection:Int
//        var usedIndicator:Bool
//    }
//    
//    
//}
