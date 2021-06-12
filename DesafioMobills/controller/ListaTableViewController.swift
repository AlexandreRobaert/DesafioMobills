//
//  ListaTableViewController.swift
//  DesafioMobills
//
//  Created by Alexandre Robaert on 10/06/21.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class ListaTableViewController: UITableViewController {
    
    var moviments:[Moviment] = []
    var db: Firestore?
    var indexPathSelected: IndexPath?
    let uid = UserDefaults.standard.string(forKey: "UID")!
    let nameUser = UserDefaults.standard.string(forKey: "NAME")

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        title = nameUser
        db = Firestore.firestore()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        cell.detailTextLabel?.text = "R$ \(moviments[indexPath.row].value)"

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
            self.indexPathSelected = indexPath
            showAlertDelete(message: moviments[indexPath.row].description)
        }  
    }
    
    //MARK: - Methods
    func loadMoviments(){
        self.moviments.removeAll()
        db!.collection("moviments").document(uid).collection("mov").getDocuments { querySnaptshot, error in
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
    
    func deleteMoviment(){
        db!.collection("moviments").document(uid).collection("mov").document(moviments[indexPathSelected!.row].id!).delete()
        moviments.remove(at: indexPathSelected!.row)
        tableView.deleteRows(at: [indexPathSelected!], with: .fade)
    }
    
    func showAlertDelete(message: String){
        let alertController = UIAlertController(title: "Excluir?", message: "\(message)", preferredStyle: .alert)
        let actionDelete = UIAlertAction(title: "Excluir", style: .default) { alertAction in
            self.deleteMoviment()
        }
        let actionCancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alertController.addAction(actionDelete)
        alertController.addAction(actionCancel)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func buttonAddPressed(_ sender: Any) {
        performSegue(withIdentifier: "segueSaveEdit", sender: nil)
    }
    
    @IBAction func signOutPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            if let appDomain = Bundle.main.bundleIdentifier {
                UserDefaults.standard.removePersistentDomain(forName: appDomain)
            }
            navigationController?.dismiss(animated: false, completion: nil)
            let navigationLogin = UINavigationController(rootViewController: LoginViewController())
            self.present(navigationLogin, animated: true, completion: nil)
        }catch let signOutError as NSError{
            print("Erro logOff \(signOutError)")
        }
    }
}
