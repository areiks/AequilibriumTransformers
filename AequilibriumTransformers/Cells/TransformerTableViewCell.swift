//
//  TransformerTableViewCell.swift
//  AequilibriumTransformers
//
//  Created by Lucas Skierkowski on 30/12/2020.
//

import UIKit
import SDWebImage

/**
 Responsible for the presentation of `Transformer` in `TranformersListViewController`
 Contains transformer parameters labels, team image and overall rating label. 
 */
class TransformerTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var teamImageView: UIImageView!
    @IBOutlet weak var strengthLabel: UILabel!
    @IBOutlet weak var intelligenceLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var enduranceLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var courageLabel: UILabel!
    @IBOutlet weak var firepowerLabel: UILabel!
    @IBOutlet weak var skillLabel: UILabel!
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var overallLabel: UILabel!

    ///Setup of the cell for the given transformer
    ///- parameter transformer: transformer used of presentation of the data
    func setupCell(transformer: Transformer) {
        nameLabel.text = transformer.name
        if let url = URL(string: transformer.teamIcon ?? "") {
            teamImageView.sd_setImage(with: url, completed: nil)
        }
        teamLabel.text = transformer.team.name()
        strengthLabel.text = "Strength: \(transformer.strength)"
        intelligenceLabel.text = "Intelligence: \(transformer.intelligence)"
        speedLabel.text = "Speed: \(transformer.speed)"
        enduranceLabel.text = "Endurance: \(transformer.endurance)"
        rankLabel.text = "Rank: \(transformer.rank)"
        courageLabel.text = "Courage: \(transformer.courage)"
        firepowerLabel.text = "Firepower: \(transformer.firepower)"
        skillLabel.text = "Skill: \(transformer.skill)"
        overallLabel.text = "Overall rating: \(transformer.overallRating())"
    }
    
    override func prepareForReuse() {
        nameLabel.text = nil
        teamImageView.sd_cancelCurrentImageLoad()
        teamImageView.image = nil
        teamLabel.text = nil
        strengthLabel.text = nil
        intelligenceLabel.text = nil
        speedLabel.text = nil
        enduranceLabel.text = nil
        rankLabel.text = nil
        courageLabel.text = nil
        firepowerLabel.text = nil
        skillLabel.text = nil
    }
    
}
