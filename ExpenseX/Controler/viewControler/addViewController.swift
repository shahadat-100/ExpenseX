//
//  addViewController.swift
//  ExpenseX
//
//  Created by shahadat on 3/2/25.
//

import UIKit

class addViewController: UIViewController {

    
    
    @IBOutlet weak var PageName:UILabel!
    @IBOutlet weak var amountTextFild: UITextField!
    @IBOutlet weak var SourceNametextFild: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var PageNAmeValue:String?
    let transactionManager = TransactionManager()
    var transectionData : TransactionModel?
    
    var reloadCompletion: (() -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        PageName.text = PageNAmeValue ?? ""
        
    
        
        amountTextFild.delegate = self
        SourceNametextFild.delegate = self

        if let transectionData = transectionData {
            
            setPlaceholderColor(for: amountTextFild, placeholderText: String(transectionData.amount ?? 0.0))
            setPlaceholderColor(for: SourceNametextFild, placeholderText: transectionData.sourceType ?? "")
        }
        else
        {
            setPlaceholderColor(for: amountTextFild, placeholderText: "Total Amount")
            setPlaceholderColor(for: SourceNametextFild, placeholderText: "Source Type")
        }
        
        
    }
    
    // Helper function to set placeholder text and color
    func setPlaceholderColor(for textField: UITextField, placeholderText: String) {
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
    }
    @IBAction func goBack(_ sender: Any) {
        
        amountTextFild.resignFirstResponder()
        SourceNametextFild.resignFirstResponder()
        
        if PageNAmeValue == "Add Income"
        {
            let amount = Double(amountTextFild.text ?? "0") ?? 0
            
            let transaction = TransactionModel(id:UUID(),amount:amount,sourceType: SourceNametextFild.text,Finance: "income",date: datePicker.date)
        
            transactionManager.addTransaction(transaction)
            self.navigationController?.dismiss(animated: true)
        }
        else  if PageNAmeValue == "Add Expense"
        {
            let amount = Double(amountTextFild.text ?? "0") ?? 0
            
            let transaction = TransactionModel(id:UUID(),amount:amount,sourceType: SourceNametextFild.text,Finance: "expense",date: datePicker.date)
        
            transactionManager.addTransaction(transaction)
            self.navigationController?.dismiss(animated: true)
            
            
        }
        else if PageNAmeValue == "Edit Transaction"
        {
            if let transectionData = transectionData
            {
                let amount = Double(amountTextFild.text ?? "0") ?? 0
                let transaction = TransactionModel(id:transectionData.id,amount:amount,sourceType: SourceNametextFild.text,Finance:transectionData.Finance,date: transectionData.date)
               
                 if transactionManager.updateTransaction(transaction)
                 {
                     print("Transaction Updated")
                     reloadCompletion?()
                     self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)

                 }
            }
        }
        else if PageNAmeValue == "Remove Transaction"
        {
            if let transectionData = transectionData
            {
                let alertController = UIAlertController(title: "Are you sure?", message: "You want to delete this transaction", preferredStyle: .alert)
                let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
                    
                    if self.transactionManager.removeTransaction(by: transectionData.id)
                    {
                        print("Transaction Deleted")
                        self.reloadCompletion?()
                        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                    }
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                {
                    (_) in
                    self.reloadCompletion?()
                    self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                    
                }
                alertController.addAction(deleteAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true)
            }
        }
        
       //
    }
}


extension addViewController:UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == amountTextFild
        {
            SourceNametextFild.becomeFirstResponder()
        }
        else if textField == SourceNametextFild
        {
            SourceNametextFild.resignFirstResponder()
        }
        
        return true
    }
}
