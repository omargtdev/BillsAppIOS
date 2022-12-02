//
//  BillMaintainerViewController.swift
//  EP4_1143_GrupoA
//
//  Created by user214262 on 11/29/22.
//

import UIKit

class BillMaintainerViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var btnDropdownCategories: UIButton!
    @IBOutlet weak var tblCategories: UITableView!
    @IBOutlet weak var txtCount: UITextField!
    @IBOutlet weak var txtUnitPrice: UITextField!
    @IBOutlet weak var scCurrency: UISegmentedControl!
    @IBOutlet weak var txtTotalPrice: UITextField!
    
    @IBOutlet weak var lblUnitPrice: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    
    @IBOutlet weak var btnAccept: UIButton!
    
    var billSelected: BillCollection!
    var listener: BillDelegate!
    
    var categories = ["OCIO", "CASA", "EDUCACIÓN"]
    var count: Int? = 0
    var categorySelected: String = ""
    var isInDollars: Bool = false
    var unitPrice: Double? = 0
    var totalPrice: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblCategories.isHidden = true
        
        // Add validation for only numbers with a method
        txtCount.delegate = self
        txtUnitPrice.delegate = self
       
        if let bill = billSelected {
            txtDescription.text = bill.data.description
            btnDropdownCategories.setTitle(bill.data.category, for: .normal)
            count = bill.data.count
            unitPrice = bill.data.unitPrice
            isInDollars = bill.data.isInDollars!
            categorySelected = bill.data.category!
            totalPrice = bill.data.getTotalPrice()
            
            txtCount.text = String(count!)
            txtUnitPrice.text = String(unitPrice!)
            txtTotalPrice.text = String(totalPrice)
            
            if isInDollars {
                scCurrency.selectedSegmentIndex = 1
            }
        
        }
        
        changeCurrencyLabel()
        changePrice()
        
        
    }
    
    func resetFields(){
        count = 0
        categorySelected = ""
        isInDollars = false
        unitPrice = 0
        totalPrice = 0
        
        txtDescription.text = ""
        txtCount.text = ""
        txtUnitPrice.text = ""
        txtTotalPrice.text = ""
        btnDropdownCategories.setTitle("Seleccione una categoria", for: .normal)
        changePrice()
        changeCurrencyLabel()
    }

    func changePrice(){
        count = Int(txtCount.text!)
        unitPrice = Double(txtUnitPrice.text!)
        
        if count != nil && unitPrice != nil {
            
            totalPrice = Double(count!) * unitPrice!
            totalPrice =  Double(round(100 * totalPrice) / 100) // Redondear a 2 decimales
            txtTotalPrice.text = String(totalPrice)
            return
        }
        
        count = 0
        unitPrice = 0
        totalPrice = 0
        
        txtTotalPrice.text = ""
    }
    
    func changeCurrencyLabel(){
        if !isInDollars { // Soles
            lblUnitPrice.text = "Precio unitario (S/.)"
            lblTotalPrice.text = "Costo total (S/.)"
            return
        }
        
        // Dolares
        lblUnitPrice.text = "Precio unitario ($)"
        lblTotalPrice.text = "Costo total ($)"
    }
    
    func animateDropdown (toogle: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.tblCategories.isHidden = toogle
        }
    }
    
    // Validar solo numeros en Cantidad
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Handle backspace/delete
        guard !string.isEmpty else {
            return true
        }

        if textField.tag == 2 { // Cantidad
            if !CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) {
                return false
            }
        }
        
        if textField.tag == 3 { // Precio Unitario
            if txtUnitPrice.text!.contains(".") {
                if !CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) {
                    return false
                }
            } else {
                if !CharacterSet(charactersIn: "0123456789.").isSuperset(of: CharacterSet(charactersIn: string)) {
                    return false
                }
            }
        }
        
        
        return true
    }

    @IBAction func onChangeCurrencySelected(_ sender: Any) {
        if scCurrency.selectedSegmentIndex == 0 {
            isInDollars = false
        } else {
            isInDollars = true
        }
        changeCurrencyLabel()
        changePrice()
    }
    
    @IBAction func onClickDropdownCategories(_ sender: Any) {
        tblCategories.isHidden ? animateDropdown(toogle: false) : animateDropdown(toogle: true)
    }
    
    @IBAction func onChangePrice(_ sender: UITextField) {
        changePrice()
    }
    
    @IBAction func onCancelAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCreateAction(_ sender: UIButton) {
        var alert: UIAlertController = UIAlertController(title: "Error", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        
    
        guard let description = txtDescription.text, !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            alert.message = "Debes colocar un producto"
            present(alert, animated: true)
            return
        }
        

        if categorySelected == ""  {
            alert.message = "Debes seleccionar una categoria"
            present(alert, animated: true)
            return
        }
        
        if count == 0 {
            alert.message = "La cantidad debe ser mayor a 0"
            present(alert, animated: true)
            return
        }
        
        if unitPrice == 0 {
            alert.message = "El precio debe ser mayor a 0"
            present(alert, animated: true)
            return
        }
        
        // Disable button
        btnAccept.isEnabled = false
        
        alert = UIAlertController(title: "Correcto", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        let newBill = Bill(description: txtDescription.text, category:     categorySelected, count: count, isInDollars: isInDollars, unitPrice: unitPrice)
        
        if billSelected != nil {
            listener.update(bill: BillCollection(id: billSelected.id, data: newBill)) { isCorrect in
                if isCorrect {
                    alert.message = "Gasto actualizado"
                }else{
                    alert.message =  "Algo ocurrio!"
                }
                
                self.present(alert, animated: true)
                self.btnAccept.isEnabled = true
            }
            return
        }
            
        listener.add(bill: newBill) { isCorrect in
            if isCorrect {
                alert.message =  "Gasto agregado"
                self.resetFields()
            }else{
                alert.message =  "Algo ocurrio!"
            }
            
            self.present(alert, animated: true)
            self.btnAccept.isEnabled = true
        }

    }
    
}
