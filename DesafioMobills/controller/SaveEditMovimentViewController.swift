//
//  ViewController.swift
//  DesafioMobills
//
//  Created by Alexandre Robaert on 10/06/21.
//

import UIKit
import FirebaseFirestore

class SaveEditMovimentViewController: UIViewController {

    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var efetivadoLabel: UILabel!
    @IBOutlet weak var efetivadoSwitch: UISwitch!
    @IBOutlet weak var receitaLabel: UILabel!
    @IBOutlet weak var receitaSwitch: UISwitch!
    @IBOutlet weak var messageErrorLabel: UILabel!
    
    var db: Firestore?
    var moviment: Moviment?
    let dateFormat = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        setupView()
    }
    
    static func instantiate() -> SaveEditMovimentViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MovimentViewController") as SaveEditMovimentViewController
    }

    @IBAction func saveTouchUp(_ sender: Any) {
        saveMoviment()
    }
    
    func setupView(){
        dateFormat.dateStyle = .short
        dateFormat.dateFormat = "dd/MM/yyyy"
        if let moviment = moviment {
            navigationItem.title = "Editar Movimento"
            efetivadoLabel.isHidden = false
            efetivadoSwitch.isHidden = false
            efetivadoSwitch.isOn = moviment.effected
            valueTextField.textColor = moviment.expose ? .red : .green
            descriptionTextField.text = moviment.description
            datePicker.date = moviment.date
            valueTextField.text = String("\(moviment.value)")
            receitaSwitch.isOn = !moviment.expose
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func receitaValueChange(_ sender: UISwitch) {
        valueTextField.textColor = sender.isOn ? .green : .red
    }
    
    func getMovimentFromForm() -> Bool {
        if let value = Float(valueTextField.text!), let description = descriptionTextField.text{
            
            if let _ = moviment {
                self.moviment?.description = description
                self.moviment?.date = datePicker.date
                self.moviment?.value = value
                self.moviment?.effected = efetivadoSwitch.isOn
                self.moviment?.expose = !receitaSwitch.isOn
            }else{
                self.moviment = Moviment(value: value, description: description, date: datePicker.date, expose: !receitaSwitch.isOn)
            }
            
            return true
        }
        return false
    }
    
    func saveMoviment(){
        let uid = UserDefaults.standard.string(forKey: "UID")!
        if getMovimentFromForm(){
            self.indicator.isHidden = false
            var err: Error?
            if let id = self.moviment?.id {
                db!.collection("moviments").document(uid).collection("mov").document(id).setData(moviment!.toDictionary()) {
                    err = $0
                }
            }else{
                db!.collection("moviments").document(uid).collection("mov").addDocument(data: moviment!.toDictionary()) {
                    err = $0
                }
            }
            
            if let _ = err {
                self.showAlertResult(message: "Falha ao salvar Movimento!")
            }else{
                self.showAlertResult(message: "\(self.moviment!.description)")
            }
            self.indicator.isHidden = true
        }else{
            messageErrorLabel.text = "Campos devem ser preenchidos corretamente!"
            messageErrorLabel.isHidden = false
        }
    }
    
    func showAlertResult(message: String){
        let alertController = UIAlertController(title: "Salvo", message: "\(message)", preferredStyle: .alert)
        let actionDone = UIAlertAction(title: "OK", style: .default) { alertAction in
            self.navigationController?.popToRootViewController(animated: true)
        }
        alertController.addAction(actionDone)
        present(alertController, animated: true, completion: nil)
    }
}


