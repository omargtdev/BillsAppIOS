//
//  BillTableCell.swift
//  EP4_1143_GrupoA
//
//  Created by user214262 on 11/29/22.
//

import UIKit

class BillTableCell: UITableViewCell {

    @IBOutlet weak var lblDescription: UITextField!
    @IBOutlet weak var lblSoles: UITextField!
    @IBOutlet weak var lblDollars: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
