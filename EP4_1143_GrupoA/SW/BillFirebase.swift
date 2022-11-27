//
//  BillFirebase.swift
//  EP4_1143_GrupoA
//
//  Created by user214262 on 11/27/22.
//

import UIKit
import FirebaseFirestore

class BillFirebase: NSObject {
    
    static private let db = Firestore.firestore()
    
    static func list(response: @escaping(Array<BillCollection>) -> Void){
        db.collection("Bills").getDocuments { querySnapshot, error in
            if let error = error {
                print("Error getting documents \(error)")
                return
            }
            
            var list = Array<BillCollection>()
            for document in querySnapshot!.documents {
                let data = document.data()
                
                do {
                    let json = try JSONSerialization.data(withJSONObject:  data)
                    let bill = try JSONDecoder().decode(Bill.self, from: json) // Obtain data
                    let billCollection = BillCollection(id: document.documentID, data: bill) // Create bill (with id obtained from doc)
                    
                    list.append(billCollection)
                    
                }catch {
                    print("Error on try to decode a bill object")
                }
            }
            
            response(list)
        }
    }
    
    static func add(data: [String: Any], completionHandler: @escaping(Bool) -> Void){
        db.collection("Bills").document().setData(data) { err in
            var isCorrect: Bool = true
            if let err = err {
                print("Error writing bill to Firestore: \(err)")
                isCorrect = false
            }

            completionHandler(isCorrect)
        }
    }
    
    static func update(id: String, data: [String: Any], completionHandler: @escaping(Bool) -> Void){
        db.collection("Bills").document(id).setData(data) { err in
            var isCorrect: Bool = true
            if let err = err {
                print("Error updating bill to Firestore: \(err)")
                isCorrect = false
            }

            completionHandler(isCorrect)
        }
    }
    
    static func delete(id: String, completionHandler: @escaping(Bool) -> Void){
        db.collection("Bills").document(id).delete() { err in
            var isCorrect: Bool = true
            if let err = err {
                print("Error removing bill to Firestore: \(err)")
                isCorrect = false
            }

            completionHandler(isCorrect)
        }
    }

}
