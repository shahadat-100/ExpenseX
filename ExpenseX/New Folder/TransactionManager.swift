//
//  TransactionManager.swift
//  ExpenseX
//
//  Created by shahadat on 3/2/25.
//

import Foundation

struct TransactionManager {
    
    private let _transactionRepository = TransactionRepository()
    

    func addTransaction(_ transaction: TransactionModel)
    {
        _transactionRepository.addTransaction(transaction)
    }
    
    func getAllTransactions() -> [TransactionModel]?
    {
        return _transactionRepository.getAllTransactions()
    }
    
    func getTransaction(by id: UUID) -> TransactionModel?
    {
        return _transactionRepository.getTransaction(by: id)
    }
    
    func updateTransaction(_ transaction: TransactionModel) -> Bool
    {
        return _transactionRepository.updateTransaction(transaction)
    }
    
    func removeTransaction(by id: UUID) -> Bool
    {
        _transactionRepository.removeTransaction(by: id)
    }
    
    
}
