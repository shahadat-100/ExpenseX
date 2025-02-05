//
//  cdtransactionExtention.swift
//  ExpenseX
//
//  Created by shahadat on 3/2/25.
//

import Foundation

extension Transaction
{
    func convertToTransactionModel() -> TransactionModel
    {
        let transactionModel = TransactionModel(id: self.id!,amount: self.amount,sourceType: self.sourceType!,Finance: self.finance!, date: self.date!)
        
        return transactionModel
            
    }
}
