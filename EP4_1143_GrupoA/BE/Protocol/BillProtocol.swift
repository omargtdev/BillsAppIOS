//
//  BillProtocol.swift
//  EP4_1143_GrupoA
//
//  Created by user214262 on 11/29/22.
//

import Foundation

protocol BillDelegate {
    
    func add(bill: Bill, completionHandler: @escaping(Bool) -> Void)
    func update(bill: BillCollection, completionHandler: @escaping(Bool) -> Void)
}
