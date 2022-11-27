//
//  Bill.swift
//  EP4_1143_GrupoA
//
//  Created by user214262 on 11/27/22.
//

import Foundation

public struct Bill : Codable {
    
    let description: String?
    let category: String?
    let count: Int?
    let isInDollars: Bool?
    let unitPrice: Double?
    
    private enum CodingKeys: String, CodingKey {
        case description
        case category
        case count
        case isInDollars
        case unitPrice
    }
    
}
