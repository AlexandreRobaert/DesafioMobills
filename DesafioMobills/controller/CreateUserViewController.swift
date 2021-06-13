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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        title = "Novo usuário"
        
    }
    
    @IBAction func createButtonPressed(_ sender: Any) {
        createUser()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func createUser(){
        if let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text {
            if let passwordRepeat = repeatPasswordTextField.text, passwordRepeat == password {
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    guard let userFireDb = authResult?.user, error == nil else {
                        self.messageErrorLabel.text = "Não conseguimos lhe cadastrar"
                        self.messageErrorLabel.isHidden = false
                        return
                    }
                    
                    let changeRequest = userFireDb.createProfileChangeRequest()
                    changeRequest.displayName = name
                    changeRequest.commitChanges(completion: nil)
                    
                    UserDefaults.standard.setValue(userFireDb.uid, forKey: "UID")
                    UserDefaults.standard.setValue(name, forKey: "NAME")
                    
                    let user = User(id: userFireDb.uid, name: name, email: email, password: password)
                    self.saveUserDb(user: user) { result in
                        if result {
                            self.toListViewController()
                        }else{
                            self.messageErrorLabel.text = "Problema ao salvar Usuário"
                            self.messageErrorLabel.isHidden = false
                        }
                    }
                }
            }else{
                passwordTextField.text = ""
                repeatPasswordTextField.text = ""
                messageErrorLabel.text = "As Senhas não são iguais"
                messageErrorLabel.isHidden = false
            }
        }
    }
    
    func saveUserDb(user: User, completion: @escaping(Bool) -> Void){
        Firestore.firestore().collection("users").document(user.id).setData(user.toDictinary()) { error in
            if error != nil {
                completion(false)
            }else{
                completion(true)
            }
        }
    }
    
    func toListViewController(){
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "storyNavigationController") as! UINavigationController
        self.navigationController?.popToRootViewController(animated: false)
        self.navigationController?.dismiss(animated: false, completion: nil)
        self.present(controller, animated: true, completion: nil)
    }
    
}
