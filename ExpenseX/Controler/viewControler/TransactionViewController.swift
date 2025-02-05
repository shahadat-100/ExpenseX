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
    
    
    @IBOutlet weak var incomeTabel: UITableView!
    {
        didSet {
            
            incomeTabel.dataSource = self
            incomeTabel.delegate = self
            incomeTabel.register(UINib(nibName: "recemTranjectionTableViewCell", bundle: nil), forCellReuseIdentifier: "recemTranjectionTableViewCell")
        }
    }
    
    @IBOutlet weak var expanseTabel: UITableView!
    {
        didSet {
            
            expanseTabel.dataSource = self
            expanseTabel.delegate = self
            expanseTabel.register(UINib(nibName: "recemTranjectionTableViewCell", bundle: nil), forCellReuseIdentifier: "recemTranjectionTableViewCell")
        }
    }
    
    
    @IBOutlet weak var barChartView1: BarChartView!
    @IBOutlet weak var barChartView2: BarChartView!
    
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var IncomeView: UIView!
    @IBOutlet weak var ExpanseView: UIView!
    @IBOutlet weak var incomeButton: UIButton!
    @IBOutlet weak var expanseButton: UIButton!
    
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var expanseLabel: UILabel!
    
    let transactionManager = TransactionManager()
    
    var transactionArray: [TransactionModel] = []
    var incomeArray: [TransactionModel] = []
    var expenseArray: [TransactionModel] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view1.isHidden = false
        view2.isHidden = true
        IncomeView.isHidden = false
        ExpanseView.isHidden = true
        incomeLabel.textColor = .white
        expanseLabel.textColor = .lightGray
        
        setupBarChart()
        setData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        setUpTabel()
        
       
        
    }
    
    @IBAction func incomeButton(_ sender: Any) {
        
        if view1.isHidden == true {
            
            view1.isHidden = false
            view2.isHidden = true
            
            incomeLabel.textColor = .white
            expanseLabel.textColor = .lightGray
            
            
            IncomeView.isHidden = false
            ExpanseView.isHidden = true
            
            // Animate sliding in view1 from the left and sliding out view2 to the right
            view1.transform = CGAffineTransform(translationX: -view1.frame.width, y: 0)
            IncomeView.transform  = CGAffineTransform(translationX: IncomeView.frame.width, y: 0)
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.view1.transform = .identity  // Slide view1 into position
                self.IncomeView.transform  = .identity
                self.view2.transform = CGAffineTransform(translationX: self.view2.frame.width, y: 0)  // Slide view2 out to the right
                // self.ExpanseView.transform = CGAffineTransform(translationX: , y: <#T##CGFloat#>)
            })
        }
        
    }
    
    @IBAction func expansebutton(_ sender: Any) {
        
        if view2.isHidden == true {
            
            view1.isHidden = true
            view2.isHidden = false
            
            
            incomeLabel.textColor = .lightGray
            expanseLabel.textColor = .white
            
            ExpanseView.isHidden = false
            IncomeView.isHidden = true
            
            // Animate sliding in view2 from the right and sliding out view1 to the left
            view2.transform = CGAffineTransform(translationX: view2.frame.width, y: 0)
            ExpanseView.transform = CGAffineTransform(translationX: -ExpanseView.frame.width, y: 0)
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.view2.transform = .identity  // Slide view2 into position
                self.ExpanseView.transform = .identity
                self.view1.transform = CGAffineTransform(translationX: -self.view1.frame.width, y: 0)  // Slide view1 out to the left
            })
        }
        
    }
    
    
    private func setUpTabel()
    {
        incomeArray.removeAll()
        expenseArray.removeAll()
        
        transactionArray = transactionManager.getAllTransactions() ?? []
        
        if  !transactionArray.isEmpty {
            
            for transaction in transactionArray {
                
                if transaction.Finance == "income" {
                    
                    incomeArray.append(transaction)
                    
                }
                else {
                    
                    expenseArray.append(transaction)
                    
                }
                
            }
            
        }
        
        DispatchQueue.main.async {
            
            self.incomeTabel.reloadData()
            self.expanseTabel.reloadData()
            self.setData()
        }
    }
    
    
    private func setupBarChart() {
        
        barChartView1.delegate = self
        barChartView1.noDataText = "No data available"
        
        // Remove grid lines
        barChartView1.xAxis.drawGridLinesEnabled = false
        barChartView1.leftAxis.drawGridLinesEnabled = false
        barChartView1.rightAxis.drawGridLinesEnabled = false
        
        // Remove background color
        barChartView1.backgroundColor = .color
        
        // Keep x-axis labels at the bottom
        barChartView1.xAxis.labelPosition = .bottom
        
        // Set minimum value for left axis
        barChartView1.leftAxis.axisMinimum = 0
        
        // Hide right axis
        barChartView1.rightAxis.enabled = false
        
        barChartView1.legend.verticalAlignment = .top
        barChartView1.legend.horizontalAlignment = .right
        
        
        // Change text color to white
        barChartView1.xAxis.labelTextColor = .white
        barChartView1.leftAxis.labelTextColor = .white
        barChartView1.legend.textColor = .white
        barChartView1.noDataTextColor = .white
        
        
        barChartView2.delegate = self
        barChartView2.noDataText = "No data available"
        
        // Remove grid lines
        barChartView2.xAxis.drawGridLinesEnabled = false
        barChartView2.leftAxis.drawGridLinesEnabled = false
        barChartView2.rightAxis.drawGridLinesEnabled = false
        
        // Remove background color
        barChartView2.backgroundColor = .color
        
        // Keep x-axis labels at the bottom
        barChartView2.xAxis.labelPosition = .bottom
        
        // Set minimum value for left axis
        barChartView2.leftAxis.axisMinimum = 0
        
        // Hide right axis
        barChartView2.rightAxis.enabled = false
        
        
        
        barChartView2.legend.verticalAlignment = .top
        barChartView2.legend.horizontalAlignment = .right
        
        // Change text color to white
        barChartView2.xAxis.labelTextColor = .white
        barChartView2.leftAxis.labelTextColor = .white
        barChartView2.legend.textColor = .white
        barChartView2.noDataTextColor = .white
    }
    
    private func setData() {
        
        var days: [String] = []
        var values: [Double] = []  // Example values

        days.removeAll()
        values.removeAll()

        let latestEntries = incomeArray.suffix(7) // Get the latest 7 entries (or fewer if not available)

        if latestEntries.count == 7 {
            for entry in latestEntries {
                days.append(formatDateToString2(date: entry.date ?? Date()))
                values.append(entry.amount ?? 0.0)
            }
        } else {
            let missingCount = 7 - latestEntries.count
            for entry in latestEntries {
                days.append(formatDateToString2(date: entry.date ?? Date()))
                values.append(entry.amount ?? 0.0)
            }
            // Append "N/A" and 0.0 for the missing days
            for _ in 0..<missingCount {
                days.append("N/A")
                values.append(0.0)
            }
        }
        
        
        var dataEntries: [BarChartDataEntry] = []
        
        for (index, value) in values.enumerated() {
            let entry = BarChartDataEntry(x: Double(index), y: value)
            dataEntries.append(entry)
        }
        
        let dataSet = BarChartDataSet(entries: dataEntries, label: "Income")
        dataSet.colors = ChartColorTemplates.joyful()
        dataSet.valueTextColor = .white
        dataSet.valueFont = .systemFont(ofSize: 12)
        
        let data = BarChartData(dataSet: dataSet)
        barChartView1.data = data
        
        // Set custom x-axis labels
        barChartView1.xAxis.valueFormatter = IndexAxisValueFormatter(values: days)
        
        var days1: [String] = []
        var values1: [Double] = []  // Example values

        days1.removeAll()
        values1.removeAll()

        let latestEntries1 = expenseArray.suffix(7) // Get the latest 7 entries (or fewer if not available)

        if latestEntries1.count == 7 {
            for entry in latestEntries1 {
                days1.append(formatDateToString2(date: entry.date ?? Date()))
                values1.append(entry.amount ?? 0.0)
            }
        } else {
            let missingCount = 7 - latestEntries1.count
            for entry in latestEntries1 {
                days1.append(formatDateToString2(date: entry.date ?? Date()))
                values1.append(entry.amount ?? 0.0)
            }
            // Append "N/A" and 0.0 for the missing days
            for _ in 0..<missingCount {
                days1.append("N/A")
                values1.append(0.0)
            }
        }
        
        
        var dataEntries1: [BarChartDataEntry] = []
        
        for (index, value1) in values1.enumerated() {
            let entry = BarChartDataEntry(x: Double(index), y: value1)
            dataEntries1.append(entry)
        }
        
        let dataSet1 = BarChartDataSet(entries: dataEntries1, label: "Expenses")
        dataSet1.colors = ChartColorTemplates.pastel().reversed()
        dataSet1.valueTextColor = .white
        dataSet1.valueFont = .systemFont(ofSize: 12)
        
        let data1 = BarChartData(dataSet: dataSet1)
        barChartView2.data = data1
        
        // Set custom x-axis labels
        barChartView2.xAxis.valueFormatter = IndexAxisValueFormatter(values: days1)
        
    }
    
    @IBAction func incomeAddbutton(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(identifier: "addViewController") as? addViewController else {return}
        vc.PageNAmeValue = "Add Income"
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: false)
    }
    
    @IBAction func expanseAddbuton(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(identifier: "addViewController") as? addViewController else {return}
        vc.PageNAmeValue = "Add Expense"
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: false)
    }
    
    
}

extension TransactionViewController : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == incomeTabel {
            
            guard let vc = self.storyboard?.instantiateViewController(identifier: "popUpViewController") as? popUpViewController else {return}
            vc.transectionData = incomeArray[indexPath.row]
            vc.reloadCompletion_ = {
                self.setUpTabel()
            }
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .overCurrentContext
            self.present(nav, animated: true)
        }
        else if tableView == expanseTabel {
            
            guard let vc = self.storyboard?.instantiateViewController(identifier: "popUpViewController") as? popUpViewController else {return}
            vc.transectionData = expenseArray[indexPath.row]
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .overCurrentContext
            self.present(nav, animated: true)
        }
        
        
    }
}

extension TransactionViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == incomeTabel {
            
            return incomeArray.count
        }
        else if tableView == expanseTabel {
            
            return expenseArray.count
        }
        return .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == incomeTabel {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "recemTranjectionTableViewCell") as?  recemTranjectionTableViewCell else {
                return UITableViewCell()
            }
            cell.name.text = incomeArray[indexPath.row].sourceType
            cell.money.text = "$ \(String(incomeArray[indexPath.row].amount ?? 0.0))"
            cell.dateAndTime.text = formatDateToString(date: incomeArray[indexPath.row].date ?? Date())
            cell.imageSymble.image = UIImage(resource: .increase)
            return cell
        }
        else if tableView == expanseTabel {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "recemTranjectionTableViewCell") as?  recemTranjectionTableViewCell else {
                return UITableViewCell()
            }
            cell.name.text = expenseArray[indexPath.row].sourceType
            cell.money.text = "$ \(String(expenseArray[indexPath.row].amount ?? 0.0))"
            cell.dateAndTime.text = formatDateToString(date: expenseArray[indexPath.row].date ?? Date())
            cell.imageSymble.image = UIImage(resource: .decrease)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 3
    }
    
    func formatDateToString(date: Date, format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: date)
    }
    
    func formatDateToString2(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM" // Only day and short month
        return formatter.string(from: date).uppercased()
    }


//    public func reloadData()
//    {
//        print("reload")
//        incomeArray.removeAll()
//        expenseArray.removeAll()
//        
//        transactionArray = transactionManager.getAllTransactions() ?? []
//        
//        if  !transactionArray.isEmpty {
//            
//            for transaction in transactionArray {
//                
//                if transaction.Finance == "income" {
//                    
//                    incomeArray.append(transaction)
//                    
//                }
//                else {
//                    
//                    expenseArray.append(transaction)
//                    
//                }
//                
//            }
//            
//        }
//        
//        DispatchQueue.main.async {
//            
//            self.incomeTabel.reloadData()
//            self.expanseTabel.reloadData()
//            self.setData()
//        }
//        
//
//    }
    
    
}
