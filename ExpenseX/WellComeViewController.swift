//
//  WellComeViewController.swift
//  ExpenseX
//
//  Created by shahadat on 1/2/25.
//

import UIKit

class WellComeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func goLogin(_ sender: Any) {
        
        print("tapped")
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {return}
        self.navigationController?.pushViewController(vc, animated: true)
      
    }
    
    
}
