//
//  Transaction+CoreDataProperties.swift
//  ExpenseX
//
//  Created by shahadat on 4/2/25.
//
//

import Foundation
import CoreData


extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var amount: Double
    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var sourceType: String?
    @NSManaged public var finance: String?

}

extension Transaction : Identifiable {

}
