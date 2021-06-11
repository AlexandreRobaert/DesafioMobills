//
//  ListaTableViewController.swift
//  DesafioMobills
//
//  Created by Alexandre Robaert on 10/06/21.
//

import UIKit
import FirebaseFirestore

class ListaTableViewController: UITableViewController {
    
    var moviments:[Moviment] = []
    var db: Firestore?

    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadMoviments()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return moviments.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = moviments[indexPath.row].description

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vcDetail = DetailViewController()
        vcDetail.moviment = moviments[indexPath.row]
        self.navigationController?.pushViewController(vcDetail, animated: true)
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    //MARK: - Methods
    func loadMoviments(){
        self.moviments.removeAll()
        db!.collection("moviments").getDocuments { querySnaptshot, error in
            if let err = error {
                print("Erro ao buscar Movimentos - \(err)")
            }else{
                for document in querySnaptshot!.documents {
                    self.moviments.append(Moviment(id: document.documentID, data: document.data()))
                }
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func buttonAddPressed(_ sender: Any) {
        let vcMoviment = SaveEditMovimentViewController.instantiate()
        navigationController?.pushViewController(vcMoviment, animated: true)
    }
}
