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
        
        
        // Change text color to white
        barChartView2.xAxis.labelTextColor = .white
        barChartView2.leftAxis.labelTextColor = .white
        barChartView2.legend.textColor = .white
        barChartView2.noDataTextColor = .white
    }
    
    private func setData() {
        let days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        let values: [Double] = [220, 920, 650, 1140, 1280, 1220, 170]  // Example values
        
        var dataEntries: [BarChartDataEntry] = []
        
        for (index, value) in values.enumerated() {
            let entry = BarChartDataEntry(x: Double(index), y: value)
            dataEntries.append(entry)
        }
        
        let dataSet = BarChartDataSet(entries: dataEntries, label: "Transactions")
        dataSet.colors = ChartColorTemplates.joyful()
        dataSet.valueTextColor = .white
        dataSet.valueFont = .systemFont(ofSize: 12)
        
        let data = BarChartData(dataSet: dataSet)
        barChartView1.data = data
        
        // Set custom x-axis labels
        barChartView1.xAxis.valueFormatter = IndexAxisValueFormatter(values: days)
        
        
        let days1 = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        let values1: [Double] = [320, 92, 250, 110, 180, 220, 470]  // Example  values
        
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
}

extension TransactionViewController : UITableViewDelegate
{
    
}

extension TransactionViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == incomeTabel {
            
            return 14
        }
        else if tableView == expanseTabel {
            
            return 8
        }
        return .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == incomeTabel {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "recemTranjectionTableViewCell") as?  recemTranjectionTableViewCell else {
                return UITableViewCell()
            }
            if indexPath.row % 2 == 0 {
                
                cell.imageSymble.image = UIImage(resource: .increase)
                cell.money.text = "+ $ 2000000"
                cell.name.text = "Payment"
            }
            else
            {
                cell.imageSymble.image = UIImage(resource: .increase)
                cell.money.text = "+ $ 40000"
                cell.name.text = "Tuition"
            }
            return cell
        }
        else if tableView == expanseTabel {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "recemTranjectionTableViewCell") as?  recemTranjectionTableViewCell else {
                return UITableViewCell()
            }
            if indexPath.row % 2 == 0 {
                
                cell.imageSymble.image = UIImage(resource: .decrease)
                cell.money.text = "- $ 2000000"
                cell.name.text = "bill"
            }
            else
            {
                cell.imageSymble.image = UIImage(resource: .decrease)
                cell.money.text = "- $ 40000"
                cell.name.text = "books"
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 3
    }
    
}
