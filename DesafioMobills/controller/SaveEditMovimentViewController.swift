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
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var efetivadoLabel: UILabel!
    @IBOutlet weak var efetivadoSwitch: UISwitch!
    
    var db: Firestore?
    var moviment: Moviment?
    let datePicker = UIDatePicker()
    let dateFormat = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        setupView()
        loadMoviment()
        setDatePickerInTextField()
        
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
        if let _ = moviment {
            navigationItem.title = "Editar Movimento"
            efetivadoLabel.isHidden = false
            efetivadoSwitch.isHidden = false
        }else{
            navigationItem.title = "Novo Movimento"
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func loadMoviment(){
        if let moviment = self.moviment {
            descriptionTextField.text = moviment.description
            dateTextField.text = dateFormat.string(from: moviment.date)
            valueTextField.text = String("\(moviment.value)")
            efetivadoSwitch.isOn = moviment.effected
        }
    }
    
    func getMovimentFromForm() -> Bool {
        if let dateText = dateTextField.text, dateText.count > 0 {
            if let date = dateFormat.date(from: dateText), let value = Float(valueTextField.text!), let description = descriptionTextField.text{
                
                if let _ = moviment {
                    self.moviment?.description = description
                    self.moviment?.date = date
                    self.moviment?.value = value
                    self.moviment?.effected = efetivadoSwitch.isOn
                }else{
                    self.moviment = Moviment(value: value, description: description, date: date, expose: true)
                }
                
                return true
            }
        }
        return false
    }
    
    func saveMoviment(){
        if getMovimentFromForm(){
            self.indicator.isHidden = false
            var err: Error?
            if let id = self.moviment?.id {
                db!.collection("moviments").document("\(id)").setData(moviment!.toDictionary()) { error in
                    err = error
                }
            }else{
                db!.collection("moviments").addDocument(data: self.moviment!.toDictionary()) { error in
                    err = error
                }
            }
            
            if let _ = err {
                self.showAlertResult(message: "Falha ao salvar Movimento!")
            }else{
                self.showAlertResult(message: "Salvo \(self.moviment!.description)")
            }
            
            self.indicator.isHidden = true
        }else{
            print("Não foi")
        }
    }
    
    func setDatePickerInTextField(){
        datePicker.datePickerMode = .date
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 50))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true)
        self.dateTextField.inputView = datePicker
        self.dateTextField.inputAccessoryView = toolbar
    }
    
    @objc func donePressed(){
        dateTextField.text = dateFormat.string(from: datePicker.date)
        self.view.endEditing(true)
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


