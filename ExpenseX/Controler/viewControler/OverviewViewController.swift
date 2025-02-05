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
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var totalAmount_: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var expanseLabel: UILabel!
    
    var spentData: PieChartDataEntry!
    var earnedData : PieChartDataEntry!
    var dataEntries: [PieChartDataEntry] = []
    
    var transactionArray: [TransactionModel] = []
    
    var total_Amount: Double = 0.0
    var income_Amount: Double = 0.0
    var expense_Amount: Double = 0.0
    
    
    let userDefaults = UserDefaults.standard
    
    private let transactionManager = TransactionManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        //userDefaults.removeObject(forKey: "userName")
        setChartData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        nameLabel.text = /* "👤 " + */ (userDefaults.string(forKey: "userName") ?? "User")
        
        total_Amount = 0.0
        income_Amount = 0.0
        expense_Amount = 0.0
        
        is_UserSingedIn()
        
        transactionArray = transactionManager.getAllTransactions() ?? []
        
        if transactionArray.count > 0 {
            
            for transaction in transactionArray {
                
                if transaction.Finance == "income" {
                    
                    income_Amount += transaction.amount ?? 0.0
                    
                }
                else {
                    
                    expense_Amount += transaction.amount ?? 0.0
                    
                }
            }
            
        }
        
        total_Amount = income_Amount - expense_Amount
        
        totalAmount_.text = "$ \(total_Amount)"
        incomeLabel.text = "$ \(income_Amount)"
        expanseLabel.text = "$ \(expense_Amount)"
        
        DispatchQueue.main.async {
            
            self.recentTranjectionTabel.reloadData()
            self.setChartData()
        }
    }
    
    private func setChartData() {
        
        pieChartView.chartDescription.text = ""
        pieChartView.holeRadiusPercent = 0.35 // Adjust donut chart effect
        pieChartView.legend.textColor = .white
        spentData = PieChartDataEntry(value: expense_Amount, label: "Expense")
        earnedData = PieChartDataEntry(value: income_Amount, label: "Income")
        dataEntries = [spentData, earnedData]
        
        let chartDataSet = PieChartDataSet(entries: dataEntries, label: "")
        let chartData = PieChartData(dataSet: chartDataSet)
        
        // Define custom dark aesthetic colors
        chartDataSet.colors = [
            UIColor.spent, // Dark Red for Spent
            UIColor.earn  // Teal Green for Earned
        ]
        
        chartDataSet.valueTextColor = UIColor.white // Text color
        chartDataSet.valueFont = .boldSystemFont(ofSize: 12)
        
        pieChartView.data = chartData
        //        pieChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .easeInBack)
    }
    
    
    private func is_UserSingedIn()
    {
        let isSignedIn = userDefaults.bool(forKey: "isSignedIn")
        
        
        if !isSignedIn
        {
            guard let vc = self.storyboard?.instantiateViewController(identifier: "WellComeViewController") as? WellComeViewController else {return}
            let nav = UINavigationController(rootViewController: vc)
            nav.navigationBar.isHidden = true
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false)
            
        }
    }
    
    
}


extension OverviewViewController : UITableViewDelegate
{
    
}

extension OverviewViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recemTranjectionTableViewCell") as?  recemTranjectionTableViewCell else {
            return UITableViewCell()
        }
        cell.money.text = "$ \(String(transactionArray[indexPath.row].amount ?? 0.0)) "
        cell.name.text = transactionArray[indexPath.row].sourceType
        cell.dateAndTime.text = formatDateToString(date: transactionArray[indexPath.row].date ?? Date())
        if transactionArray[indexPath.row].Finance == "income" {
            cell.imageSymble.image = UIImage(resource: .increase)
        }
        else if transactionArray[indexPath.row].Finance == "expense" {
            cell.imageSymble.image = UIImage(resource: .decrease)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return recentTranjectionTabel.bounds.height / 3
    }
    
    func formatDateToString(date: Date, format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: date)
    }
    
}
