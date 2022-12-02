//
//  BillsTableVC.swift
//  EP4_1143_GrupoA
//
//  Created by user214262 on 11/29/22.
//

import UIKit
import Floaty

class BillsTableVC: UITableViewController, BillDelegate {
    

    @IBOutlet var tblBills: UITableView!
    private var bills: Array<BillCollection> = []
    
    private var billSelected: BillCollection?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showFloatingButton()
        reloadData()
    }

    private func showFloatingButton(){
        let floaty = Floaty()
        floaty.buttonImage = UIImage(systemName: "circle.righthalf.filled")
        floaty.buttonColor = UIColor.systemBlue
        //floaty.itemButtonColor = UIColor.white
        floaty.addItem("Agregar", icon: UIImage(systemName: "plus")) { item in
            self.performSegue(withIdentifier: "goCreate", sender: nil)
        }
        floaty.paddingY = 100
        self.view.addSubview(floaty)
    }
    
    private func reloadData(){
        BillBC.list { billsResponse in
            self.bills = billsResponse
            self.tblBills.reloadData()
        }
    }
    
    func add(bill: Bill, completionHandler: @escaping (Bool) -> Void) {
        BillBC.add(bill: bill) { isCorrect in
            if isCorrect {
                self.reloadData()
            }
            
            completionHandler(isCorrect)
        }
    }
    
    func update(bill: BillCollection, completionHandler: @escaping (Bool) -> Void) {
        BillBC.update(bill: bill) { isCorrect in
            if isCorrect {
                self.reloadData()
            }
            
            completionHandler(isCorrect)
        }
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return bills.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "billCell", for: indexPath) as! BillTableCell

        // Configure the cell...
        let bill: BillCollection = bills[indexPath.row]
        cell.lblDescription.text = bill.data.description
        cell.lblSoles.text = String(bill.data.getPriceInSoles())
        cell.lblDollars.text = String(bill.data.getPriceInDollars())
        
        // Add click event
        let clickRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tableViewCellClick))
        cell.addGestureRecognizer(clickRecognizer)

        return cell
    }
    
    @objc func tableViewCellClick(sender: UITapGestureRecognizer){
        let tapLocation = sender.location(in: tblBills)
        let indexPath = self.tableView.indexPathForRow(at: tapLocation)
        let position = indexPath?.row ?? 0
        billSelected = bills[position]
        
        self.performSegue(withIdentifier: "goUpdate", sender: nil)
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let askDeleteAlert = UIAlertController(title: "Eliminar", message: "Desea eliminar el gasto?", preferredStyle: .alert)
            
            // Eliminar
            askDeleteAlert.addAction(UIAlertAction(title: "Si", style: .default, handler: { action in
                // Delete the row from the data source
                let bill = self.bills[indexPath.row]
                BillBC.delete(id: bill.id) { isCorrect in
                    if isCorrect {
                        self.bills.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                        self.deletedMessage()
                    }
                }
            }))
            askDeleteAlert.addAction(UIAlertAction(title: "No", style: .default))
            
            present(askDeleteAlert, animated: true)
        }
    }
    
    func deletedMessage(){
        let deletedAlert = UIAlertController(title: "Correcto", message: "Se ha eliminado correctamente", preferredStyle: .alert)
        deletedAlert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(deletedAlert, animated: true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goUpdate" {
            
            let controller = segue.destination as? BillMaintainerViewController
            controller?.listener = self
            controller?.billSelected = billSelected
        }
        
        if segue.identifier == "goCreate" {
            let controller = segue.destination as? BillMaintainerViewController
            controller?.listener = self
        }
    }
    

}
