//
//  BillExtension.swift
//  EP4_1143_GrupoA
//
//  Created by user214262 on 12/1/22.
//

import Foundation

extension Bill {
    
    func getTotalPrice() -> Double {
        return Double(round(100 * (Double(count!) * unitPrice!)) / 100) // Redondear a 2 decimales
    }
    
    func getPriceInSoles() -> Double {
        var totalPrice =  Double(count!) * unitPrice!
        if isInDollars! {
            totalPrice = totalPrice * 3.90
        }
        
        return Double(round(100 * totalPrice) / 100) // Redondear a 2 decimales
    }
    
    func getPriceInDollars() -> Double {
        var totalPrice =  Double(count!) * unitPrice!
        if !isInDollars! {
            totalPrice = totalPrice / 3.90
        }
        
        return Double(round(100 * totalPrice) / 100) // Redondear a 2 decimales
    }
}
