//
//  BillMaintainerExtension.swift
//  EP4_1143_GrupoA
//
//  Created by user214262 on 11/29/22.
//

import Foundation
import UIKit


extension BillMaintainerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row]
        return cell
    }
    

   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        btnDropdownCategories.setTitle("\(categories[indexPath.row])", for: .normal)
        animateDropdown(toogle: true)
       categorySelected = categories[indexPath.row]
    }
}
