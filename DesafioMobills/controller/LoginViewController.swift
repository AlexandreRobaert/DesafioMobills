//
//  LoginViewController.swift
//  DesafioMobills
//
//  Created by Alexandre Robaert on 11/06/21.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        cleanFields()
        handle = Auth.auth().addStateDidChangeListener { Auth, user in
            if let user = user {
                UserDefaults.standard.setValue(user.uid, forKey: "UID")
                UserDefaults.standard.setValue(user.displayName, forKey: "NAME")
                
                self.navigationController?.dismiss(animated: false, completion: nil)
                let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "storyNavigationController") as! UINavigationController
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true, completion: nil)
            }
        }
    }
    
    func cleanFields(){
        emailTextField.text = ""
        passwordTextField.text = ""
        errorLabel.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func loginPressed(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if let _ = result?.user {
                    
                }else{
                    self.errorLabel.text = "Usuário/Login Inválido"
                    self.errorLabel.isHidden = false
                }
            }
        }
    }
    @IBAction func pressedCreateButton(_ sender: Any) {
        navigationController?.pushViewController(CreateUserViewController(), animated: true)
    }
    
}
