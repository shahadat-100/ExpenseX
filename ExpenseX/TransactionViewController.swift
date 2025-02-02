//
//  TransactionViewController.swift
//  ExpenseX
//
//  Created by shahadat on 1/2/25.
//

//import UIKit
//import DGCharts
//
//class TransactionViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//    }
//
//}

import UIKit
import DGCharts

class TransactionViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var barChartView: BarChartView!  // Connect this from Storyboard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBarChart()
        setData()
    }
    
    private func setupBarChart() {
       
        barChartView.delegate = self
        barChartView.noDataText = "No data available"
        
        // Remove grid lines
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.leftAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.drawGridLinesEnabled = false
      
        // Remove background color
        barChartView.backgroundColor = .color

        // Keep x-axis labels at the bottom
        barChartView.xAxis.labelPosition = .bottom
        
        // Set minimum value for left axis
        barChartView.leftAxis.axisMinimum = 0
        
        // Hide right axis
        barChartView.rightAxis.enabled = false
        
        
        // Change text color to white
        barChartView.xAxis.labelTextColor = .white
        barChartView.leftAxis.labelTextColor = .white
        barChartView.legend.textColor = .white
        barChartView.noDataTextColor = .white
    }
    
    private func setData() {
        let days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        let values: [Double] = [1220, 920, 1150, 1140, 1280, 1220, 1170]  // Example transaction values
        
        var dataEntries: [BarChartDataEntry] = []
        
        for (index, value) in values.enumerated() {
            let entry = BarChartDataEntry(x: Double(index), y: value)
            dataEntries.append(entry)
        }
        
        let dataSet = BarChartDataSet(entries: dataEntries, label: "Transactions")
        dataSet.colors = ChartColorTemplates.pastel() // Use predefined colors
        dataSet.valueTextColor = .white
        dataSet.valueFont = .systemFont(ofSize: 12)
        
        let data = BarChartData(dataSet: dataSet)
        barChartView.data = data
        
        // Set custom x-axis labels
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: days)
    }
}
