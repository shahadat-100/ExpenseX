//
//  popUpViewController.swift
//  ExpenseX
//
//  Created by shahadat on 5/2/25.
//

import UIKit

class popUpViewController: UIViewController {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var removeView: UIView!
   
    var reloadCompletion_: (() -> Void)?
    
    var transectionData : TransactionModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.layer.cornerRadius = 10
        editView.layer.cornerRadius = 10
        removeView.layer.cornerRadius = 10

    }
    
    @IBAction func editButton(_ sender: Any) {
        
       
        guard let vc = self.storyboard?.instantiateViewController(identifier: "addViewController") as? addViewController else {return}
        vc.PageNAmeValue = "Edit Transaction"
        vc.transectionData = self.transectionData
        vc.reloadCompletion = { [weak self] in
            self?.reloadCompletion_?()
        }
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
       
    }
    
    @IBAction func removeButton(_ sender: Any) {
        
        guard let vc = self.storyboard?.instantiateViewController(identifier: "addViewController") as? addViewController else {return}
        vc.PageNAmeValue = "Remove Transaction"
        vc.transectionData = self.transectionData
        vc.reloadCompletion = { [weak self] in
            self?.reloadCompletion_?()
        }
        
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)

        
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        
        self.navigationController?.dismiss(animated: true)
        
    }
    
}
