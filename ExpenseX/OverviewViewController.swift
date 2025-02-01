//
//  OverviewViewController.swift
//  ExpenseX
//
//  Created by shahadat on 1/2/25.
//

import UIKit
import Charts
import DGCharts

class OverviewViewController: UIViewController {
    
    @IBOutlet weak var pieChartView: PieChartView!
    
    var spentData = PieChartDataEntry(value: 45, label: "Spent")
    var earnedData = PieChartDataEntry(value: 55, label: "Earned")
    
    var dataEntries: [PieChartDataEntry] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pieChartView.chartDescription.text = ""
       // pieChartView.holeRadiusPercent = 0.35 // Adjust donut chart effect
        pieChartView.drawHoleEnabled = false

        
        dataEntries = [spentData, earnedData]
        setChartData()
    }
    
    private func setChartData() {
        let chartDataSet = PieChartDataSet(entries: dataEntries, label: "")
        let chartData = PieChartData(dataSet: chartDataSet)
        
        // Define custom dark aesthetic colors
        chartDataSet.colors = [
            UIColor.spent, // Dark Red for Spent
            UIColor.earn  // Teal Green for Earned
        ]
      
        chartDataSet.valueTextColor = UIColor.white // Text color
        chartDataSet.valueFont = .boldSystemFont(ofSize: 14)
        
        pieChartView.data = chartData
//        pieChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .easeInBack)
    }
}


