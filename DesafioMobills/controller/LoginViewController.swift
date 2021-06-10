//
//  LoginViewController.swift
//  DesafioMobills
//
//  Created by Alexandre Robaert on 10/06/21.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handle = Auth.auth().addStateDidChangeListener { Auth, user in
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }

    @IBAction func loginTouchUp(_ sender: Any) {
        
    }
    
    func createUser(for user: User){
        
        
        Auth.auth().createUser(withEmail: user.email, password: user.password) { authResult, error in
            guard let resultSelf = authResult else {return}
            print(resultSelf.user.displayName)
        }
    }
}
