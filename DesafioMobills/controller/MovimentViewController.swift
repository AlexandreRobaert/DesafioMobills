//
//  ViewController.swift
//  DesafioMobills
//
//  Created by Alexandre Robaert on 10/06/21.
//

import UIKit
import FirebaseFirestore

class MovimentViewController: UIViewController {

    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var db: Firestore?
    var moviment: Moviment?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
    }

    @IBAction func saveTouchUp(_ sender: Any) {
        saveMoviment()
    }
    
    func getMoviment() -> Bool {
        if let dateText = dateTextField.text {
            let formater = DateFormatter()
            formater.dateFormat = "dd/MM/yyyy"
            if let date = formater.date(from: dateText), let value = Float(valueTextField.text!), let description = descriptionTextField.text{
                self.moviment = Moviment(value: value, description: description, date: date, expose: true)
                return true
            }
        }
        return false
    }
    
    func saveMoviment(){
        if getMoviment(){
            self.indicator.isHidden = false
            db!.collection("moviments").addDocument(data: self.moviment!.toDictionary()) { error in
                if let _ = error {return}
                print("Cadastrou \(self.moviment!.description)")
                self.indicator.isHidden = true
            }
        }else{
            print("Não foi")
        }
    }
}

