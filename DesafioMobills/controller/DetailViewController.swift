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
    
    var moviment: Moviment?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Detalhes"
        detailLabel.text = moviment!.description
        valueLabel.text = "R$ \(moviment!.value)"
    }
    @IBAction func pressedEditButton(_ sender: Any) {
        let vcMoviment = SaveEditMovimentViewController.instantiate()
        vcMoviment.moviment = moviment!
        self.navigationController?.pushViewController(vcMoviment, animated: true)
    }
}
