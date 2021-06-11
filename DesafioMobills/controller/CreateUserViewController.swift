//
//  CreateUserViewController.swift
//  DesafioMobills
//
//  Created by Alexandre Robaert on 11/06/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class CreateUserViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var messageErrorLabel: UILabel!
    
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handle = Auth.auth().addStateDidChangeListener({ Auth, user in
            
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    @IBAction func createButtonPressed(_ sender: Any) {
        createUser()
    }
    
    func createUser(){
        if let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                guard let userFireDb = authResult?.user, error == nil else {
                    self.messageErrorLabel.text = "Não conseguimos lhe cadastrar"
                    self.messageErrorLabel.isHidden = false
                    return
                }
                let user = User(id: userFireDb.uid, name: name, email: email, password: password)
                self.saveUserDb(user: user) { result in
                    if result {
                        self.navigationController?.popToRootViewController(animated: true)
                    }else{
                        self.messageErrorLabel.text = "Problema ao salvar Usuário"
                        self.messageErrorLabel.isHidden = false
                    }
                }
            }
        }
    }
    
    func saveUserDb(user: User, completion: @escaping(Bool) -> Void){
        Firestore.firestore().collection("users").document(user.id).setData(user.toDictinary()) { error in
            completion(false)
        }
        completion(true)
    }
    
}
