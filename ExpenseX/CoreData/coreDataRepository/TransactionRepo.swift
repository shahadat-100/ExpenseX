//
//  TransactionRepo.swift
//  ExpenseX
//
//  Created by shahadat on 3/2/25.
//
import Foundation
import CoreData

// MARK: - Transaction Repository Protocol
protocol TransactionRepositoryProtocol {
    
    func addTransaction(_ transaction: TransactionModel)
    
    func getAllTransactions() -> [TransactionModel]?
    
    func getTransaction(by id: UUID) -> TransactionModel?
    
    func updateTransaction(_ transaction: TransactionModel) -> Bool
    
    func removeTransaction(by id: UUID) -> Bool
}

// MARK: - Transaction Repository Implementation
struct TransactionRepository: TransactionRepositoryProtocol {
   
    
    func addTransaction(_ transaction: TransactionModel) {
        
        let cdTransaction = Transaction(context: PersistentStorage.shared.context)
       
        cdTransaction.id = transaction.id
        cdTransaction.amount = transaction.amount ?? 0.00
        cdTransaction.sourceType = transaction.sourceType
        cdTransaction.date = transaction.date
        cdTransaction.finance = transaction.Finance
       
        PersistentStorage.shared.saveContext()
        
    }
    
    func getAllTransactions() -> [TransactionModel]? {
        
        var transactions: [TransactionModel] = []
        
        do
        {
            let transactionsData = try PersistentStorage.shared.context.fetch(Transaction.fetchRequest()) as! [Transaction]
            
            transactionsData.forEach { cdTransaction in
                transactions.append(cdTransaction.convertToTransactionModel())
            }
            return transactions
        }
        catch let error as NSError
        {
            print("Could not fetch. \(error)")
        }
        return nil
       
    }
    
    func getTransaction(by id: UUID) -> TransactionModel? {
        
        guard let transactionData = getCD_Transaction(by: id) else { return nil }
        return transactionData.convertToTransactionModel()
    }
    
    func updateTransaction(_ transaction: TransactionModel) -> Bool {
        
        guard let cdTransaction = getCD_Transaction(by: transaction.id) else { return false }
        
        cdTransaction.amount = transaction.amount ?? 0.00
        cdTransaction.sourceType = transaction.sourceType
        cdTransaction.date = transaction.date
        
        PersistentStorage.shared.saveContext()
        
        return true
        
    }
    
    func removeTransaction(by id: UUID) -> Bool {
        
        guard let cdTransaction = getCD_Transaction(by: id) else { return false }
        
        PersistentStorage.shared.context.delete(cdTransaction)
        PersistentStorage.shared.saveContext()
        
        return true
        
    }
    
    
    private func getCD_Transaction (by id: UUID) -> Transaction?
    {
        
        let fetchRQ = Transaction.fetchRequest()
        fetchRQ.predicate = NSPredicate(format: "id==%@", id as CVarArg)
        
        let cdTransaction = try! PersistentStorage.shared.context.fetch(fetchRQ).first
        
        guard cdTransaction != nil else { return nil }
        
        return cdTransaction
        
    }
}

