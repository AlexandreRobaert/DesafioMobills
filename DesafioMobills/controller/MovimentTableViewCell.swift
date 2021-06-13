//
//  MovimentTableViewCell.swift
//  DesafioMobills
//
//  Created by Alexandre Robaert on 12/06/21.
//

import UIKit

class MovimentTableViewCell: UITableViewCell {

    @IBOutlet weak var imageStatusImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configCell(moviment: Moviment){
        descriptionLabel.text = "\(moviment.description)"
        let format = DateFormatter()
        format.dateStyle = .short
        format.dateFormat = "dd/MM/yy"
        dateLabel.text = format.string(from: moviment.date)
        valueLabel.text = String(format: "R$ %.2f", moviment.value)
        let imageString = moviment.expose ? "rectangle.badge.minus" : "rectangle.badge.plus"
        imageStatusImageView.image = UIImage(systemName: imageString)
        
        var color = UIColor()
        if moviment.effected{
            color = .darkGray
        }else if !moviment.effected && moviment.expose{
            color = .red
        }else{
            color = .green
        }
        valueLabel.textColor = color
    }
}
