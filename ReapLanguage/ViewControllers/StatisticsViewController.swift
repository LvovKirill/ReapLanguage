//
//  StatisticsViewController.swift
//  FastEnglish
//
//  Created by Kirill on 01.07.2022.
//

//import UIKit
//import SwiftUI
//import Charts
//import CoreData
//import CoreGraphics
//import UIKit
//
//class StatisticsViewController: UIViewController {
//    
//    let statistics = Statistics()
//    
//    @IBOutlet weak var allLearnedWordsView: UIView!
//    @IBOutlet weak var partiallyLearnedWordsView: UIView!
//    @IBOutlet weak var newWordsForTodayView: UIView!
//    @IBOutlet weak var viewFromBarChart: UIView!
//    @IBOutlet weak var viewFromLineChart: UIView!
//    @IBOutlet weak var viewFromPieChart: UIView!
//    @IBOutlet weak var viewBackgroundPieChart: UIView!
//    @IBOutlet weak var allLearnedWordsLabel: UILabel!
//    @IBOutlet weak var partiallyLearnedWordsLabel: UILabel!
//    @IBOutlet weak var todayLearnedWordsLabel: UILabel!
//    @IBOutlet weak var intendedTodayLearnedWordsLabel: UILabel!
//    
//    var barChart:BarChartView = BarChartView()
//    var lineChart:LineChartView = LineChartView()
//    var pieChart:PieChartView = PieChartView()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        allLearnedWordsView.layer.masksToBounds = true
//        allLearnedWordsView.layer.cornerRadius = 10
//        allLearnedWordsView.layer.masksToBounds = false
//        allLearnedWordsView.layer.shadowColor = UIColor.black.cgColor
//        allLearnedWordsView.layer.shadowOpacity = 0.15
//        allLearnedWordsView.layer.shadowRadius = 10
//        
//        partiallyLearnedWordsView.layer.masksToBounds = true
//        partiallyLearnedWordsView.layer.cornerRadius = 10
//        partiallyLearnedWordsView.layer.masksToBounds = false
//        partiallyLearnedWordsView.layer.shadowColor = UIColor.black.cgColor
//        partiallyLearnedWordsView.layer.shadowOpacity = 0.15
//        partiallyLearnedWordsView.layer.shadowRadius = 10
//        
//        newWordsForTodayView.layer.masksToBounds = true
//        newWordsForTodayView.layer.cornerRadius = 10
//        newWordsForTodayView.layer.masksToBounds = false
//        newWordsForTodayView.layer.shadowColor = UIColor.black.cgColor
//        newWordsForTodayView.layer.shadowOpacity = 0.15
//        newWordsForTodayView.layer.shadowRadius = 10
//        
//        viewBackgroundPieChart.layer.masksToBounds = true
//        viewBackgroundPieChart.layer.cornerRadius = 10
//        viewBackgroundPieChart.layer.masksToBounds = false
//        viewBackgroundPieChart.layer.shadowColor = UIColor.black.cgColor
//        viewBackgroundPieChart.layer.shadowOpacity = 0.15
//        viewBackgroundPieChart.layer.shadowRadius = 10
//        
//        uploadData()
//        createBarChart(key: "week")
//        createLineChart()
//        createPieChart()
//    }
//    
//    @IBAction func BarChartSegmentedControlAction(_ sender: UISegmentedControl) {
//        switch sender.selectedSegmentIndex{
//        case 0:
//            createBarChart(key: "week")
//        case 1:
//            createBarChart(key: "month")
//        case 2:
//            createBarChart(key: "year")
//        default:
//            break
//        }
//        
//    }
//    
//    func createBarChart(key:String){
//        barChart.frame = CGRect(x: 0, y: 0, width: self.viewFromBarChart.frame.size.width, height: self.viewFromBarChart.frame.size.height)
//        self.viewFromBarChart.addSubview(barChart)
//
//        barChart.doubleTapToZoomEnabled = false
//        barChart.pinchZoomEnabled = false
//        barChart.dragEnabled = false
//        barChart.dragDecelerationEnabled = false
//        barChart.setScaleEnabled(false)
//        barChart.borderColor = .systemBlue
//        barChart.chartDescription.text = ""
//        barChart.legend.enabled = false
//        barChart.rightAxis.enabled = false
//        barChart.leftAxis.enabled = false
//        barChart.xAxis.drawGridLinesEnabled = false
//        barChart.xAxis.drawAxisLineEnabled = false
//        barChart.drawBarShadowEnabled = false
//        barChart.xAxis.granularity = 1
//        barChart.xAxis.labelPosition = .bottom
//        
//        switch key{
//        case "week":
//            barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: ["пн", "вт", "ср", "чт", "пт", "сб", "вс"])
//        case "month":
//            barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"])
//        case "year":
//            barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"])
//        default:
//            break
//        }
//        
//        let set = BarChartDataSet(entries: statistics.getBarEntry(key: key))
//        let data = BarChartData(dataSet: set)
//        set.colors = [setColor(value: 1)]
//        set.drawValuesEnabled = true
//        barChart.data = data
//        
//    }
//    
//    func setColor(value: Double) -> UIColor{
//
//        if(value == 0){
//            return UIColor.systemGray
//        }
//        else{
//            return UIColor.systemBlue
//        }
//    }
//    
//    
//    func createLineChart(){
//        lineChart.frame = CGRect(x: 0, y: 0, width: self.viewFromLineChart.frame.size.width, height: self.viewFromLineChart.frame.size.height)
////        barChart.center = view.center
//        self.viewFromLineChart.addSubview(lineChart)
//        var entries = statistics.getLineEntry(key: "month")
//        let set = LineChartDataSet(entries: entries)
//        let data = LineChartData(dataSet: set)
//        set.colors = [.white]
//        set.circleColors = [.white]
//        set.circleRadius = 1.0
//        set.drawValuesEnabled = false
//        lineChart.data = data
//        lineChart.borderColor = .white
//        lineChart.gridBackgroundColor = .white
//        lineChart.doubleTapToZoomEnabled = false
//        lineChart.pinchZoomEnabled = false
//        lineChart.dragEnabled = false
//        lineChart.dragDecelerationEnabled = false
//        lineChart.setScaleEnabled(false)
//        lineChart.borderColor = .white
//        lineChart.chartDescription.text = ""
//        lineChart.legend.enabled = false
//        lineChart.xAxis.axisLineColor = .white
//        lineChart.xAxis.gridColor = .white
//        lineChart.gridBackgroundColor = .white
//        lineChart.rightAxis.enabled = false
//        lineChart.rightAxis.gridColor = .white
//        lineChart.leftAxis.enabled = false
//        lineChart.xAxis.drawGridLinesEnabled = false
//        lineChart.xAxis.drawAxisLineEnabled = false
//        lineChart.xAxis.drawLabelsEnabled = false
//        barChart.xAxis.labelPosition = .bottom
//    }
// 
//    
//    func createPieChart(){
//        pieChart.frame = CGRect(x: 0, y: 0, width: self.viewFromPieChart.frame.size.width, height: self.viewFromPieChart.frame.size.height)
////      barChart.center = view.center
//        self.viewFromPieChart.addSubview(pieChart)
//        var entries = statistics.getPieEntry()
//        let set = PieChartDataSet(entries: entries)
//        let data = PieChartData(dataSet: set)
//        set.colors = [.systemBlue, .systemBlue.withAlphaComponent(0.85), .systemBlue.withAlphaComponent(0.7), .systemBlue.withAlphaComponent(0.55), .systemBlue.withAlphaComponent(0.4)]
//        set.drawValuesEnabled = false
//        pieChart.data = data
//        pieChart.dragDecelerationEnabled = false
//        pieChart.holeColor = UIColor(white: 1, alpha: 0)
//        pieChart.holeRadiusPercent = 0.4
//        pieChart.transparentCircleRadiusPercent = 0.42
//        pieChart.chartDescription.text = ""
//        pieChart.legend.enabled = false
//        let marker:BalloonMarker = BalloonMarker(color: .red, font: UIFont(name: "Helvetica", size: 12)!, textColor: .black, insets: UIEdgeInsets(top: 7.0, left: 7.0, bottom: 7.0, right: 7.0))
//        marker.minimumSize = CGSize(width: 75.0, height: 35.0)
//        pieChart.marker = marker
//    }
//    
//    
//    func uploadData(){
//        allLearnedWordsLabel.text = String(statistics.countLearnedWords())
//        partiallyLearnedWordsLabel.text = String(statistics.countPartiallyLearnedWords())
//        todayLearnedWordsLabel.text = String(statistics.countTodayLearnedWords())
//        intendedTodayLearnedWordsLabel.text = String(UserDefaults.standard.integer(forKey: "wordInDay"))
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        viewDidLoad()
//    }
//    
//
//
//}
//
//open class BalloonMarker: MarkerImage{
//    open var color: UIColor?
//    open var arrowSize = CGSize(width: 15, height: 11)
//    open var font: UIFont?
//    open var textColor: UIColor?
//    open var insets = UIEdgeInsets()
//    open var minimumSize = CGSize()
//
//    fileprivate var label: String?
//    fileprivate var _labelSize: CGSize = CGSize()
//    fileprivate var _paragraphStyle: NSMutableParagraphStyle?
//    fileprivate var _drawAttributes = [String : AnyObject]()
//
//    public init(color: UIColor, font: UIFont, textColor: UIColor, insets: UIEdgeInsets)
//    {
//        super.init()
//
//        self.color = color
//        self.font = font
//        self.textColor = textColor
//        self.insets = insets
//
//        _paragraphStyle = NSParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle
//        _paragraphStyle?.alignment = .center
//    }
//
//    open override func offsetForDrawing(atPoint point: CGPoint) -> CGPoint
//    {
//        let size = self.size
//        var point = point
//        point.x -= size.width / 2.0
//        point.y -= size.height
//        return super.offsetForDrawing(atPoint: point)
//    }
//}


