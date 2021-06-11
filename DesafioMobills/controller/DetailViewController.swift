//
//  DetailViewController.swift
//  DesafioMobills
//
//  Created by Alexandre Robaert on 11/06/21.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var effectedLabel: UILabel!
    
    var moviment: Moviment?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Detalhes"
        setupView()
    }
    
    func setupView(){
        let formater = DateFormatter()
        formater.dateStyle = .short
        formater.dateFormat = "dd/MM/yy"
        dateLabel.text = formater.string(from: moviment!.date)
        detailLabel.text = moviment!.description
        valueLabel.text = "R$ \(moviment!.value)"
        
        if moviment!.effected {
            effectedLabel.text = "Efetivado"
            effectedLabel.textColor = .green
        }else{
            effectedLabel.text = "Não Efetivado"
            effectedLabel.textColor = .red
        }
    }
    
    @IBAction func pressedEditButton(_ sender: Any) {
        let vcMoviment = SaveEditMovimentViewController.instantiate()
        vcMoviment.moviment = moviment!
        self.navigationController?.pushViewController(vcMoviment, animated: true)
    }
}
