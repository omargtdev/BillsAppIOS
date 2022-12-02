//
//  BillCollection.swift
//  EP4_1143_GrupoA
//
//  Created by user214262 on 11/27/22.
//

import UIKit

class BillCollection: NSObject {
    
    let id: String
    let data: Bill
    
    init(id: String, data: Bill) {
        self.id = id
        self.data = data
    }
    
}
