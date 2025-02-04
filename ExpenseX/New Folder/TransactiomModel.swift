//
//  TransactiomModel.swift
//  ExpenseX
//
//  Created by shahadat on 3/2/25.
//

import Foundation

class TransactionModel {
    
    let id : UUID
    var amount: Double?
    var sourceType: String?
    var Finance: String?
    var date: Date?
    
    init(id: UUID, amount: Double? = nil, sourceType: String? = nil, Finance: String? = nil, date: Date? = nil) {
        self.id = id
        self.amount = amount
        self.sourceType = sourceType
        self.Finance = Finance
        self.date = date
    }
    
}
