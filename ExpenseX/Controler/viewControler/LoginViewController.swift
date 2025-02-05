//
//  LoginViewController.swift
//  ExpenseX
//
//  Created by shahadat on 1/2/25.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var nameTextFild: UITextField!
    @IBOutlet weak var amountTextFild: UITextField!
    @IBOutlet weak var SourceNametextFild: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    private let transactionManager = TransactionManager()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextFild.delegate = self
        amountTextFild.delegate = self
        SourceNametextFild.delegate = self
        // Set the placeholder text and color for all text fields
        setPlaceholderColor(for: nameTextFild, placeholderText: "Your Name")
        setPlaceholderColor(for: amountTextFild, placeholderText: "Total Amount")
        setPlaceholderColor(for: SourceNametextFild, placeholderText: "Source Type")
        
    }

    // Helper function to set placeholder text and color
    func setPlaceholderColor(for textField: UITextField, placeholderText: String) {
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
    }
    
    @IBAction func GotoHome(_ sender: Any) {
        
        defaults.set(nameTextFild.text, forKey: "userName")
        
        if let userName = defaults.string(forKey: "userName") {
            print("User Name is \(userName)")
            defaults.set(true, forKey: "isSignedIn")
        }
        
        let amount = Double(amountTextFild.text ?? "0") ?? 0
        
        let transaction = TransactionModel(id:UUID(),amount:  amount,sourceType: SourceNametextFild.text,Finance: "income",date: datePicker.date)
    
        transactionManager.addTransaction(transaction)
        
        self.navigationController?.dismiss(animated: true)
    }
}


extension LoginViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == nameTextFild
        {
            amountTextFild.becomeFirstResponder()
        }
        else if textField == amountTextFild
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
