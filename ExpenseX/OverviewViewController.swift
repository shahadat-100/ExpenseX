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
    @IBOutlet weak var recentTranjectionTabel: UITableView!
    {
        didSet {
            
            recentTranjectionTabel.dataSource = self
            recentTranjectionTabel.delegate = self
            recentTranjectionTabel.register(UINib(nibName: "recemTranjectionTableViewCell", bundle: nil), forCellReuseIdentifier: "recemTranjectionTableViewCell")
        }
    }
    
    var spentData = PieChartDataEntry(value: 45, label: "Expense")
    var earnedData = PieChartDataEntry(value: 55, label: "Income")
    
    var dataEntries: [PieChartDataEntry] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pieChartView.chartDescription.text = ""
        pieChartView.holeRadiusPercent = 0.35 // Adjust donut chart effect
        pieChartView.legend.textColor = .white
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


extension OverviewViewController : UITableViewDelegate
{
    
}

extension OverviewViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recemTranjectionTableViewCell") as?  recemTranjectionTableViewCell else {
            return UITableViewCell()
        }
        if indexPath.row % 2 == 0 {
            
            cell.imageSymble.image = UIImage(named: "increase")
            cell.money.text = "+ $ 2000000"
            cell.name.text = "Selary"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return recentTranjectionTabel.bounds.height / 5
    }
    
}
