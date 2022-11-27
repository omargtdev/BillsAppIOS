//
//  BillBC.swift
//  EP4_1143_GrupoA
//
//  Created by user214262 on 11/27/22.
//

import UIKit

class BillBC: NSObject {
    
    class func list(completionHandler: @escaping(Array<BillCollection>) -> Void) {
        BillFirebase.list { bills in
            completionHandler(bills)
        }
    }
    
    class private func billToArrayData(bill: Bill) -> [String: Any] {
        return [
            "description": bill.description ?? "",
            "category": bill.category ?? "",
            "count": bill.count ?? 0,
            "isInDollars": bill.isInDollars ?? false,
            "unitPrice": bill.unitPrice ?? 0
        ]
    }
    
    class func add(bill: Bill, completionHandler: @escaping(Bool) -> Void){
        let data: [String: Any] = billToArrayData(bill: bill)
        
        BillFirebase.add(data: data) { isCorrect in
            completionHandler(isCorrect)
        }
    }
    
    class func update(bill: BillCollection, completionHandler: @escaping(Bool) -> Void){
        let data: [String: Any] = billToArrayData(bill: bill.data)
        
        BillFirebase.update(id: bill.id, data: data) { isCorrect in
            completionHandler(isCorrect)
        }
    }
    
    class func delete(id: String, completionHandler: @escaping(Bool) -> Void){
        BillFirebase.delete(id: id) { isCorrect in
            completionHandler(isCorrect)
        }
    }

}
